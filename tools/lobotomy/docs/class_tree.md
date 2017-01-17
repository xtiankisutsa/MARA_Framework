# Class Tree
## Example
```bash
(lobotomy) class_tree


	--> class : public final Lcom/syclover/crackme001/BuildConfig;
		--> field : public static final Z DEBUG
			--> method : public constructor <init> ()V


	--> class : public Lcom/syclover/crackme001/DES;
		--> field : public static final Ljava/lang/String; ALGORITHM_DES
			--> method : public constructor <init> ()V
			--> method : public static byte2HexString ([B)Ljava/lang/String;
			--> method : public static encode (Ljava/lang/String; Ljava/lang/String;)Ljava/lang/String;
			--> method : private static encode (Ljava/lang/String; [B)Ljava/lang/String;


	--> class : public Lcom/syclover/crackme001/MainActivity;
		--> field : private static [Ljava/lang/String; known_file
			--> method : static constructor <clinit> ()V
			--> method : public constructor <init> ()V
			--> method : public static hasQEmuFiles ()Z
			--> method : public OnMySelfClick (Landroid/view/View;)V
			--> method : protected onCreate (Landroid/os/Bundle;)V
			--> method : public onCreateOptionsMenu (Landroid/view/Menu;)Z
```
