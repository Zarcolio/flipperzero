# Duckyscript
Ducky script for Bad USB on the Flipper Zero

PowerShell:

* Create-PwdDictAttack.ps1 - Creates a Ducky script that tries a list of passwords, for example against the Windows logon screen. Delay and wait time/method are configurable.
* Escape-DeadKeys.ps1 - Changes a Ducky script to escape dead keys (~ ` ' ") on some keyboards.
* Generate-PinCodes.ps1 - Generates 4 number pin codes, easy to remember pin codes first.

Ducky script:

* Exfill-Wifi-Pwd-Win10.txt - Steals wifi passwords (uptil win10, win11 needs admin for all passwords), exfills it via http://127.0.0.1 (edit this) and cleans up last opened MRU listing ("powershell"). Press button to close MS Edge.
* EyeLock_Edge_Win.txt - Awareness script. Found an unlocked Windows screen? Fire this one off to open https://eyelockmyscreen.com in a full screen window.
* Show_wifi_passwords_Win_PS.txt - Awareness script. Found an unlocked Windows screen? Fire this one off to open a Powershell window and show the user their wifi passwords.
* Policy_Lock-Screen_Edge_Win.txt - Awareness script. Found an unlocked Windows screen? Fire this one off to open the company policy page and search for a specific control.
* Password-top100.txt - Top 100 passwords turned into a Ducky script by Create-PwdDictAttack.ps1.
* PinCodes-top10000-ButtonWait.txt - 4 Number pin codes (easy to remember pin codes first) turned into a Ducky script by Create-PwdDictAttack.ps1. Waits until the run button has been pressed after each pin code.
* PinCodes-top10000-Delay2000.txt - 4 Number pin codes (easy to remember pin codes first) turned into a Ducky script by Create-PwdDictAttack.ps1. Waits 2 seconds after each pin code.
* Website-FF-Android.txt - Opens a website with Firefox (only works when Firefox hasn't been opened).
* Website-Manual-Android.txt - Opens the default browser, then pauses. Manually select the address bar and hit the Run button. An awareness message is displayed. 
