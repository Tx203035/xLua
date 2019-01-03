mkdir -p build_osx && cd build_osx
cmake -GXcode ../
cd ..
cmake --build build_osx --config Debug
mkdir -p plugin_lua53/Plugins/xlua.bundle/Contents/MacOS/
cp build_osx/Debug/xlua.bundle/Contents/MacOS/xlua plugin_lua53/Plugins/xlua.bundle/Contents/MacOS/xlua

