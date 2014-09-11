#!/bin/zsh
# Time-stamp: <corsair 2009-04-29 09:51:45>

IFS_BAK=$IFS
INTERVAL=1
#ICONPATH="/home/corsair/.fvwm/icons/little"
#ICONPATH_ALT="/home/corsair/.fvwm/icons/dzen-bitmaps"
BAR_FG="#aecf96"
BAR_BG="gray22"
COLOR_ICON="#afc81c"
BAR_H=8
BAR_W=40
HEIGHT=14
FONT="-artwiz-anorexia-*-*-*-*-*-*-*-*-*-*-*-*"
# FONT="-*-terminus-*-*-*-*-12-*-*-*-*-*-*-*"

printVol()
{
    percentage=$(amixer |grep -A 6 \'Master\' |awk {'print $4'} |grep -m 1 % |sed -e 's/[][%]//g')
    ismute=$(amixer |grep -A 6 \'Master\'|awk {'print $6'} |grep -m 1 "[on|off]" | sed -e 's/[][]//g')

    if [[ $ismute == "off" ]]; then
        print -n "^fg($COLOR_ICON)^i($ICONPATH/vol-mute.xbm)^fg()"$(echo "0" | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $BAR_W)
    else
        print -n "^fg($COLOR_ICON)^i($ICONPATH/vol-hi.xbm)^fg()"$(echo $percentage |gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $BAR_W)
    fi
    return
}

printMem()
{
    MemTotal=`grep "MemTotal:" /proc/meminfo | awk '{print $2;}'`
    MemCached=`grep "Cached:" /proc/meminfo | head -n 1 | awk '{print $2;}'`
    MemUsed=`echo $MemTotal"-"$MemCached | bc`
    print -n `echo $MemUsed | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $BAR_W -max $MemTotal`
    return
}

CPUFreq=0
CPULoad0=0
CPULoad1=0
NetUp=0
NetDown=0
MPDArtist=
MPDTitle=
MPDStatus=
NewMail=0

printCPUInfo()
{
    #CPUTemp=$(~/bin/getcput.sh)
    CPUTemp="80"
    echo -n "^fg($COLOR_ICON)^i($ICONPATH/cpu.xbm)^fg()^fg()"$(echo $CPULoad0 | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w 25)$(echo $CPULoad1 | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w 25) @${CPUFreq}GHz"^fg($COLOR_ICON)^i($ICONPATH/temp.xbm)^fg()"$CPUTemp
    return
}

printMemInfo()
{
    echo -n "^fg($COLOR_ICON)^i($ICONPATH/mem.xbm)^fg()"$(echo $MemUsed | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $BAR_W)
    return
}

printNetInfo()
{
    echo -n "^fg($COLOR_ICON)^i($ICONPATH/down.xbm)^fg()"${NetDown}K/s"^fg($COLOR_ICON)^i($ICONPATH/up.xbm)^fg()"${NetUp}K/s
    return
}

printMPDInfo()
{
    if [[ $MPDStatus = "MPD not responding" ]]; then
        echo -n "^fg($COLOR_ICON)^i($ICONPATH/mpd.xbm)^fg()^fg(red)--^fg()"
    else
        echo -n "^fg($COLOR_ICON)^i($ICONPATH/mpd.xbm)^fg(#e76700)["$MPDStatus"]^fg()" $MPDTitle "^fg(blue)by^fg()" $MPDArtist
    fi
    return
}

printBattery()
{
    if [[ $ACStat = "on-line" ]]; then
        echo -n "^fg($COLOR_ICON)^i($ICONPATH/power-ac.xbm)^fg()"$(echo $BatRemain | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $BAR_W)
    else
        echo -n "^fg($COLOR_ICON)^i($ICONPATH/power-bat.xbm)^fg()"$(echo $BatRemain | gdbar -fg $BAR_FG -bg $BAR_BG -h $BAR_H -w $BAR_W)
    fi
    return
}

printDate()
{
    echo -n $(date "+%Y-%m-%d ^fg(green)%H:%M")
    return
}

#printMail()
#{
#    if [[ $NewMail != "0" ]]; then
#        echo -n "^fg()^i($ICONPATH_ALT/envelope.xbm)"$NewMail" "
#    fi
#    return
#}

printBetween()
{
    echo -n " ^fg(#5e0000)^r(4x4)^fg() "
    return
}

getConkyInfoAndPrintAll()
{
    while true; do
        IFS='|'
        read CPUFreq CPULoad0 CPULoad1 NetDown NetUp MemUsed BatRemain ACStat NewMail
        IFS=$IFS_BAK
        printCPUInfo
        printBetween
        printMemInfo
        printBetween
        printNetInfo
        printBetween
        printBattery
        printBetween
        printVol
        printBetween
        printDate
        echo
    done
    return
}

getMPDAndPrint()
{
    while true; do
        IFS='|'
        read  MPDArtist MPDTitle MPDStatus
#        Info=($=Info)
        IFS=$IFS_BAK
        printMPDInfo
        echo
    done
    return
}

conky-cli -c ~/.conky-clirc -u $INTERVAL | getConkyInfoAndPrintAll | dzen2 -x 500 -w 980 -h $HEIGHT -fn $FONT -ta r &
case $1 in
    xmonad)
        dzen2 -p -l 5 -m -w 64 -h $HEIGHT -fn $FONT < ~/.dzmenu &
        exec conky-cli -c ~/.conky-mpd.rc | getMPDAndPrint | dzen2 -w 436 -h $HEIGHT -x 64 -fn $FONT -ta l
        ;;
    *)
        exec conky-cli -c ~/.conky-mpd.rc | getMPDAndPrint | dzen2 -w 500 -h $HEIGHT -fn $FONT -ta l
esac
