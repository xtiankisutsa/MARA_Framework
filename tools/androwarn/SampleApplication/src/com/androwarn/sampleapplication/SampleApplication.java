package com.androwarn.sampleapplication;

import android.widget.TextView;
import android.app.Activity;
import android.os.Bundle;
import android.net.Uri;
import android.content.Intent;
import android.content.ActivityNotFoundException;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.content.Context;
import android.net.NetworkInfo;
import android.net.ConnectivityManager;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileNotFoundException;
import android.os.Environment;
import android.media.MediaRecorder;
import java.io.IOException;
import com.androwarn.sampleapplication.BusterReceiver;
import android.database.Cursor;
import android.telephony.gsm.GsmCellLocation;
import java.lang.NumberFormatException;
import android.location.Location;
import android.location.LocationManager;
import java.util.List;
import android.telephony.SmsManager;
import android.net.wifi.WifiConfiguration;
import android.provider.ContactsContract;
import android.content.ContentResolver;
import android.content.ContentValues;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.Arrays;
import java.net.Socket;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.io.OutputStream;
import java.lang.NullPointerException;
import java.lang.IllegalStateException;
import android.provider.ContactsContract.CommonDataKinds.Phone;
import android.content.ContentProviderOperation;
import java.util.ArrayList;
import android.content.OperationApplicationException;
import android.content.ContentProviderResult;
import android.provider.ContactsContract.RawContacts;
import android.provider.ContactsContract.RawContacts.Data;
import android.provider.ContactsContract.CommonDataKinds.StructuredName;
import android.content.ContentProviderResult;
import android.os.RemoteException;

public class SampleApplication extends Activity
{
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        
		TelephonyConfidentialInformationExfiltration();
        FileSystemOperations();
        RecordAudioCalls(); 
        CaptureVideo(); //Bug on the x86 port
        InterceptSMS();
        ReadSMSInbox();
        SendSMS();
        GetLocationInformation();
        ReadContacts();
        AddContact();
        DeleteContacts();
        RunUNIXCommand();
        NativeCodeExec();
        MakePhoneCall();
        OpenAndConnectThroughASocket();
    }
    
    
    public void TelephonyConfidentialInformationExfiltration()
    {
		TelephonyManager telephonyManager =
		(TelephonyManager)getSystemService(Context.TELEPHONY_SERVICE);
		
		
		/** Network Information **/
		String nomOperateurReseau = telephonyManager.getNetworkOperatorName();
		if (nomOperateurReseau != null)
		{
			Log.v("Network Operator Name", nomOperateurReseau);
		}
		
		/** CellID Lookup **/	
		GsmCellLocation location = (GsmCellLocation) telephonyManager.getCellLocation();
		try {
		int cid = location.getCid();
		int lac = location.getLac();
		if (Integer.toString(cid) != null && Integer.toString(lac) != null) {
			Log.v("CellID Information", Integer.toString(cid));
			Log.v("Location Area Code Information", Integer.toString(lac));
		}
		}
		catch (NullPointerException e) {
			String err = (e.getMessage()==null)?"CellID Information OR Location Area Code Information":e.getMessage();
			Log.e("GSMCellLocation Exception", err);
		}


		
		String networkOperator = telephonyManager.getNetworkOperator();
		
		if ((networkOperator != null) && (networkOperator.length() > 0)) {
			try {
				int mcc = Integer.parseInt(networkOperator.substring(0, 3));
				int mnc = Integer.parseInt(networkOperator.substring(3));
				Log.v("MCC Information", Integer.toString(mcc));
				Log.v("MNC Information", Integer.toString(mnc));
				
			} 
			catch (NumberFormatException e) {
				Log.e("NumberFormatException", e.getMessage());

			}
		}
		
		/** Phone state **/
		int etat = telephonyManager.getCallState();
		switch(etat) {
		
			/** IDLE **/
			case TelephonyManager.CALL_STATE_IDLE:
				Log.v("Phone State", "Idle");
				break;
			
			/** Call Incoming **/
			case TelephonyManager.CALL_STATE_RINGING:
				Log.v("Phone State", "Ringing");
				break;
			
			/** Call dialing, active or paused **/
			case TelephonyManager.CALL_STATE_OFFHOOK:
				Log.v("Phone State", "Active");
				break;
			
			default:
				Log.v("Phone State", "Other " + etat);
				break;
		}
		
		/** Device Information **/
		String idAppareil = telephonyManager.getDeviceId();
		if (idAppareil != null)
		{
			Log.v("Device ID", idAppareil);
		}
		
		/** IMSI **/
		String IMSI = telephonyManager.getSubscriberId();
		if (IMSI != null)
		{
			Log.v("IMSI", IMSI);
		}
		
		/** Software Version **/
		String versionSoftwareAppareil =
		telephonyManager.getDeviceSoftwareVersion();
		if (versionSoftwareAppareil != null)
		{
			Log.v("Software Version", versionSoftwareAppareil);
		}
		
		/** SIM Information **/
		String numeroSerieSIM = telephonyManager.getSimSerialNumber();
		if (numeroSerieSIM != null)
		{
			Log.v("SIM", numeroSerieSIM);
		}
		

		
	}
	
	public void FileSystemOperations()
	{
		File sdcard = Environment.getExternalStorageDirectory();
		
		/** Read a file in the application directory **/
		final String LOCAL_FILENAME_TO_BE_READ = "MyLocalFiletoBeRead.dat";
		try {
			FileInputStream out = openFileInput(LOCAL_FILENAME_TO_BE_READ);
		} 
		catch (FileNotFoundException e) {
			Log.e("FileNotFoundException", e.getMessage() + " Impossible to read " + LOCAL_FILENAME_TO_BE_READ + " in the application directory");
		}
		
		/** Read from the SD-Card **/
		File MyFile_R = new File(sdcard, "download/MyFiletoBeRead.dat");
		try {
			FileOutputStream out =  new FileOutputStream(MyFile_R);
		} 
		catch (FileNotFoundException e) {
			Log.e("FileNotFoundException", e.getMessage() + " Impossible to read " + MyFile_R + " from the sdcard");
		}
		
		/** Write to a file in the application directory **/
		final String FILENAME_TO_BE_WRITTEN = "MyLocalFiletoBeWritten.dat";
		try {
			FileOutputStream out = openFileOutput(FILENAME_TO_BE_WRITTEN, MODE_PRIVATE);
		} 
		catch (FileNotFoundException e) {
			Log.e("FileNotFoundException", e.getMessage() + " Impossible to write " + FILENAME_TO_BE_WRITTEN + " in the application directory");
		}
		
		/** Write to a file on the sdcard **/
		File MyFile_W = new File(sdcard, "download/MyFiletoBeWritten.dat");
		try {
			FileOutputStream out =  new FileOutputStream(MyFile_W);
		} 
		catch (FileNotFoundException e) {
			Log.e("FileNotFoundException", e.getMessage() + " Impossible to write " + MyFile_W + " on the sdcard");
		}
	}
	
	public void RecordAudioCalls()
	{
		MediaRecorder mediaRecorder = new MediaRecorder();
		File fichierEnregistre;
				
		/** Check if there is an sdcard **/
		String state = android.os.Environment.getExternalStorageState();
		if (!state.equals(android.os.Environment.MEDIA_MOUNTED))
		{
			Log.e("RecordAudio","There isnt any memory card");
			return;
		}
		
		/** Check if the card is writable **/
		File repertoireStockage = Environment.getExternalStorageDirectory();
		if (!repertoireStockage.canWrite()) 
		{
			Log.e("RecordAudio","Impossible to write on the sdcard");
			return;
		}
		
		/** Create the destination file **/
		try {
			fichierEnregistre = File.createTempFile("RecordAudio",".mp4", repertoireStockage);
		} 
		catch (IOException e) {
			Log.e("RecordAudio", "I/O Problem before recording");
			return;
		}
		
		mediaRecorder = new MediaRecorder();
		mediaRecorder.setAudioSource(MediaRecorder.AudioSource.VOICE_CALL); //ou MIC
		
		mediaRecorder.setOutputFormat(MediaRecorder.OutputFormat.MPEG_4);
		mediaRecorder.setAudioEncoder(MediaRecorder.AudioEncoder.AAC);
		
		mediaRecorder.setOutputFile(fichierEnregistre.getAbsolutePath());
		
		try {
			mediaRecorder.prepare();
		}
		catch (IOException e) {
			Log.e("RecordAudio", "Failed to prepare the audio recorder handler");
			return;
		}
		mediaRecorder.start();
		
	}
	
	public void CaptureVideo()
	{
		
		final String FICHIER_SORTIE = "/sdcard/video_test.3gp";
		
		MediaRecorder mediaRecorder =  new MediaRecorder();
		
		try {
		mediaRecorder.setVideoSource(MediaRecorder.VideoSource.CAMERA);
		
		mediaRecorder.setOutputFormat(MediaRecorder.OutputFormat.MPEG_4);
		mediaRecorder.setVideoEncoder(MediaRecorder.VideoEncoder.MPEG_4_SP);
		
		mediaRecorder.setOutputFile(FICHIER_SORTIE);
		
			mediaRecorder.prepare();
		}
		catch (IOException e) {
			Log.e("CaptureVideo", "Failed to prepare the video recorder handler");
			return;
		}
		catch(IllegalStateException e){
			throw new RuntimeException(e);
		}
		mediaRecorder.start();
	}
	
	public void MakePhoneCall()
	{
		try {
		/** Force dialing **/
		String telURI = "tel:" + "1234567890";
		Intent intent = new Intent(Intent.ACTION_CALL, Uri.parse(telURI));
		startActivity(intent);
		}
		catch (ActivityNotFoundException e) {
			Log.e("MakeCall", "Call Activity Failed", e);
			return;
		}
	}
	
	public void InterceptSMS()
	{
		BusterReceiver SMSInterceptor = new BusterReceiver();
	}
	
	public void ReadSMSInbox() 
	{
		
		Uri uriBoiteReceptionSMS = Uri.parse("content://sms/inbox"); 
		Cursor curseur = getContentResolver().query(uriBoiteReceptionSMS,null, null, null, null); 
		startManagingCursor(curseur);
	}
	
	public void SendSMS()
	{
		/** TO DO in Androwarn : modifier backtrace registers car tout n'est pas catché dans ce code (seul numéro) **/
		String numero, message;
		message = "Premium SMS";
		numero = "12345";
		SmsManager smsManager = SmsManager.getDefault();
		smsManager.sendTextMessage(numero, null, message, null, null);
	}
	
	public void GetLocationInformation()
	{
		/** Different providers providing different precision level **/
		LocationManager locationManager;
		String locationContext = Context.LOCATION_SERVICE;
		locationManager = (LocationManager) getSystemService(locationContext);
		
		StringBuilder stringBuilder = new StringBuilder();
		
		stringBuilder.append("Providers :");
		List <String> providers = locationManager.getProviders(true);
		
		/** For each Provider... **/
		for (String provider : providers) {
			stringBuilder.append("\n");
			stringBuilder.append(provider);
			stringBuilder.append(" : ");
		
		
			/** ... We're sprintf-ing the results **/
			Location location = locationManager.getLastKnownLocation(provider);
			if (location != null) 
			{ 
				double latitude = location.getLatitude();
				double longitude = location.getLongitude();
				stringBuilder.append(latitude);
				stringBuilder.append(", ");
				stringBuilder.append(longitude);
			} 
			else 
			{
				stringBuilder.append("N/A");
			}
		}
		Log.v("GetLocationInformation", stringBuilder.toString());
	}
	
	public void ReadWiFiCredentials()
	{
		/** Related to the HTC vulnerability allowing to get wpa_supplicant.conf **/
		WifiConfiguration wc = new WifiConfiguration();
		String output = wc.toString();
		Log.v("ReadWiFiCredentials",output);
	}
	
	public void ReadContacts()
	{
		ContentResolver cr = getContentResolver();
        Cursor cur = cr.query(ContactsContract.Contacts.CONTENT_URI,null, null, null, null);
        
        if (cur.getCount() > 0) {
        	while (cur.moveToNext()) {
        		String id = cur.getString(cur.getColumnIndex(ContactsContract.Contacts._ID));
        		String name = cur.getString(cur.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME));
        		
        		if (Integer.parseInt(cur.getString(cur.getColumnIndex(ContactsContract.Contacts.HAS_PHONE_NUMBER))) > 0) 
        		{
					Cursor pCur = cr.query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null, ContactsContract.CommonDataKinds.Phone.CONTACT_ID +" = ?", new String[]{id}, null);
                     
                     while (pCur.moveToNext()) {
						 String phoneNo = pCur.getString(pCur.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));
                    	 Log.i("ReadContacts", "ID " + id  +"\tName " + name + "\tPhone number " + phoneNo);
                     } 
      	        
      	        pCur.close();
      	        }
        	}
        }
    }
    
    public void AddContact()
    {
		ContentValues values = new ContentValues();
		
		String phone_number = "1234567890";
		String display_name = "Johnny B.Goode";
		
		ArrayList <ContentProviderOperation> ops = new ArrayList <ContentProviderOperation> ();
		int rawContactInsertIndex = ops.size();

		ops.add(ContentProviderOperation.newInsert(RawContacts.CONTENT_URI)
			.withValue(RawContacts.ACCOUNT_TYPE, null)
		   .withValue(RawContacts.ACCOUNT_NAME,null )
		   .build());
		
		ops.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
		   .withValueBackReference(ContactsContract.Data.RAW_CONTACT_ID, rawContactInsertIndex)
		   .withValue(Data.MIMETYPE,Phone.CONTENT_ITEM_TYPE)
		   .withValue(Phone.NUMBER, phone_number)
		   .build());
		
		ops.add(ContentProviderOperation.newInsert(ContactsContract.Data.CONTENT_URI)
		   .withValueBackReference(Data.RAW_CONTACT_ID, rawContactInsertIndex)
		   .withValue(Data.MIMETYPE,StructuredName.CONTENT_ITEM_TYPE)
		   .withValue(StructuredName.DISPLAY_NAME, display_name)
		   .build());  
		
		try {
			ContentProviderResult[] res = getContentResolver().applyBatch(ContactsContract.AUTHORITY, ops);
			Log.i("AddContact", "Contact added " + display_name + " " + phone_number);
		} 
		catch (RemoteException e) {
			Log.e("AddContact", e.getMessage());
		}
		catch (OperationApplicationException e) {
			Log.e("AddContact", e.getMessage());
		}
		
	}
	
	public void DeleteContacts()
	{	
		String name = "Johnny B.Goode";
		ContentResolver cr = getContentResolver();
    	String where = ContactsContract.Data.DISPLAY_NAME + " = ? ";
    	String[] params = new String[] {name};
    
        ArrayList<ContentProviderOperation> ops = new ArrayList<ContentProviderOperation>();
        
        ops.add(ContentProviderOperation.newDelete(ContactsContract.RawContacts.CONTENT_URI)
    	        .withSelection(where, params)
    	        .build());
        try {
			cr.applyBatch(ContactsContract.AUTHORITY, ops);
			Log.i("DeleteContact", "Contact deleted " + name);
		} 
		catch (RemoteException e) {
			Log.e("DeleteContact", e.getMessage());
		} 
		catch (OperationApplicationException e) {
			Log.e("DeleteContact", e.getMessage());
		}
	}
	
	public void RunUNIXCommand()
	{
		try {
			/** Executes the command **/
			String[] cmd = new String[]{"ls", "/sdcard/"}; 
			Process process = Runtime.getRuntime().exec(cmd);
			
			/** Reads stdout **/
			/** NOTE: You can write to stdin of the command using "process.getOutputStream()" **/
			BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
			int read;
			char[] buffer = new char[4096];
			
			StringBuffer output = new StringBuffer();
			
			while ((read = reader.read(buffer)) > 0) {
				output.append(buffer, 0, read);
			}
			reader.close();
			
			/** Waits for the command to finish **/
			process.waitFor();
			
			/** Log the command and the result **/
			Log.v("UNIX Command", Arrays.toString(cmd));
			Log.v("UNIX Command", output.toString());
		} 
		catch (IOException e) {
			throw new RuntimeException(e);
		} 
		catch (InterruptedException e) {
			throw new RuntimeException(e);
		}
	}
	
	public void OpenAndConnectThroughASocket()
	{	
		int dest_port_str 	= 1337;
		int dest_port_inet 	= 1338;
		
		String remote_str = "192.168.56.101";
		
		try{
			/** String Socket **/
			Socket string_socket = new Socket(remote_str,dest_port_str);
			if (string_socket.isConnected())
			{
				OutputStream os1 = string_socket.getOutputStream();
				os1.write("[+] Test String Socket\n".getBytes());
				string_socket.close();
			}
			
		}
		catch (UnknownHostException e){
			Log.e("String Socket", e.getMessage());
		}
		catch (IOException e) {
			Log.e("String Socket", e.getMessage());
		}
		 
		try{
			/** Inet Socket **/
			InetAddress remote_inet = InetAddress.getByName(remote_str);
			Socket inet_socket = new Socket(remote_inet,dest_port_inet);
			if (inet_socket.isConnected())
			{
				OutputStream os2 = inet_socket.getOutputStream();
				os2.write("[+] Test Inet Socket\n".getBytes());
				inet_socket.close();
			}
		}
		catch (UnknownHostException e){
			Log.e("Inet Socket", e.getMessage());
		}
		catch (IOException e) {
			Log.e("Inet Socket", e.getMessage());
		} 
		
	}
	
	public void NativeCodeExec()
	{
		String str = "I'm a Native String !";
		NativeCode.NativeMethod(str);
	}
}
