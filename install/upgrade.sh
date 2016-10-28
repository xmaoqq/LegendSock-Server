#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 检查当前用户是否 root
if [ $(id -u) != "0" ]; then
  echo "Error: You must be root to run this script";
  exit 1;
fi

# 检查是否已安装
if [ ! -d "/usr/local/legendsock" ]; then
  echo "LegendSock is not installed, please check it";
  exit 1;
fi

# 检查是否 CentOS
# if [ "`cat /etc/redhat-release 2>/dev/null| cut -d\  -f1`" != "CentOS" ]; then
#   echo "Error: The current system is not CentOS";
#   exit 1;
# fi

# 输出带颜色的文字
Color_Text()
{
  echo -e " \e[0;$2m$1\e[0m";
}
Echo_Blue()
{
  echo $(Color_Text "$1" "34");
}

clear
echo "+--------------------------------------------------------------------+";
echo "|                    LegendSock server for CentOS                    |";
echo "+--------------------------------------------------------------------+";
echo "|   For more information please visit https://www.legendsock.com     |";
echo "+--------------------------------------------------------------------+";
echo "|                      `Echo_Blue "Press any key to upgrade"`                      |";
echo "+--------------------------------------------------------------------+";
OLDCONFIG=`stty -g`;
stty -icanon -echo min 1 time 0;
dd count=1 2>/dev/null;
stty ${OLDCONFIG};
clear

FILENAME='legendsock.tar.gz';
echo "Downloading LegendSock server...";
yum install wget -y;
wget -c https://www.legendsock.com/box/server/$FILENAME -O /tmp/$FILENAME;
if [ -f "/tmp/${FILENAME}" ]; then
    echo "Stoping LegendSock Server...";
    /usr/bin/legendsock stop;

    echo "Backup your configure...";
    mv /usr/local/legendsock/usermysql.json /tmp;

    echo "Extract the file...";
    tar zvxf /tmp/$FILENAME -C /usr/local/;

    echo "Restore your configure...";
    mv /tmp/usermysql.json /usr/local/legendsock;

    echo "Upgrade your command file...";
    mv /usr/local/legendsock/legendsock /usr/bin/legendsock;
else
  echo "File download failed";
  exit 1;
fi

clear
Echo_Blue "LegendSock has been upgrade.";
echo "";
Echo_Blue "Website: https://www.legendsock.com";

# 删除自身
rm -rf $0;
