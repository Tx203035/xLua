INSTALL_TARGET=$1
cp plugin_lua53/Plugins/iOS/libxlua.a $INSTALL_TARGET/Assets/Plugins/iOS
cp -r plugin_lua53/Plugins/xlua.bundle $INSTALL_TARGET/Assets/Plugins/macOS
cp -r plugin_lua53/Plugins/Android/libs/ $INSTALL_TARGET/Assets/Plugins/Android/libs
cp plugin_lua53/Plugins/x86/xlua.dll $INSTALL_TARGET/Assets/Plugins/Windows/x86
cp plugin_lua53/Plugins/x86_64/xlua.dll $INSTALL_TARGET/Assets/Plugins/Windows/x86_64
