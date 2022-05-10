# Set LockScreen for none Microsoft Enterprise and non Edu Device in Microsoft Endpoint Manager

## Table of Contents
1. [Purpose](#purpose)
2. [Description](#description)
4. [Version](#version)
5. [FAQs](#faqs)

### Purpose
***
The Script allows the Configuration of the LockScreen for non Windows Enterprise and Windows Education Device with Intune.
The Image File is copied to the local Device and then the Lockscreen is activated via Registrykeys.

### Description
***
The script Create-Lockscree.ps1 uses a folder named DATA. In the DATA folder the used LockScreen image is stored.

ToDp:

1. create a folder with the name LockScreen and copy the two scripts Create-LockScreenps1. and Remove-LockScreen.ps1 into this folder.
2. create a folder with the name "Data" in the folder "LockScreen" and copy the used image Example LockScreen.jpg in the folder "Data".
3. adjust the variable in the two copied scripts to your needs.
4. reate an Intune Win32 application using the IntuneWinAppUtil tool. The complete LockScreen order must to be used.


### Version
***

Name of File | Version | Date
--- | --- | ---
**Create-LockScreen.ps1** | `1.0` | **05/09/2022**
**Remove-LockScreen.ps1** | `1.0` | **05/10/2022**
**Detect-CreateLockScreen.ps1** | `1.0` | **05/10/2022**

### FAQs
***
Currently no questions are


