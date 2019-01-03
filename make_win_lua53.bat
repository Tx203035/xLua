mkdir build_win & pushd build_win
cmake -G "Visual Studio 15 2017 Win64" ..
popd
cmake --build build_win --config Debug
md plugin_lua53\Plugins\x86_64
copy /Y build_win\Debug\xlua.dll plugin_lua53\Plugins\x86_64\xlua.dll