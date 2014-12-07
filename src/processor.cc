// Copyright (c) 2014 Garen J. Torikian
#include "processor.h"

#include <string.h>

void Processor::Init(Handle<Object> target) {
  NanScope();

  Local<FunctionTemplate> newTemplate = NanNew<FunctionTemplate>(
      Processor::New);
  newTemplate->SetClassName(NanNew<String>("Processor"));
  newTemplate->InstanceTemplate()->SetInternalFieldCount(1);

  Local<ObjectTemplate> proto = newTemplate->PrototypeTemplate();
  NODE_SET_METHOD(proto, "hello", Processor::Hello);

  target->Set(NanNew<String>("Processor"), newTemplate->GetFunction());
}

NODE_MODULE(processor, Processor::Init)

NAN_METHOD(Processor::New) {
  NanScope();

  NanReturnUndefined();
}

NAN_METHOD(Processor::Hello) {
  NanScope();
  if (args.Length() < 1)
    NanReturnValue(NanNew<Boolean>(false));

  NanReturnValue(String::Concat(NanNew<String>("hello "),
    NanNew<String>("world")));
}
