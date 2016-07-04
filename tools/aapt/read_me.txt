Android aapt

aapt stands for Android Asset Packaging Tool. This tool is part of the SDK (and build system) and allows you to view, create, and update Zip-compatible archives (zip, jar, apk). It can also compile resources into binary assets.

Build scripts and IDE plugins utilize this tool to package the apk file that constitutes an Android application.
Contents

    1 Where it is
    2 Usage
    3 Notes on commands and package contents
        3.1 list
        3.2 dump
            3.2.1 badging
            3.2.2 permissions
            3.2.3 resources
            3.2.4 configurations
            3.2.5 xmltree
            3.2.6 xmlstrings

Where it is

In the SDK, aapt is found in the $ANDROID_HOME/platforms/$SDK/tools/ directory of the SDK (where $SDK is the name of some Android version, like android-2.1).

In the Android open source build environment, aapt is found in $ANDROID_BUILD_HOME/out/host/linux-x86/bin
Usage

If you execute appt without any parameters it will show you some usage help.

Direct from an eclair version of aapt (aapt version 0.2):

$ aapt
Android Asset Packaging Tool

Usage:
 aapt l[ist] [-v] [-a] file.{zip,jar,apk}
   List contents of Zip-compatible archive.

 aapt d[ump] [--values] WHAT file.{apk} [asset [asset ...]]
   badging          Print the label and icon for the app declared in APK.
   permissions      Print the permissions from the APK.
   resources        Print the resource table from the APK.
   configurations   Print the configurations in the APK.
   xmltree          Print the compiled xmls in the given assets.
   xmlstrings       Print the strings of the given compiled xml assets.

 aapt p[ackage] [-d][-f][-m][-u][-v][-x][-z][-M AndroidManifest.xml] \
        [-0 extension [-0 extension ...]] [-g tolerance] [-j jarfile] \
        [--min-sdk-version VAL] [--target-sdk-version VAL] \
        [--max-sdk-version VAL] [--app-version VAL] \
        [--app-version-name TEXT] [--custom-package VAL] \
        [-I base-package [-I base-package ...]] \
        [-A asset-source-dir]  [-G class-list-file] [-P public-definitions-file] \
        [-S resource-sources [-S resource-sources ...]]         [-F apk-file] [-J R-file-dir] \
        [raw-files-dir [raw-files-dir] ...]

   Package the android resources.  It will read assets and resources that are
   supplied with the -M -A -S or raw-files-dir arguments.  The -J -P -F and -R
   options control which files are output.

 aapt r[emove] [-v] file.{zip,jar,apk} file1 [file2 ...]
   Delete specified files from Zip-compatible archive.

 aapt a[dd] [-v] file.{zip,jar,apk} file1 [file2 ...]
   Add specified files to Zip-compatible archive.

 aapt v[ersion]
   Print program version.

 Modifiers:
   -a  print Android-specific data (resources, manifest) when listing
   -c  specify which configurations to include.  The default is all
       configurations.  The value of the parameter should be a comma
       separated list of configuration values.  Locales should be specified
       as either a language or language-region pair.  Some examples:
            en
            port,en
            port,land,en_US
       If you put the special locale, zz_ZZ on the list, it will perform
       pseudolocalization on the default locale, modifying all of the
       strings so you can look for strings that missed the
       internationalization process.  For example:
            port,land,zz_ZZ
   -d  one or more device assets to include, separated by commas
   -f  force overwrite of existing files
   -g  specify a pixel tolerance to force images to grayscale, default 0
   -j  specify a jar or zip file containing classes to include
   -k  junk path of file(s) added
   -m  make package directories under location specified by -J
   -u  update existing packages (add new, replace older, remove deleted files)
   -v  verbose output
   -x  create extending (non-application) resource IDs
   -z  require localization of resource attributes marked with
       localization="suggested"
   -A  additional directory in which to find raw asset files
   -G  A file to output proguard options into.
   -F  specify the apk file to output
   -I  add an existing package to base include set
   -J  specify where to output R.java resource constant definitions
   -M  specify full path to AndroidManifest.xml to include in zip
   -P  specify where to output public resource definitions
   -S  directory in which to find resources.  Multiple directories will be scanned
       and the first match found (left to right) will take precedence.
   -0  specifies an additional extension for which such files will not
       be stored compressed in the .apk.  An empty string means to not
       compress any files at all.
   --min-sdk-version
       inserts android:minSdkVersion in to manifest.
   --target-sdk-version
       inserts android:targetSdkVersion in to manifest.
   --max-sdk-version
       inserts android:maxSdkVersion in to manifest.
   --values
       when used with "dump resources" also includes resource values.
   --version-code
       inserts android:versionCode in to manifest.
   --version-name
       inserts android:versionName in to manifest.
   --custom-package
       generates R.java into a different package.

Notes on commands and package contents

Note that an Android package is just a collection of files inside a pkzip'ed archive.

The contents below show results using aapt on the "SpareParts.apk" package from an eclair build of Android. This package is relatively small, so it is useful for showing complete listings.
list

The 'list' command shows the contents of the package.

$ aapt list SpareParts.apk 
META-INF/MANIFEST.MF
META-INF/CERT.SF
META-INF/CERT.RSA
AndroidManifest.xml
classes.dex
res/drawable-hdpi/app_icon.png
res/drawable-mdpi/app_icon.png
res/layout/spare_parts.xml
res/xml/spare_parts.xml
resources.arsc

    the -v option shows the contents of the zipped archive, and is just like 'unzip -l -v'

$ aapt list -v SpareParts.apk 
Archive:  SpareParts.apk
 Length   Method    Size  Ratio   Date   Time   CRC-32    Name
--------  ------  ------- -----   ----   ----   ------    ----
     595  Deflate     354  41%  02-28-08 18:33  78ab990a  META-INF/MANIFEST.MF
     637  Deflate     373  41%  02-28-08 18:33  c5cb7408  META-INF/CERT.SF
    1714  Deflate    1155  33%  02-28-08 18:33  52120576  META-INF/CERT.RSA
    2164  Deflate     731  66%  02-28-08 18:33  556977f7  AndroidManifest.xml
   12540  Deflate    5732  54%  02-28-08 18:33  df75803b  classes.dex
    5260  Stored     5260   0%  02-28-08 18:33  d6b970f6  res/drawable-hdpi/app_icon.png
    3054  Stored     3054   0%  02-28-08 18:33  f1cbe33a  res/drawable-mdpi/app_icon.png
    1208  Deflate     418  65%  02-28-08 18:33  d20be7a1  res/layout/spare_parts.xml
    3864  Deflate    1068  72%  02-28-08 18:33  9c7b866a  res/xml/spare_parts.xml
    7632  Stored     7632   0%  02-28-08 18:33  d20f6c9d  resources.arsc
--------          -------  ---                            -------
   38668            25777  33%                            10 files

For comparison, here is the output of 'unzip -l -v'

$ unzip -l -v SpareParts.apk
Archive:  SpareParts.apk
 Length   Method    Size  Ratio   Date   Time   CRC-32    Name
--------  ------  ------- -----   ----   ----   ------    ----
     595  Defl:N      354  41%  02-28-08 18:33  78ab990a  META-INF/MANIFEST.MF
     637  Defl:N      373  41%  02-28-08 18:33  c5cb7408  META-INF/CERT.SF
    1714  Defl:N     1155  33%  02-28-08 18:33  52120576  META-INF/CERT.RSA
    2164  Defl:N      731  66%  02-28-08 18:33  556977f7  AndroidManifest.xml
   12540  Defl:N     5732  54%  02-28-08 18:33  df75803b  classes.dex
    5260  Stored     5260   0%  02-28-08 18:33  d6b970f6  res/drawable-hdpi/app_icon.png
    3054  Stored     3054   0%  02-28-08 18:33  f1cbe33a  res/drawable-mdpi/app_icon.png
    1208  Defl:N      418  65%  02-28-08 18:33  d20be7a1  res/layout/spare_parts.xml
    3864  Defl:N     1068  72%  02-28-08 18:33  9c7b866a  res/xml/spare_parts.xml
    7632  Stored     7632   0%  02-28-08 18:33  d20f6c9d  resources.arsc
--------          -------  ---                            -------
   38668            25777  33%                            10 files

    the -a option shows all the resources and also parses out the xmltree from the AndroidManifest.xml file.

This is similar to doing the following three commands in sequence: aapt list <pkg> ; aapt dump resources <pkg> ; aapt dump xmltree <pkg> AndroidManifest.xml.

$ aapt list -a SpareParts.apk
META-INF/MANIFEST.MF
META-INF/CERT.SF
META-INF/CERT.RSA
AndroidManifest.xml
classes.dex
res/drawable-hdpi/app_icon.png
res/drawable-mdpi/app_icon.png
res/layout/spare_parts.xml
res/xml/spare_parts.xml
resources.arsc

Resource table:
Package Groups (1)
Package Group 0 id=127 packageCount=1 name=com.android.spare_parts
  Package 0 id=127 name=com.android.spare_parts typeCount=7
    type 0 configCount=0 entryCount=0
    type 1 configCount=2 entryCount=1
      spec resource 0x7f020000 com.android.spare_parts:drawable/app_icon: flags=0x00000100
      config 0 lang=-- cnt=-- orien=0 touch=0 density=160 key=0 infl=0 nav=0 w=0 h=0 sz=0 lng=0
        resource 0x7f020000 com.android.spare_parts:drawable/app_icon: t=0x03 d=0x00000000 (s=0x0008 r=0x00)
      config 1 lang=-- cnt=-- orien=0 touch=0 density=240 key=0 infl=0 nav=0 w=0 h=0 sz=0 lng=0
        resource 0x7f020000 com.android.spare_parts:drawable/app_icon: t=0x03 d=0x00000001 (s=0x0008 r=0x00)
    type 2 configCount=1 entryCount=1
      spec resource 0x7f030000 com.android.spare_parts:layout/spare_parts: flags=0x00000000
      config 0 lang=-- cnt=-- orien=0 touch=0 density=def key=0 infl=0 nav=0 w=0 h=0 sz=0 lng=0
        resource 0x7f030000 com.android.spare_parts:layout/spare_parts: t=0x03 d=0x00000002 (s=0x0008 r=0x00)
    type 3 configCount=1 entryCount=1
      spec resource 0x7f040000 com.android.spare_parts:xml/spare_parts: flags=0x00000000
      config 0 lang=-- cnt=-- orien=0 touch=0 density=def key=0 infl=0 nav=0 w=0 h=0 sz=0 lng=0
        resource 0x7f040000 com.android.spare_parts:xml/spare_parts: t=0x03 d=0x00000003 (s=0x0008 r=0x00)
    type 4 configCount=1 entryCount=6
      spec resource 0x7f050000 com.android.spare_parts:array/entries_animations: flags=0x00000000
      spec resource 0x7f050001 com.android.spare_parts:array/entryvalues_animations: flags=0x00000000
      spec resource 0x7f050002 com.android.spare_parts:array/entries_font_size: flags=0x00000000
      spec resource 0x7f050003 com.android.spare_parts:array/entryvalues_font_size: flags=0x00000000
      spec resource 0x7f050004 com.android.spare_parts:array/entries_end_button: flags=0x00000000
      spec resource 0x7f050005 com.android.spare_parts:array/entryvalues_end_button: flags=0x00000000
      config 0 lang=-- cnt=-- orien=0 touch=0 density=def key=0 infl=0 nav=0 w=0 h=0 sz=0 lng=0
        resource 0x7f050000 com.android.spare_parts:array/entries_animations: <bag>
        resource 0x7f050001 com.android.spare_parts:array/entryvalues_animations: <bag>
        resource 0x7f050002 com.android.spare_parts:array/entries_font_size: <bag>
        resource 0x7f050003 com.android.spare_parts:array/entryvalues_font_size: <bag>
        resource 0x7f050004 com.android.spare_parts:array/entries_end_button: <bag>
        resource 0x7f050005 com.android.spare_parts:array/entryvalues_end_button: <bag>
    type 5 configCount=1 entryCount=35
      spec resource 0x7f060000 com.android.spare_parts:string/app_label: flags=0x00000000
      spec resource 0x7f060001 com.android.spare_parts:string/device_info_title: flags=0x00000000
      spec resource 0x7f060002 com.android.spare_parts:string/title_battery_history: flags=0x00000000
      spec resource 0x7f060003 com.android.spare_parts:string/summary_battery_history: flags=0x00000000
      spec resource 0x7f060004 com.android.spare_parts:string/title_battery_information: flags=0x00000000
      spec resource 0x7f060005 com.android.spare_parts:string/summary_battery_information: flags=0x00000000
      spec resource 0x7f060006 com.android.spare_parts:string/title_usage_statistics: flags=0x00000000
      spec resource 0x7f060007 com.android.spare_parts:string/summary_usage_statistics: flags=0x00000000
      spec resource 0x7f060008 com.android.spare_parts:string/general_title: flags=0x00000000
      spec resource 0x7f060009 com.android.spare_parts:string/title_window_animations: flags=0x00000000
      spec resource 0x7f06000a com.android.spare_parts:string/summary_window_animations: flags=0x00000000
      spec resource 0x7f06000b com.android.spare_parts:string/dialog_title_window_animations: flags=0x00000000
      spec resource 0x7f06000c com.android.spare_parts:string/title_transition_animations: flags=0x00000000
      spec resource 0x7f06000d com.android.spare_parts:string/summary_transition_animations: flags=0x00000000
      spec resource 0x7f06000e com.android.spare_parts:string/dialog_title_transition_animations: flags=0x00000000
      spec resource 0x7f06000f com.android.spare_parts:string/title_fancy_ime_animations: flags=0x00000000
      spec resource 0x7f060010 com.android.spare_parts:string/summary_on_fancy_ime_animations: flags=0x00000000
      spec resource 0x7f060011 com.android.spare_parts:string/summary_off_fancy_ime_animations: flags=0x00000000
      spec resource 0x7f060012 com.android.spare_parts:string/title_haptic_feedback: flags=0x00000000
      spec resource 0x7f060013 com.android.spare_parts:string/summary_on_haptic_feedback: flags=0x00000000
      spec resource 0x7f060014 com.android.spare_parts:string/summary_off_haptic_feedback: flags=0x00000000
      spec resource 0x7f060015 com.android.spare_parts:string/title_font_size: flags=0x00000000
      spec resource 0x7f060016 com.android.spare_parts:string/summary_font_size: flags=0x00000000
      spec resource 0x7f060017 com.android.spare_parts:string/dialog_title_font_size: flags=0x00000000
      spec resource 0x7f060018 com.android.spare_parts:string/title_end_button: flags=0x00000000
      spec resource 0x7f060019 com.android.spare_parts:string/summary_end_button: flags=0x00000000
      spec resource 0x7f06001a com.android.spare_parts:string/dialog_title_end_button: flags=0x00000000
      spec resource 0x7f06001b com.android.spare_parts:string/applications_title: flags=0x00000000
      spec resource 0x7f06001c com.android.spare_parts:string/title_maps_compass: flags=0x00000000
      spec resource 0x7f06001d com.android.spare_parts:string/summary_on_maps_compass: flags=0x00000000
      spec resource 0x7f06001e com.android.spare_parts:string/summary_off_maps_compass: flags=0x00000000
      spec resource 0x7f06001f com.android.spare_parts:string/development_settings_show_maps_compass_text: flags=0x00000000
      spec resource 0x7f060020 com.android.spare_parts:string/compatibility_mode_title: flags=0x00000000
      spec resource 0x7f060021 com.android.spare_parts:string/compatibility_mode_summary_on: flags=0x00000000
      spec resource 0x7f060022 com.android.spare_parts:string/compatibility_mode_summary_off: flags=0x00000000
      config 0 lang=-- cnt=-- orien=0 touch=0 density=def key=0 infl=0 nav=0 w=0 h=0 sz=0 lng=0
        resource 0x7f060000 com.android.spare_parts:string/app_label: t=0x03 d=0x00000022 (s=0x0008 r=0x00)
        resource 0x7f060001 com.android.spare_parts:string/device_info_title: t=0x03 d=0x00000023 (s=0x0008 r=0x00)
        resource 0x7f060002 com.android.spare_parts:string/title_battery_history: t=0x03 d=0x00000024 (s=0x0008 r=0x00)
        resource 0x7f060003 com.android.spare_parts:string/summary_battery_history: t=0x03 d=0x00000025 (s=0x0008 r=0x00)
        resource 0x7f060004 com.android.spare_parts:string/title_battery_information: t=0x03 d=0x00000026 (s=0x0008 r=0x00)
        resource 0x7f060005 com.android.spare_parts:string/summary_battery_information: t=0x03 d=0x00000027 (s=0x0008 r=0x00)
        resource 0x7f060006 com.android.spare_parts:string/title_usage_statistics: t=0x03 d=0x00000028 (s=0x0008 r=0x00)
        resource 0x7f060007 com.android.spare_parts:string/summary_usage_statistics: t=0x03 d=0x00000029 (s=0x0008 r=0x00)
        resource 0x7f060008 com.android.spare_parts:string/general_title: t=0x03 d=0x0000002a (s=0x0008 r=0x00)
        resource 0x7f060009 com.android.spare_parts:string/title_window_animations: t=0x03 d=0x0000002b (s=0x0008 r=0x00)
        resource 0x7f06000a com.android.spare_parts:string/summary_window_animations: t=0x03 d=0x0000002c (s=0x0008 r=0x00)
        resource 0x7f06000b com.android.spare_parts:string/dialog_title_window_animations: t=0x03 d=0x0000002d (s=0x0008 r=0x00)
        resource 0x7f06000c com.android.spare_parts:string/title_transition_animations: t=0x03 d=0x0000002e (s=0x0008 r=0x00)
        resource 0x7f06000d com.android.spare_parts:string/summary_transition_animations: t=0x03 d=0x0000002f (s=0x0008 r=0x00)
        resource 0x7f06000e com.android.spare_parts:string/dialog_title_transition_animations: t=0x03 d=0x00000030 (s=0x0008 r=0x00)
        resource 0x7f06000f com.android.spare_parts:string/title_fancy_ime_animations: t=0x03 d=0x00000031 (s=0x0008 r=0x00)
        resource 0x7f060010 com.android.spare_parts:string/summary_on_fancy_ime_animations: t=0x03 d=0x00000032 (s=0x0008 r=0x00)
        resource 0x7f060011 com.android.spare_parts:string/summary_off_fancy_ime_animations: t=0x03 d=0x00000033 (s=0x0008 r=0x00)
        resource 0x7f060012 com.android.spare_parts:string/title_haptic_feedback: t=0x03 d=0x00000034 (s=0x0008 r=0x00)
        resource 0x7f060013 com.android.spare_parts:string/summary_on_haptic_feedback: t=0x03 d=0x00000035 (s=0x0008 r=0x00)
        resource 0x7f060014 com.android.spare_parts:string/summary_off_haptic_feedback: t=0x03 d=0x00000035 (s=0x0008 r=0x00)
        resource 0x7f060015 com.android.spare_parts:string/title_font_size: t=0x03 d=0x00000036 (s=0x0008 r=0x00)
        resource 0x7f060016 com.android.spare_parts:string/summary_font_size: t=0x03 d=0x00000037 (s=0x0008 r=0x00)
        resource 0x7f060017 com.android.spare_parts:string/dialog_title_font_size: t=0x03 d=0x00000038 (s=0x0008 r=0x00)
        resource 0x7f060018 com.android.spare_parts:string/title_end_button: t=0x03 d=0x00000039 (s=0x0008 r=0x00)
        resource 0x7f060019 com.android.spare_parts:string/summary_end_button: t=0x03 d=0x0000003a (s=0x0008 r=0x00)
        resource 0x7f06001a com.android.spare_parts:string/dialog_title_end_button: t=0x03 d=0x0000003b (s=0x0008 r=0x00)
        resource 0x7f06001b com.android.spare_parts:string/applications_title: t=0x03 d=0x0000003c (s=0x0008 r=0x00)
        resource 0x7f06001c com.android.spare_parts:string/title_maps_compass: t=0x03 d=0x0000003d (s=0x0008 r=0x00)
        resource 0x7f06001d com.android.spare_parts:string/summary_on_maps_compass: t=0x03 d=0x0000003e (s=0x0008 r=0x00)
        resource 0x7f06001e com.android.spare_parts:string/summary_off_maps_compass: t=0x03 d=0x0000003f (s=0x0008 r=0x00)
        resource 0x7f06001f com.android.spare_parts:string/development_settings_show_maps_compass_text: t=0x03 d=0x0000003d (s=0x0008 r=0x00)
        resource 0x7f060020 com.android.spare_parts:string/compatibility_mode_title: t=0x03 d=0x00000040 (s=0x0008 r=0x00)
        resource 0x7f060021 com.android.spare_parts:string/compatibility_mode_summary_on: t=0x03 d=0x00000041 (s=0x0008 r=0x00)
        resource 0x7f060022 com.android.spare_parts:string/compatibility_mode_summary_off: t=0x03 d=0x00000041 (s=0x0008 r=0x00)
    type 6 configCount=1 entryCount=3
      spec resource 0x7f070000 com.android.spare_parts:id/window_animation_scale: flags=0x00000000
      spec resource 0x7f070001 com.android.spare_parts:id/transition_animation_scale: flags=0x00000000
      spec resource 0x7f070002 com.android.spare_parts:id/show_maps_compass: flags=0x00000000
      config 0 lang=-- cnt=-- orien=0 touch=0 density=def key=0 infl=0 nav=0 w=0 h=0 sz=0 lng=0
        resource 0x7f070000 com.android.spare_parts:id/window_animation_scale: t=0x12 d=0x00000000 (s=0x0008 r=0x00)
        resource 0x7f070001 com.android.spare_parts:id/transition_animation_scale: t=0x12 d=0x00000000 (s=0x0008 r=0x00)
        resource 0x7f070002 com.android.spare_parts:id/show_maps_compass: t=0x12 d=0x00000000 (s=0x0008 r=0x00)

Android manifest:
N: android=http://schemas.android.com/apk/res/android
  E: manifest (line=17)
    A: android:versionCode(0x0101021b)=(type 0x10)0x7
    A: android:versionName(0x0101021c)="2.1-update1" (Raw: "2.1-update1")
    A: package="com.android.spare_parts" (Raw: "com.android.spare_parts")
    E: uses-sdk (line=0)
      A: android:minSdkVersion(0x0101020c)=(type 0x10)0x7
      A: android:targetSdkVersion(0x01010270)=(type 0x10)0x7
    E: uses-permission (line=19)
      A: android:name(0x01010003)="android.permission.SET_ANIMATION_SCALE" (Raw: "android.permission.SET_ANIMATION_SCALE")
    E: uses-permission (line=20)
      A: android:name(0x01010003)="android.permission.CHANGE_CONFIGURATION" (Raw: "android.permission.CHANGE_CONFIGURATION")
    E: uses-permission (line=21)
      A: android:name(0x01010003)="android.permission.WRITE_SETTINGS" (Raw: "android.permission.WRITE_SETTINGS")
    E: application (line=23)
      A: android:label(0x01010001)=@0x7f060000
      A: android:icon(0x01010002)=@0x7f020000
      E: activity (line=26)
        A: android:name(0x01010003)="SpareParts" (Raw: "SpareParts")
        E: intent-filter (line=27)
          E: action (line=28)
            A: android:name(0x01010003)="android.intent.action.MAIN" (Raw: "android.intent.action.MAIN")
          E: category (line=29)
            A: android:name(0x01010003)="android.intent.category.DEFAULT" (Raw: "android.intent.category.DEFAULT")
          E: category (line=30)
            A: android:name(0x01010003)="android.intent.category.LAUNCHER" (Raw: "android.intent.category.LAUNCHER")

dump

The 'dump' sub-command of aapt is used to display the values of individual elements or parts of a package.
badging

$ aapt dump badging SpareParts.apk
package: name='com.android.spare_parts' versionCode='7' versionName='2.1-update1'
sdkVersion:'7'
targetSdkVersion:'7'
uses-permission:'android.permission.SET_ANIMATION_SCALE'
uses-permission:'android.permission.CHANGE_CONFIGURATION'
uses-permission:'android.permission.WRITE_SETTINGS'
application: label='Spare Parts' icon='res/drawable-mdpi/app_icon.png'
launchable activity name='com.android.spare_parts.SpareParts'label='' icon=''
main
supports-screens: 'small' 'normal' 'large'
locales: '--_--'
densities: '160' '240'

permissions

$ aapt dump permissions SpareParts.apk
package: com.android.spare_parts
uses-permission: android.permission.SET_ANIMATION_SCALE
uses-permission: android.permission.CHANGE_CONFIGURATION
uses-permission: android.permission.WRITE_SETTINGS

resources

$ aapt dump resources SpareParts.apk
Package Groups (1)
Package Group 0 id=127 packageCount=1 name=com.android.spare_parts
  Package 0 id=127 name=com.android.spare_parts typeCount=7
    type 0 configCount=0 entryCount=0
    type 1 configCount=2 entryCount=1
      spec resource 0x7f020000 com.android.spare_parts:drawable/app_icon: flags=0x00000100
      config 0 lang=-- cnt=-- orien=0 touch=0 density=160 key=0 infl=0 nav=0 w=0 h=0 sz=0 lng=0
        resource 0x7f020000 com.android.spare_parts:drawable/app_icon: t=0x03 d=0x00000000 (s=0x0008 r=0x00)
      config 1 lang=-- cnt=-- orien=0 touch=0 density=240 key=0 infl=0 nav=0 w=0 h=0 sz=0 lng=0
        resource 0x7f020000 com.android.spare_parts:drawable/app_icon: t=0x03 d=0x00000001 (s=0x0008 r=0x00)
    type 2 configCount=1 entryCount=1
      spec resource 0x7f030000 com.android.spare_parts:layout/spare_parts: flags=0x00000000
      config 0 lang=-- cnt=-- orien=0 touch=0 density=def key=0 infl=0 nav=0 w=0 h=0 sz=0 lng=0
        resource 0x7f030000 com.android.spare_parts:layout/spare_parts: t=0x03 d=0x00000002 (s=0x0008 r=0x00)
    type 3 configCount=1 entryCount=1
      spec resource 0x7f040000 com.android.spare_parts:xml/spare_parts: flags=0x00000000
      config 0 lang=-- cnt=-- orien=0 touch=0 density=def key=0 infl=0 nav=0 w=0 h=0 sz=0 lng=0
        resource 0x7f040000 com.android.spare_parts:xml/spare_parts: t=0x03 d=0x00000003 (s=0x0008 r=0x00)
    type 4 configCount=1 entryCount=6
      spec resource 0x7f050000 com.android.spare_parts:array/entries_animations: flags=0x00000000
      spec resource 0x7f050001 com.android.spare_parts:array/entryvalues_animations: flags=0x00000000
      spec resource 0x7f050002 com.android.spare_parts:array/entries_font_size: flags=0x00000000
      spec resource 0x7f050003 com.android.spare_parts:array/entryvalues_font_size: flags=0x00000000
      spec resource 0x7f050004 com.android.spare_parts:array/entries_end_button: flags=0x00000000
      spec resource 0x7f050005 com.android.spare_parts:array/entryvalues_end_button: flags=0x00000000
      config 0 lang=-- cnt=-- orien=0 touch=0 density=def key=0 infl=0 nav=0 w=0 h=0 sz=0 lng=0
        resource 0x7f050000 com.android.spare_parts:array/entries_animations: <bag>
        resource 0x7f050001 com.android.spare_parts:array/entryvalues_animations: <bag>
        resource 0x7f050002 com.android.spare_parts:array/entries_font_size: <bag>
        resource 0x7f050003 com.android.spare_parts:array/entryvalues_font_size: <bag>
        resource 0x7f050004 com.android.spare_parts:array/entries_end_button: <bag>
        resource 0x7f050005 com.android.spare_parts:array/entryvalues_end_button: <bag>
    type 5 configCount=1 entryCount=35
      spec resource 0x7f060000 com.android.spare_parts:string/app_label: flags=0x00000000
      spec resource 0x7f060001 com.android.spare_parts:string/device_info_title: flags=0x00000000
      spec resource 0x7f060002 com.android.spare_parts:string/title_battery_history: flags=0x00000000
      spec resource 0x7f060003 com.android.spare_parts:string/summary_battery_history: flags=0x00000000
      spec resource 0x7f060004 com.android.spare_parts:string/title_battery_information: flags=0x00000000
      spec resource 0x7f060005 com.android.spare_parts:string/summary_battery_information: flags=0x00000000
      spec resource 0x7f060006 com.android.spare_parts:string/title_usage_statistics: flags=0x00000000
      spec resource 0x7f060007 com.android.spare_parts:string/summary_usage_statistics: flags=0x00000000
      spec resource 0x7f060008 com.android.spare_parts:string/general_title: flags=0x00000000
      spec resource 0x7f060009 com.android.spare_parts:string/title_window_animations: flags=0x00000000
      spec resource 0x7f06000a com.android.spare_parts:string/summary_window_animations: flags=0x00000000
      spec resource 0x7f06000b com.android.spare_parts:string/dialog_title_window_animations: flags=0x00000000
      spec resource 0x7f06000c com.android.spare_parts:string/title_transition_animations: flags=0x00000000
      spec resource 0x7f06000d com.android.spare_parts:string/summary_transition_animations: flags=0x00000000
      spec resource 0x7f06000e com.android.spare_parts:string/dialog_title_transition_animations: flags=0x00000000
      spec resource 0x7f06000f com.android.spare_parts:string/title_fancy_ime_animations: flags=0x00000000
      spec resource 0x7f060010 com.android.spare_parts:string/summary_on_fancy_ime_animations: flags=0x00000000
      spec resource 0x7f060011 com.android.spare_parts:string/summary_off_fancy_ime_animations: flags=0x00000000
      spec resource 0x7f060012 com.android.spare_parts:string/title_haptic_feedback: flags=0x00000000
      spec resource 0x7f060013 com.android.spare_parts:string/summary_on_haptic_feedback: flags=0x00000000
      spec resource 0x7f060014 com.android.spare_parts:string/summary_off_haptic_feedback: flags=0x00000000
      spec resource 0x7f060015 com.android.spare_parts:string/title_font_size: flags=0x00000000
      spec resource 0x7f060016 com.android.spare_parts:string/summary_font_size: flags=0x00000000
      spec resource 0x7f060017 com.android.spare_parts:string/dialog_title_font_size: flags=0x00000000
      spec resource 0x7f060018 com.android.spare_parts:string/title_end_button: flags=0x00000000
      spec resource 0x7f060019 com.android.spare_parts:string/summary_end_button: flags=0x00000000
      spec resource 0x7f06001a com.android.spare_parts:string/dialog_title_end_button: flags=0x00000000
      spec resource 0x7f06001b com.android.spare_parts:string/applications_title: flags=0x00000000
      spec resource 0x7f06001c com.android.spare_parts:string/title_maps_compass: flags=0x00000000
      spec resource 0x7f06001d com.android.spare_parts:string/summary_on_maps_compass: flags=0x00000000
      spec resource 0x7f06001e com.android.spare_parts:string/summary_off_maps_compass: flags=0x00000000
      spec resource 0x7f06001f com.android.spare_parts:string/development_settings_show_maps_compass_text: flags=0x00000000
      spec resource 0x7f060020 com.android.spare_parts:string/compatibility_mode_title: flags=0x00000000
      spec resource 0x7f060021 com.android.spare_parts:string/compatibility_mode_summary_on: flags=0x00000000
      spec resource 0x7f060022 com.android.spare_parts:string/compatibility_mode_summary_off: flags=0x00000000
      config 0 lang=-- cnt=-- orien=0 touch=0 density=def key=0 infl=0 nav=0 w=0 h=0 sz=0 lng=0
        resource 0x7f060000 com.android.spare_parts:string/app_label: t=0x03 d=0x00000022 (s=0x0008 r=0x00)
        resource 0x7f060001 com.android.spare_parts:string/device_info_title: t=0x03 d=0x00000023 (s=0x0008 r=0x00)
        resource 0x7f060002 com.android.spare_parts:string/title_battery_history: t=0x03 d=0x00000024 (s=0x0008 r=0x00)
        resource 0x7f060003 com.android.spare_parts:string/summary_battery_history: t=0x03 d=0x00000025 (s=0x0008 r=0x00)
        resource 0x7f060004 com.android.spare_parts:string/title_battery_information: t=0x03 d=0x00000026 (s=0x0008 r=0x00)
        resource 0x7f060005 com.android.spare_parts:string/summary_battery_information: t=0x03 d=0x00000027 (s=0x0008 r=0x00)
        resource 0x7f060006 com.android.spare_parts:string/title_usage_statistics: t=0x03 d=0x00000028 (s=0x0008 r=0x00)
        resource 0x7f060007 com.android.spare_parts:string/summary_usage_statistics: t=0x03 d=0x00000029 (s=0x0008 r=0x00)
        resource 0x7f060008 com.android.spare_parts:string/general_title: t=0x03 d=0x0000002a (s=0x0008 r=0x00)
        resource 0x7f060009 com.android.spare_parts:string/title_window_animations: t=0x03 d=0x0000002b (s=0x0008 r=0x00)
        resource 0x7f06000a com.android.spare_parts:string/summary_window_animations: t=0x03 d=0x0000002c (s=0x0008 r=0x00)
        resource 0x7f06000b com.android.spare_parts:string/dialog_title_window_animations: t=0x03 d=0x0000002d (s=0x0008 r=0x00)
        resource 0x7f06000c com.android.spare_parts:string/title_transition_animations: t=0x03 d=0x0000002e (s=0x0008 r=0x00)
        resource 0x7f06000d com.android.spare_parts:string/summary_transition_animations: t=0x03 d=0x0000002f (s=0x0008 r=0x00)
        resource 0x7f06000e com.android.spare_parts:string/dialog_title_transition_animations: t=0x03 d=0x00000030 (s=0x0008 r=0x00)
        resource 0x7f06000f com.android.spare_parts:string/title_fancy_ime_animations: t=0x03 d=0x00000031 (s=0x0008 r=0x00)
        resource 0x7f060010 com.android.spare_parts:string/summary_on_fancy_ime_animations: t=0x03 d=0x00000032 (s=0x0008 r=0x00)
        resource 0x7f060011 com.android.spare_parts:string/summary_off_fancy_ime_animations: t=0x03 d=0x00000033 (s=0x0008 r=0x00)
        resource 0x7f060012 com.android.spare_parts:string/title_haptic_feedback: t=0x03 d=0x00000034 (s=0x0008 r=0x00)
        resource 0x7f060013 com.android.spare_parts:string/summary_on_haptic_feedback: t=0x03 d=0x00000035 (s=0x0008 r=0x00)
        resource 0x7f060014 com.android.spare_parts:string/summary_off_haptic_feedback: t=0x03 d=0x00000035 (s=0x0008 r=0x00)
        resource 0x7f060015 com.android.spare_parts:string/title_font_size: t=0x03 d=0x00000036 (s=0x0008 r=0x00)
        resource 0x7f060016 com.android.spare_parts:string/summary_font_size: t=0x03 d=0x00000037 (s=0x0008 r=0x00)
        resource 0x7f060017 com.android.spare_parts:string/dialog_title_font_size: t=0x03 d=0x00000038 (s=0x0008 r=0x00)
        resource 0x7f060018 com.android.spare_parts:string/title_end_button: t=0x03 d=0x00000039 (s=0x0008 r=0x00)
        resource 0x7f060019 com.android.spare_parts:string/summary_end_button: t=0x03 d=0x0000003a (s=0x0008 r=0x00)
        resource 0x7f06001a com.android.spare_parts:string/dialog_title_end_button: t=0x03 d=0x0000003b (s=0x0008 r=0x00)
        resource 0x7f06001b com.android.spare_parts:string/applications_title: t=0x03 d=0x0000003c (s=0x0008 r=0x00)
        resource 0x7f06001c com.android.spare_parts:string/title_maps_compass: t=0x03 d=0x0000003d (s=0x0008 r=0x00)
        resource 0x7f06001d com.android.spare_parts:string/summary_on_maps_compass: t=0x03 d=0x0000003e (s=0x0008 r=0x00)
        resource 0x7f06001e com.android.spare_parts:string/summary_off_maps_compass: t=0x03 d=0x0000003f (s=0x0008 r=0x00)
        resource 0x7f06001f com.android.spare_parts:string/development_settings_show_maps_compass_text: t=0x03 d=0x0000003d (s=0x0008 r=0x00)
        resource 0x7f060020 com.android.spare_parts:string/compatibility_mode_title: t=0x03 d=0x00000040 (s=0x0008 r=0x00)
        resource 0x7f060021 com.android.spare_parts:string/compatibility_mode_summary_on: t=0x03 d=0x00000041 (s=0x0008 r=0x00)
        resource 0x7f060022 com.android.spare_parts:string/compatibility_mode_summary_off: t=0x03 d=0x00000041 (s=0x0008 r=0x00)
    type 6 configCount=1 entryCount=3
      spec resource 0x7f070000 com.android.spare_parts:id/window_animation_scale: flags=0x00000000
      spec resource 0x7f070001 com.android.spare_parts:id/transition_animation_scale: flags=0x00000000
      spec resource 0x7f070002 com.android.spare_parts:id/show_maps_compass: flags=0x00000000
      config 0 lang=-- cnt=-- orien=0 touch=0 density=def key=0 infl=0 nav=0 w=0 h=0 sz=0 lng=0
        resource 0x7f070000 com.android.spare_parts:id/window_animation_scale: t=0x12 d=0x00000000 (s=0x0008 r=0x00)
        resource 0x7f070001 com.android.spare_parts:id/transition_animation_scale: t=0x12 d=0x00000000 (s=0x0008 r=0x00)
        resource 0x7f070002 com.android.spare_parts:id/show_maps_compass: t=0x12 d=0x00000000 (s=0x0008 r=0x00)

configurations

$ aapt dump configurations SpareParts.apk
imsi=0/0 lang=-- reg=-- orient=0 touch=0 dens=160 kbd=0 nav=0 input=0 scrnW=0 scrnH=0 sz=0 long=0 vers=0.0
imsi=0/0 lang=-- reg=-- orient=0 touch=0 dens=240 kbd=0 nav=0 input=0 scrnW=0 scrnH=0 sz=0 long=0 vers=0.0
imsi=0/0 lang=-- reg=-- orient=0 touch=0 dens=0 kbd=0 nav=0 input=0 scrnW=0 scrnH=0 sz=0 long=0 vers=0.0

xmltree

The xmltree option with the 'dump' command allows you to print out the xml parse tree for an xml file contained within the package.

$ aapt dump xmltree SpareParts.apk res/layout/spare_parts.xml
N: android=http://schemas.android.com/apk/res/android
  E: ScrollView (line=20)
    A: android:layout_width(0x010100f4)=(type 0x10)0xffffffff
    A: android:layout_height(0x010100f5)=(type 0x10)0xffffffff
    E: RelativeLayout (line=24)
      A: android:layout_width(0x010100f4)=(type 0x10)0xffffffff
      A: android:layout_height(0x010100f5)=(type 0x10)0xffffffff
      E: Spinner (line=28)
        A: android:id(0x010100d0)=@0x7f070000
        A: android:layout_width(0x010100f4)=(type 0x10)0xffffffff
        A: android:layout_height(0x010100f5)=(type 0x10)0xfffffffe
        A: android:layout_alignParentLeft(0x0101018b)=(type 0x12)0xffffffff
      E: Spinner (line=34)
        A: android:id(0x010100d0)=@0x7f070001
        A: android:layout_width(0x010100f4)=(type 0x10)0xffffffff
        A: android:layout_height(0x010100f5)=(type 0x10)0xfffffffe
        A: android:layout_below(0x01010185)=@0x7f070000
        A: android:layout_alignParentLeft(0x0101018b)=(type 0x12)0xffffffff
      E: CheckBox (line=41)
        A: android:id(0x010100d0)=@0x7f070002
        A: android:layout_width(0x010100f4)=(type 0x10)0xfffffffe
        A: android:layout_height(0x010100f5)=(type 0x10)0xfffffffe
        A: android:text(0x0101014f)=@0x7f06001f
        A: android:layout_below(0x01010185)=@0x7f070001
        A: android:layout_alignParentLeft(0x0101018b)=(type 0x12)0xffffffff

You can use this to print out the xmltree for the AndroidManifest.xml file:

$ aapt dump xmltree SpareParts.apk AndroidManifest.xml
N: android=http://schemas.android.com/apk/res/android
  E: manifest (line=17)
    A: android:versionCode(0x0101021b)=(type 0x10)0x7
    A: android:versionName(0x0101021c)="2.1-update1" (Raw: "2.1-update1")
    A: package="com.android.spare_parts" (Raw: "com.android.spare_parts")
    E: uses-sdk (line=0)
      A: android:minSdkVersion(0x0101020c)=(type 0x10)0x7
      A: android:targetSdkVersion(0x01010270)=(type 0x10)0x7
    E: uses-permission (line=19)
      A: android:name(0x01010003)="android.permission.SET_ANIMATION_SCALE" (Raw: "android.permission.SET_ANIMATION_SCALE")
    E: uses-permission (line=20)
      A: android:name(0x01010003)="android.permission.CHANGE_CONFIGURATION" (Raw: "android.permission.CHANGE_CONFIGURATION")
    E: uses-permission (line=21)
      A: android:name(0x01010003)="android.permission.WRITE_SETTINGS" (Raw: "android.permission.WRITE_SETTINGS")
    E: application (line=23)
      A: android:label(0x01010001)=@0x7f060000
      A: android:icon(0x01010002)=@0x7f020000
      E: activity (line=26)
        A: android:name(0x01010003)="SpareParts" (Raw: "SpareParts")
        E: intent-filter (line=27)
          E: action (line=28)
            A: android:name(0x01010003)="android.intent.action.MAIN" (Raw: "android.intent.action.MAIN")
          E: category (line=29)
            A: android:name(0x01010003)="android.intent.category.DEFAULT" (Raw: "android.intent.category.DEFAULT")
          E: category (line=30)
            A: android:name(0x01010003)="android.intent.category.LAUNCHER" (Raw: "android.intent.category.LAUNCHER")

xmlstrings

$ aapt dump xmlstrings SpareParts.apk res/layout/spare_parts.xml
String #0: layout_width
String #1: layout_height
String #2: id
String #3: layout_alignParentLeft
String #4: layout_below
String #5: text
String #6: android
String #7: http://schemas.android.com/apk/res/android
String #8: 
String #9: ScrollView
String #10: RelativeLayout
String #11: Spinner
String #12: CheckBox

