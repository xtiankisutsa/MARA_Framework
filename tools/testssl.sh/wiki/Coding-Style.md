## Coding Style

### This is a short brain dump which is far from being complete

* PR *
  * you make the life of the maintainer easier if it's only **one** patch w/ **one** functional change per PR

* Global variables 
  * use them only when necessary
  * in CAPS
  * initialize them 
  * use ``readonly`` and variable types
  * if it's going to be a cmd line switch, there has to be also a global ENV variable which can be used without the switch (see e.g. SNEAKY or SSL_NATIVE)

* local variables (all_lower_case)
   * declare them before usage
   * if unclear initialize them 

* use "speaking variables" but don't overdo it with the length

* test before doing a PR! If it's a check best you check with two bad and two good examples which should work as expected (compare results e.g. with SSLlabs)

* don't use backticks anymore ( use $(..) instead )
* use double square instead of single square brackets
* mind: http://mywiki.wooledge.org/BashPitfalls

* use [shellcheck](https://github.com/koalaman/shellcheck) if possible

* don't use additional binaries 
  * if you really, really need to use an additional one make sure it's available on the system before calling it
  * don't use highly system depended binaries (rpm, ipconfig, ..) as it is not portable or requires lot's of efforts and ugly code to be portable.

* If it's an openssl feature you want to use and it could be not available for older openssl versions testssl.sh needs to find out whether openssl has that feature. Best do this with openssl itself and not by checking the version as some vendors do backports. See the examples for HAS_SSL2 or proxy option check of openssl in check_proxy().

* If a feature of openssl is not available you need to tell this by using pr_litemagenta*() / pr_minor_prob*() or accordingly with fatal() -- if a continuation of the program doesn't make sense anymore.

* every operation (string, etc.) which works with bash internal functions: use them whenever possible (replacing tr/sed/awk), see e.g. http://www.cyberciti.biz/tips/bash-shell-parameter-substitution-2.html 
* avoid a mix of e.g. (sed and awk) or (cut and sed) or (sed, tr and \<whatsoever\>). 
* be careful with very advanced bash features. Mac OS X is still using bash version 3 ([http://tldp.org/LDP/abs/html/bashver4.html](differences))
* especially with ``sed`` you need to be careful as GNU sed is only 80% compatible with BSD sed (`sed -i`,` \n`, `\t`, etc.). 

* always use a return value for a function/method

* use the short functions / methods
  * count_words() / count_lines() / count_ciphers()
  * strip_lf() / strip_spaces()
  * toupper() 
  * newline_to_spaces()
  * is_number() / is_ipv4addr() / is_ipv6addr() 

