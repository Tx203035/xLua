mkdir build_win & pushd build_win
cmake -DLUAC_COMPATIBLE_FORMAT=ON -G "Visual Studio 15 2017 Win64" ..
popd
cmake --build build_win --config Release
pause