Running Pandemobium README
August 1st, 2011
By Blake Bowen, Fang Yuan, Carla Sotomayor

Installation instructions for Eclipse and Java JDK can be found at:
http://wiki.eclipse.org/Eclipse/Installation

README for Pandemobium app for iPhone can be found in
PANDEMOBIUM_HOME/iOS

RUNNING PANDEMOBIUM FROM AN ECLIPSE-BASED IDE

First, download the Android SDK so you can run an Android emulator:
Follow these instructions for installing and setting up the SDK on your
Eclipse-based IDE http://developer.android.com/sdk/installing.html
Next, import the PandemobiumStockTrader project into your favorite IDE’s
workspace:
Right click inside of the package explorer (usually on the left-hand 
side of your screen), select import, choose “Exisiting Projects into 
Workspace” inside the “General” folder as the import source, then select 
the location of the “PandemobiumStockTrader” location.
Finally, if you have set the window preferences to Android, you can now 
select the PandemobiumStockTrader in the package explorer, and then 
choose Run->Run As->Android Application.  This will start the SDK 
manager where you can choose a virtual device or create a new one.  This 
device will have the PandemobiumStockTrader app loaded into its app 
menu.

INSTALLING AND RUNNING PANDEMOBIUM USING ONLY IT’s .apk FILE

First, download the Android SDK so you can run the Android emulator:
http://developer.android.com/sdk/index.html
Next, put the .apk file inside the “(sdk-location)\platform-tools\” 
folder. Using the SDK Manager, after installing the suggested packages, 
create an Android device.  I recommend using the Google API platform 
2.2, but every package should work with Pandemobium.
Once your device is created, run it.
Inside the command prompt, cd into “(sdk-location)\platform-tools\”.
Now, run this command “adb –e install –r PandemobiumStockTrader.apk”.  
If the PandemobiumStockTrader.apk file is in the platform-tools folder, 
and your Android emulator is running, the Pandemobium app will be 
installed into your device, and appear in the app section of your 
virtual device.

INSTALLING TOMCAT AND RUNNING WEB SERVICES

(1) Download Tomcat binary distribution at:
http://tomcat.apache.org/download-70.cgi
(2) Unpack the binary distribution into a convenient location
 - typically to reside in its own directory named "apache-tomcat-7.x"
(3) Copy WAR file from PANDEMOBIUM_HOME\bin into TOMCAT_HOME\webapps
(4) Start Tomcat

NOTE: If running on Android device, and not emulator, the IP address
for the services (including account_service, trade_service, tip_service,
and tip_list) must be changed under
PANDEMOBIUM_HOME\Android\res\values\strings.xml