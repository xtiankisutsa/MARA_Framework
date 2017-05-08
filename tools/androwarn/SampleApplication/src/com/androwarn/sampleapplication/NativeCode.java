package com.androwarn.sampleapplication;


public class NativeCode {
	// Declare native method (and make it public to expose it directly)
	public static native void NativeMethod(String str);
	
	// Load library
    static {
        System.loadLibrary("nativecode");
    }
}
