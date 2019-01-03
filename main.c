//
//  main.c
//  xlua
//
//  Created by jayyang on 2018/1/25.
//

#include <stdio.h>
#include <string.h>
#include "lua-5.3.5/src/lua.h"
#include "lua-5.3.5/src/lauxlib.h"
#include "lua-5.3.5/src/lualib.h"
//#include "lua-protobuf/pb.h"
//#include "lua-rapidjson/include/rapidjson.h"

extern int luaopen_pb(lua_State *L);
extern int luaopen_rapidjson(lua_State *L);

int main(int argc, char* argv[])
{
//    while(1)
    {
        lua_State* L = luaL_newstate();
        luaL_openlibs(L);
        luaL_requiref(L, "pb", luaopen_pb, 1);
        luaL_requiref(L, "rapidjson", luaopen_rapidjson, 1);
        
        luaL_dofile(L, argv[1]);
        
        lua_close(L);
    }
  
    return 0;
}
