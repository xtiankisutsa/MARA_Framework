# Lobotomy
[![Hex.pm](https://img.shields.io/hexpm/l/plug.svg)]()
## Overview
Lobotomy is a command line based Android reverse engineering tool.  What is in the repo, is currently in development.  You should assume nothing works as expected until the official 2.0 release is finished.

<table>
    <tr>
        <th>Version</th>
        <td>
          Development
        </td>
    </tr>
    <tr>
       <th>Author</th>
       <td>Benjamin Watson (rotlogix) </td>
    </tr>
</table>

### Features
    
|Feature|Description |Status|
|:------|:-----------|:-----|
|Components|Enumerate AndroidManifest.xml components|+|
|Permission|Enumerate declared and used ```AndroidManifest.xml``` permissions|+|
|Strings   |List and search for strings within the target application|+|
|AttackSurface|Enumerate the target Application's attack surface through parsing the ```AndroidManifest.xml```|+|
|Surgical|Find specific Android API usage throughout the application|+|
|Interact|Drop into an IPython session to analyze the target application in a more granular fashion|+|
|Binja|Binary Ninja plugin|+|
|UI|A terminal based interface for navigating an application's class tree|-|
|Decompile|Decompile the target application with ```Apktool```|-|
|Debuggable|Convert the target application into being debuggable when installed on a device|-|
|Dextra|Wrapper around ```dextra``` for dumping ```odex``` and ```oat``` files|-|
|Socket|Find local and listening sockets on a target Android device|-|
|Scalpel|Frida integration|-|


### Building 
#### OSX
**Create a Python Virtual Environment for Lobotomy** 
```
virtualenv -p /usr/bin/python2.7 lobotomy
cd lobotomy/
source bin/activate
```
**Install the PIP Requirements** 
```
pip install -r requirements
```
**Install Androguard**
```
cd core/include/androguard
python setup.py install
```
### Running
#### OSX
```bash
python lobotomy.py


                  :                   :                  :
                 t#,                 t#,                t#,
            i   ;##W.   .           ;##W.              ;##W.
           LE  :#L:WE   Ef.        :#L:WE  GEEEEEEEL  :#L:WE             ..       : f.     ;WE.
          L#E .KG  ,#D  E#Wi      .KG  ,#D ,;;L#K;;. .KG  ,#D           ,W,     .Et E#,   i#G
         G#W. EE    ;#f E#K#D:    EE    ;#f   t#E    EE    ;#f         t##,    ,W#t E#t  f#f
        D#K. f#.     t#iE#t,E#f. f#.     t#i  t#E   f#.     t#i       L###,   j###t E#t G#i
       E#K.  :#G     GK E#WEE##Wt:#G     GK   t#E   :#G     GK      .E#j##,  G#fE#t E#jEW,
     .E#E.    ;#L   LW. E##Ei;;;;.;#L   LW.   t#E    ;#L   LW.     ;WW; ##,:K#i E#t E##E.
    .K#E       t#f f#:  E#DWWt     t#f f#:    t#E     t#f f#:     j#E.  ##f#W,  E#t E#G
   .K#D         f#D#;   E#t f#K;    f#D#;     t#E      f#D#;    .D#L    ###K:   E#t E#t
  .W#G           G#t    E#Dfff##E,   G#t      t#E       G#t    :K#t     ##D.    E#t E#t
 :W##########Wt   t     jLLLLLLLLL;   t        fE        t     ...      #G      ..  EE.
 :,,,,,,,,,,,,,.                                :                       j           t

(lobotomy)
```

See the [docs](https://github.com/rotlogix/lobotomy/tree/master/docs) for more information.

## Examples
[![asciicast](https://asciinema.org/a/97809.png)](https://asciinema.org/a/97809)
