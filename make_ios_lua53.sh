mkdir -p build_ios && cd build_ios
cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/iOS.cmake  -GXcode ../
cd ..
cmake --build build_ios --config Debug
mkdir -p plugin_lua53/Plugins/iOS/
cp build_ios/Debug-iphoneos/libxlua.a plugin_lua53/Plugins/iOS/libxlua.a 

