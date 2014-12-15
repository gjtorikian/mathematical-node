// Copyright (c) 2014 Garen J. Torikian

#ifndef SRC_PROCESSOR_H_
#define SRC_PROCESSOR_H_

#include <node.h>
#include <v8.h>
#include <inttypes.h>
#include <string>

#include "nan.h"

using namespace v8;  // NOLINT

class Processor : public node::ObjectWrap {
  public:
    static void Init(Handle<Object> target);
    static NAN_METHOD(Process);

    double mPpi;
    double mZoom;
    uint64_t mMaxsize;
    int mFormat;
    char *mSvg;
    char *mPng;

  private:
    static NAN_METHOD(New);

    explicit Processor(Handle<Object> options);
    ~Processor();
};

#endif  // SRC_PROCESSOR_H_
