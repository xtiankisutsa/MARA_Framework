Smali-CFGs
==========

Smali Control Flow Graph's

Smali Class Method CFG.

	$ flow.py -c smali/android/system/CoreService.smali -m run Method CFG


![](https://raw.github.com/EugenioDelfa/Smali-CFGs/master/imgs/method_flow_example.png)



Smali Class File CFG.

	$ flow.py -c smali/android/system/CoreService.smali Class CFG


![](https://raw.github.com/EugenioDelfa/Smali-CFGs/master/imgs/class_flow_example.png)



Smali Calls XRefs CFG.

	$ xref.py -d smali/ -m XRefBoth -f "android/system/a/g->a" XRefs CFG


![](https://raw.github.com/EugenioDelfa/Smali-CFGs/master/imgs/xrefs_example-1.png)
