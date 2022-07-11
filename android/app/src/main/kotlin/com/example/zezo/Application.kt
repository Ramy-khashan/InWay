package com.example.zezo

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.view.FlutterMain


class Application : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()
        FlutterMain.startInitialization(this)

    }
}