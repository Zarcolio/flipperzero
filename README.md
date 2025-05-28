![](https://img.shields.io/github/license/Zarcolio/Duckyscript) ![](https://badges.pufler.dev/visits/Zarcolio/Duckyscript) ![](https://img.shields.io/github/stars/Zarcolio/Duckyscript) ![](https://img.shields.io/github/forks/Zarcolio/Duckyscript) ![](https://img.shields.io/github/issues/Zarcolio/Duckyscript) ![](https://img.shields.io/github/issues-closed-raw/Zarcolio/Duckyscript)  ![](https://img.shields.io/github/issues-pr/Zarcolio/Duckyscript) ![](https://img.shields.io/github/issues-pr-closed-raw/Zarcolio/Duckyscript)

Want to get the latest updates?  
Be sure to ⭐ this repo! 

# Bad USB/
Stuff for Bad USB (or Bad KB on [Momentum](https://github.com/Next-Flip/Momentum-Firmware)) on the Flipper Zero

## Ducky script/
* `Defensive`/`EyeLock_Edge_Win.txt` - Awareness script. Found an unlocked Windows screen in your office? Fire this one off to open https://eyelockmyscreen.com (or https://lock.nu) in a full screen window.
* `Defensive`/`Phish_Office365_From_Usb.txt` - Creates a phishing page for Office 365. The email address is extracted via Outlook :) If the user hits the sign-in button, a message appears in red "You typed your password inside a phishing page because you did not lock your screen!"
* `Defensive`/`Policy_Lock-Screen_Edge_Win.txt` - Awareness script. Found an unlocked Windows screen? Fire this one off to open the company policy page and search for a specific control.
* `Defensive`/`Show_wifi_passwords_Win_PS.txt` - Awareness script. Found an unlocked Windows screen? Fire this one off to open a Powershell window and show the user their wifi passwords.
* `Defensive`/`Website-FF-Android.txt` - Opens a website with Firefox (only works when Firefox hasn't been opened).
* `Defensive`/`Website-Manual-Android.txt` - Opens the default browser, then pauses. Manually select the address bar and hit the Run button. An awareness message is displayed.
* `Offensive`/`Pin_Bruteforcer_HP_Display_Center_Anti-Theft.txt` - Bruteforces HP's anti-theft feature of HP Display Center.
* `Offensive`/`Pin_Bruteforcer_Netflix.txt` - Bruteforces parental pin on Netflix app under Android. Created with: **Create-PwdDictAttack.ps1 -PrintMode char -Wait 1000 -CharDelay 2000 -PreventOverflow -Enter**
* `Offensive`/`Pin_Bruteforcer_HBO.txt` - Bruteforces parental pin on HBO app under Android. Created with: **Create-PwdDictAttack.ps1 -InputFile .\pincodes.txt -Wait 500**
* `Offensive`/`Cookie-Facebook-WinChrome.txt` - Opens facebook.com within Chrome browser and alerts the document.cookie for Facebook. Use your imagination for offensive purposes.
* `Offensive`/`Cookie-Facebook-WinDefaultBrowser.txt` - Opens facebook.com within the default browser and alerts the document.cookie for Facebook. Use your imagination for offensive purposes.
* `Offensive`/`Cookie-Facebook-WinEdge.txt` - Opens facebook.com within Edge browser and alerts the document.cookie for Facebook. Use your imagination for offensive purposes.
* `Offensive`/`Demo_Password_Reset.txt` - Opens a demo for a password reset. This why online services always should ask for the old password before resetting it and this is why you should lock your screen! Use your imagination for offensive purposes.
* `Offensive`/`ExfilToUsb.txt` - Copies a folder recursively to an USB drive you bring along.
* `Offensive`/`ExeFromUsb.txt` - Opens an executable from an USB drive you bring along.
* `Offensive`/`Exfil-Default-Pwd-Windows.txt` - Steals DefaultPassword for automatic logon, exfils it via http://127.0.0.1 (edit this) and cleans up last opened MRU listing ("powershell"). Press button to close MS Edge.
* `Offensive`/`Exfil-Wifi-Pwd-Win10.txt` - Steals wifi passwords (uptil win10, win11 needs admin for all passwords), exfils it via http://127.0.0.1 (edit this) and cleans up last opened MRU listing ("powershell"). Press button to close MS Edge.
* `Offensive`/`HookBeEF-WinDefaultBrowser.txt`- Opens the BeEF demo page within the default browser so you can see interesting information on the victim.
* `Offensive`/`Password-top100.txt` - Top 100 passwords turned into a Ducky script by Create-PwdDictAttack.ps1.
* `Offensive`/`PinCodes-top10000-ButtonWait.txt` - 4 Number pin codes (easy to remember pin codes first) turned into a Ducky script by Create-PwdDictAttack.ps1. Waits until the run button has been pressed after each pin code.
* `Offensive`/`PinCodes-top10000-Delay2000.txt` - 4 Number pin codes (easy to remember pin codes first) turned into a Ducky script by Create-PwdDictAttack.ps1. Waits 2 seconds after each pin code.
* `Offensive`/`Samsung-LEDTV-UE40F6500.txt` - Changes the DNS settings of your Samsung LED TV UE40F6500 (2013 model) to 1.1.1.1.
* `Useful`/`DuckyScript_UDL.txt` - Automatically installs User Defined Language in Notepad++ for Ducky Script.

## PowerShell/
* `Offensive`/`Create-PwdDictAttack.ps1` - Creates a Ducky script that tries a list of passwords (or pincodes), for example against the Windows logon screen. Delay and wait time/method are configurable.
* `Offensive`/`Generate-4DigitPinCodes.ps1` - Generates all 4 number pin codes, easy to remember pin codes first.
* `Offensive`/`Generate-6DigitPinCodes.ps1` - Generates easy to remember 6 number pin codes,very easy to remember pin codes first.
* `Useful`/`Convert-Ps2Ducky.ps1` - Converts a .ps1 file to a Ducky script.
* `Useful`/`Escape-DeadKeysAltcode.ps1` - Changes a Ducky script to escape dead keys (~ ` ' ") on some keyboards (replaces STRING with ALTCODE if a dead key is detected).
* `Useful`/`Escape-DeadKeysRepeat.ps1` - Changes a Ducky script to escape dead keys (~ ` ' ") on some keyboards (each dead key is repeated).

## Ducky script creator/
* Mobile page to create Ducky scripts on your phone when you don't have a laptop with you. Try it out [here](https://bit.ly/DuckyScriptCreator)!

# Infrared
* `JBL_SB1x0` - Remote for JBL soundbars SB120 / SB140 / SB170.
