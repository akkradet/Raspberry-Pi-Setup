#!/bin/bash
xset s noblank
xset s off
xset -dpms
unclutter -idle 0.5 -root &
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' /home/pi/.config/chromium/Default/Preferences
sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' /home/pi/.config/chromium/Default/Preferences
/usr/bin/chromium-browser --noerrdialogs --disable-features=Translate --disable-component-update --disable-infobars --kiosk http://192.168.11.163/quality_control/slide1.php?line=1 http://192.168.11.163/quality_control/slide2.php?line=1 http://192.168.11.163/quality_control/slide3.php?line=1 http://192.168.11.163/quality_control/slide1.php?line=3 http://192.168.11.163/quality_control/slide2.php?line=3 http://192.168.11.163/quality_control/slide3.php?line=3 http://192.168.11.163/quality_control/slide1.php?line=4 http://192.168.11.163/quality_control/slide2.php?line=4 http://192.168.11.163/quality_control/slide3.php?line=4 &
while true; do
      xdotool keydown ctrl+Tab; xdotool keyup ctrl+Tab;xdotool key F5
      sleep 30
done
