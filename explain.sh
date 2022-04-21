#!/bin/bash
## Written by Isaac Lee-Mort (C) 2020 ##
rows=`stty size | awk '{print $1}'`
columns=`stty size | awk '{print $2}'`
if [ "$1" == "--help"  ]; then
        clear
        if rpm -q figlet ; then
                clear
                figlet -f big 'Explainshell'
        else
                clear
                echo "Explainshell - CLI"
        fi
        printf '
        You want help?
         This is a Command Line wrapper for explainshell.com.
         By default, you will be taken to a browser to view the explanation.
         You can use "--dump" for this to be dumped out to the shell.
         An example usage would be:
                explain rsync -a -v -h
                explain --dump rsync -a -v -h
'
        exit
elif [ "$1" == "--dump"  ]; then
        dump=TRUE
        shift
        command=$*
        command=`echo $command | tr " " +`
        url='https://explainshell.com/explain?cmd='$command
else
        command=$*
        command=`echo $command | tr " " +`
        url='https://explainshell.com/explain?cmd='$command
fi
if rpm -q lynx > 2&> /dev/null ; then
#       echo "Lynx is installed"
        LYNX=TRUE
else
        echo "Lynx needs to be installed, would you like to proceed with this? (y/Y/n/N)"
        read response
        response=`echo $response | tr a-z A-Z`
        if [ "$response" == "Y" ]; then
                yum -q -y install lynx
        elif [ "$response" == "N" ]; then
                exit
        fi
fi

if [ "$dump" == "TRUE"  ]; then
        lynx --dump --nolist --width $columns $url | tail -n +9 #| head -n -15
else
        lynx --width $columns $url
fi
