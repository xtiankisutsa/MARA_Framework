package com.androwarn.sampleapplication;


import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.telephony.gsm.SmsMessage;
import android.util.Log;

public class BusterReceiver extends BroadcastReceiver
{
	final String ACTION = "android.provider.Telephony.SMS_RECEIVED";
	
	@Override
	public void onReceive(Context context, Intent intent){
		if (intent.getAction().equals(ACTION))
		{
			Log.i("Incoming SMSMessage", "1 SMS Message Received");
			
			this.abortBroadcast(); /* avoid further broadcast */
			Log.i("Incoming SMSMessage", "Broadcast Aborted");
			
			Object[] pdus = (Object[]) intent.getExtras().get("pdus"); 
			
			SmsMessage[] messages = new SmsMessage[pdus.length];
			
			for (int i = 0; i < pdus.length; i++) 
			{
				messages[i] = SmsMessage.createFromPdu((byte[]) pdus[i]);
				Log.i("Incoming SMSMessage", messages[i].getMessageBody());
			}
			
		}
	}
	
}
