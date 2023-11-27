#include <io.h>
#include <stdio.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"

static int
DirFiles(lua_State *L){
	long Handle;
	struct _finddata_t FileInfo;
	size_t l;
	int index = 0;
	const char* path = luaL_checklstring(L, 1, &l);
	lua_newtable(L);
	if ((Handle = _findfirst(path, &FileInfo)) != -1L)
	{
		lua_pushstring(L, FileInfo.name);
		lua_seti(L, -2, ++index);
		while(_findnext(Handle, &FileInfo) == 0)
		{
			lua_pushstring(L, FileInfo.name);
			lua_seti(L, -2, ++index);
		}
		_findclose(Handle);
	}

	return 1;
}

int 
luaopen_lfs(lua_State *L){
	luaL_checkversion(L);

	luaL_Reg methods[] = {
		{"DirFiles", DirFiles},
		{NULL, NULL}
		};
	luaL_newlib(L, methods);

	return 1;
}