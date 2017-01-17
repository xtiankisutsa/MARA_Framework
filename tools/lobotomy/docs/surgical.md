
# Surgical
## Example
```bash
(lobotomy) surgical
(surgical) modules list


	--> [0] zip
	--> [1] intent
	--> [2] socket
	--> [3] system
	--> [4] crypto


(surgical) modules select
[2017-01-07 23:04:06.735099] Select module : 4
[2017-01-07 23:04:08.462029] crypto module selected (!)
(surgical) api list




	--> crypto : SecretKeyFactory : <init>
	--> crypto : SecretKeyFactory : generateSecret
	--> crypto : SecretKeyFactory : getAlgorithm
	--> crypto : SecretKeyFactory : getInstance
	--> crypto : SecretKeyFactory : getKeySpec
	--> crypto : SecretKeyFactory : getProvider


	--> crypto : DESKeySpec : <init>
	--> crypto : DESKeySpec : getKey


(surgical) api select
[2017-01-07 23:04:17.184264] Select class : DESKeySpec
[2017-01-07 23:04:22.965228] Select method : <init>
[2017-01-07 23:04:26.117187] Analyzing ...
[2017-01-07 23:04:26.136668] Results found (!)
(surgical) api analyzed list
```
