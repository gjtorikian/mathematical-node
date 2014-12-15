// Copyright (c) 2014 Garen J. Torikian

#include "processor.h"

#include <string.h>
#include <stdlib.h>

#include <limits.h>
#include <lsm.h>
#include <lsmmathml.h>
#include <glib.h>
#include <glib/gi18n.h>
#include <glib/gprintf.h>
#include <gio/gio.h>
#include <cairo-pdf.h>
#include <cairo-svg.h>
#include <cairo-ps.h>
#include <mtex2MML.h>

typedef enum {
  FORMAT_SVG,
  FORMAT_PNG,
  FORMAT_MATHML
} FileFormat;

void Processor::Init(Handle<Object> target) {
  NanScope();

  Local<FunctionTemplate> newTemplate = NanNew<FunctionTemplate>(
      Processor::New);
  newTemplate->SetClassName(NanNew<String>("Processor"));
  newTemplate->InstanceTemplate()->SetInternalFieldCount(1);

  Local<ObjectTemplate> proto = newTemplate->PrototypeTemplate();
  NODE_SET_METHOD(proto, "process", Processor::Process);

  target->Set(NanNew<String>("Processor"), newTemplate->GetFunction());
}

NODE_MODULE(processor, Processor::Init)

NAN_METHOD(Processor::New) {
  NanScope();

  if (args.Length() != 1)
    NanReturnUndefined();

  assert(args[0]->IsObject());

  Processor *processor = new Processor(Local<Object>::Cast(args[0]));
  processor->Wrap(args.This());
  NanReturnUndefined();
}

Processor::Processor(Handle<Object> options) {
  NanScope();

  mPpi = options->Get(NanNew<String>("ppi"))->ToNumber()->NumberValue();
  mZoom = options->Get(NanNew<String>("zoom"))->ToNumber()->NumberValue();
  mMaxsize = options->Get(NanNew<String>("maxsize"))->ToNumber()->NumberValue();
  mFormat = options->Get(NanNew<String>("format"))->ToNumber()->NumberValue();
}

Processor::~Processor() {
}

/**
 * lsm_mtex_to_mathml:
 * @mtex: (allow-none): an mtex string
 * @size: mtex string length, -1 if NULL terminated
 *
 * Converts an mtex string to a Mathml representation.
 *
 * Return value: a newly allocated string, NULL on parse error. The returned data must be freed using @lsm_mtex_free_mathml_buffer.
 */

char *
lsm_mtex_to_mathml(const char *mtex, gssize size) {
  gsize usize;
  char *mathml;

  if (mtex == NULL)
    return NULL;

  if (size < 0)
    usize = strlen(mtex);
  else
    usize = size;

  mathml = mtex2MML_parse(mtex, usize);
  if (mathml == NULL)
    return NULL;

  if (mathml[0] == '\0') {
    mtex2MML_free_string(mathml);
    return NULL;
  }

  return mathml;
}

// /**
//  * lsm_mtex_free_mathml_buffer:
//  * @mathml: (allow-none): a mathml buffer
//  *
//  * Free the buffer returned by @lsm_mtex_to_mathml.
//  */

void
lsm_mtex_free_mathml_buffer(char *mathml) {
  if (mathml == NULL)
    return;

  mtex2MML_free_string(mathml);
}

cairo_status_t cairoSvgSurfaceCallback(void* closure,
  const unsigned char* chunk, unsigned int length) {
  std::string* data = reinterpret_cast<std::string*>(closure);
  data->append(reinterpret_cast<const char *>(chunk), length);

  return CAIRO_STATUS_SUCCESS;
}

cairo_status_t cairoPngSurfaceCallback(void *closure,
  const unsigned char* chunk, unsigned int length) {
  std::string* data = reinterpret_cast<std::string*>(closure);
  data->append(reinterpret_cast<const char *>(chunk), length);

  return CAIRO_STATUS_SUCCESS;
}

NAN_METHOD(Processor::Process) {
  NanScope();
  if (args.Length() != 1)
    NanReturnUndefined();

  Processor* process = node::ObjectWrap::Unwrap<Processor>(args.This());

  assert(args[0]->IsString());

  std::string latex(*String::Utf8Value(args[0]));

  const char *latex_code = latex.c_str();
  uint64_t latex_size = latex.size();

  // make sure that the passed latex string is not larger than the maximum value
  // of a signed long (or the maxsize option)
  if (process->mMaxsize == 0)
    process->mMaxsize = LONG_MAX;

  if (latex_size > process->mMaxsize) {
    ThrowException(Exception::RangeError(
    String::New("Size of latex string is greater than the maxsize!")));
    // TODO(gjtorikian): how to printf
    // ThrowException(Exception::RangeError(
    // ("Size of latex string (%lu) is greater than the maxsize (%lu)!",
    //     latex_size, process->mMaxsize)));
    return scope.Close(Undefined());
  }

#if !GLIB_CHECK_VERSION(2, 36, 0)
  g_type_init();
#endif

  Local<ObjectTemplate> result = ObjectTemplate::New();

  // convert the TeX math to MathML
  char * mathml = mtex2MML_parse(latex_code, latex_size);
  if (mathml == NULL) {
    ThrowException(Exception::Error(String::New("Failed to parse mtex")));
    return scope.Close(Undefined());
  }

  if (process->mFormat == FORMAT_MATHML) {
    result->Set("mathml", String::New(mathml));
    mtex2MML_free_string(mathml);
  }

  int mathml_size = strlen(mathml);

  LsmDomDocument *document;
  document = lsm_dom_document_new_from_memory(mathml, mathml_size, NULL);

  mtex2MML_free_string(mathml);

  if (document == NULL) {
    ThrowException(Exception::Error(String::New("Failed to create document")));
    return scope.Close(Undefined());
  }

  LsmDomView *view;

  double ppi = process->mPpi;
  double zoom = process->mZoom;

  view = lsm_dom_document_create_view(document);
  lsm_dom_view_set_resolution(view, ppi);

  double width_pt = 2.0, height_pt = 2.0;
  unsigned int height, width;

  lsm_dom_view_get_size(view, &width_pt, &height_pt, NULL);
  lsm_dom_view_get_size_pixels(view, &width, &height, NULL);

  width_pt *= zoom;
  height_pt *= zoom;

  cairo_t *cairo;
  cairo_surface_t *surface;
  std::string data;

  if (process->mFormat == FORMAT_SVG) {
    surface = cairo_svg_surface_create_for_stream(
                        cairoSvgSurfaceCallback, &data, width_pt, height_pt);
  } else if (process->mFormat == FORMAT_PNG) {
    surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, width, height);
  }

  cairo = cairo_create(surface);
  cairo_scale(cairo, zoom, zoom);
  lsm_dom_view_render(view, cairo, 0, 0);

  switch (process->mFormat) {
    case FORMAT_PNG:
      cairo_surface_write_to_png_stream(
        cairo_get_target(cairo), cairoPngSurfaceCallback, &data);
      break;
    default:
      break;
  }

  cairo_destroy(cairo);
  cairo_surface_destroy(surface);
  g_object_unref(view);
  g_object_unref(document);

  switch (process->mFormat) {
    case FORMAT_SVG:
      if (data.empty()) {
        ThrowException(
          Exception::TypeError(String::New("Failed to read SVG contents")));
        return scope.Close(Undefined());
      }
      result->Set("svg", String::New(data.c_str()));
      break;
    case FORMAT_PNG:
      if (data.empty()) {
        ThrowException(
          Exception::TypeError(String::New("Failed to read PNG contents")));
        return scope.Close(Undefined());
      }
      result->Set("png", node::Buffer::New(data.c_str(), data.length())->handle_);
      break;
    default:
      break;
  }

  result->Set("width", NanNew<Number>(width_pt));
  result->Set("height", NanNew<Number>(height_pt));

  NanReturnValue(result->NewInstance());
}
