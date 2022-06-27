orphans=`pacman -Qtdq | grep -c ""`
if [ $orphans == "" ]; then
	echo "0"
else
	echo $orphans
fi
