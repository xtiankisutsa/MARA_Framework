#include <android/log.h>
#include <jni.h>
#include <string.h>  

JNIEXPORT void JNICALL Java_com_androwarn_sampleapplication_NativeCode_NativeMethod
  (JNIEnv * env, jclass jc, jstring str)
{
	/** This function is supposed to do a 'printf' **/
    const char * szPrintThis = (*env)->GetStringUTFChars(env, str, NULL);  
    
	__android_log_print(ANDROID_LOG_VERBOSE, "NativeCode", "Printf '%s'", szPrintThis);
	
	(*env)->ReleaseStringUTFChars(env, str, szPrintThis);
}
