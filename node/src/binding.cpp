#include <node_api.h>
#include "./common.h"
#include "./test.h"
#include <iostream>

using namespace test;
using namespace std;

static napi_value _add (napi_env env, napi_callback_info info) {
  size_t argc = 2; // receive 2 arguments
  napi_value argv[2] = { nullptr };
  double doubleArgv[2] = { 0 };
  NAPI_CALL(env, napi_get_cb_info(env, info, &argc, argv, nullptr, nullptr));

  for (size_t i = 0; i < argc; i++) {
    NAPI_CALL(env, napi_get_value_double(env, argv[i], doubleArgv + i));
  }

  double x = add(doubleArgv[0], doubleArgv[1]);

  napi_value _x;
  NAPI_CALL(env, napi_create_double(env, x, &_x)); 
  return _x;
}

NAPI_MODULE_INIT() {
  cout << "std::cout" << endl;
  napi_value global = nullptr;
  NAPI_CALL(env, napi_get_global(env, &global));

  napi_value console = nullptr;
  napi_value log = nullptr;
  napi_value strConsole = nullptr;
  napi_value strLog = nullptr;
  NAPI_CALL(env, napi_create_string_utf8(env, "console", -1, &strConsole));
  NAPI_CALL(env, napi_create_string_utf8(env, "log", -1, &strLog));
  NAPI_CALL(env, napi_get_property(env, global, strConsole, &console));
  NAPI_CALL(env, napi_get_property(env, console, strLog, &log));

  napi_value args[1] = { nullptr };
  NAPI_CALL(env, napi_create_string_utf8(env, "call console.log() from C++", -1, args));
  NAPI_CALL(env, napi_call_function(env, console, log, 1, args, nullptr));

  napi_property_descriptor dec = DECLARE_NAPI_PROPERTY("add", _add);
  NAPI_CALL(env, napi_define_properties(env, exports, 1, &dec));
  return exports;
}
