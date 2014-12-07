// Copyright (c) 2014 Garen J. Torikian

#ifndef SRC_PROCESSOR_H_
#define SRC_PROCESSOR_H_

#include <node.h>
#include <v8.h>
#include <string>

#include "nan.h"

using namespace v8;  // NOLINT

class Processor : public node::ObjectWrap {
  public:
    static void Init(Handle<Object> target);

  private:
    static NAN_METHOD(New);
    static NAN_METHOD(Hello);
    static v8::Persistent<v8::Function> constructor;
};

#endif  // SRC_PROCESSOR_H_
