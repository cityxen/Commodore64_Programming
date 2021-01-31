###################################################################
# Copy d64 file to the Ultimate-II+ Cartridge USB drive using ftp
###################################################################
ftp -inv 192.168.1.5 <<EOF
user guest guest
cd Usb1/github/GPIOTracker/prg_files
delete gpiotracker.d64
lcd prg_files
binary
put gpiotracker.d64
bye
EOF