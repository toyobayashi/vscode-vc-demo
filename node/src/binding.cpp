#include <node_api.h>
#include "./common.h"
#include "./test.h"

using namespace test;


static napi_value _apb (napi_env env, napi_callback_info info) {
  int x = apb();
  napi_value _x;
  NAPI_CALL(env, napi_create_int32(env, x, &_x)); 
  return _x;
}

NAPI_MODULE_INIT() {
  napi_property_descriptor dec = DECLARE_NAPI_PROPERTY("apb", _apb);
  NAPI_CALL(env, napi_define_properties(env, exports, 1, &dec));
  return exports;
}
