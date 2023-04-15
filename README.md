# Duckyscript
Ducky script for Bad USB on the Flipper Zero
PowerShell:

* Create-PwdDictAttack.ps1 - Creates a Ducky script that can try a list of passwords, for example against the Windows logon screen. Delay and wait are configurable.
* Escape-DeadKeys.ps1 - Changes a Ducky script to escape dead keys (~ ` ' ") on some keyboards.
* Generate-PinCodes.ps1 - Generates 4 number pin codes, easy to remember pin codes first.

Ducky script:

* EyeLock_Edge_Win.txt - Awareness script. Found an unlocked Windows screen? Fire this one off to open https://eyelockmyscreen.com in a full screen window.
* Show_wifi_passwords_Win_PS.txt - Awareness script. Found an unlocked Windows screen? Fire this one off to open a Powershell window and show the user their wifi passwords.
* Policy_Lock-Screen_Edge_Win.txt - Awareness script. Found an unlocked Windows screen? Fire this one off to open the company policy page and search for a specific control.
* Password-top100.txt - Top 100 passwords turned into a Ducky script by Create-PwdDictAttack.ps1.
* PinCodes-top1000.txt - 4 Number pin codes (easy to remember pin codes first) turned into a Ducky script by Create-PwdDictAttack.ps1.
* Website-FF-Android.txt - Opens a website with Firefox (only works when Firefox hasn't been opened).
* Website-Manual-Android.txt - Opens the default browser, then pauses. Manually select the address bar and hit the Run button.
