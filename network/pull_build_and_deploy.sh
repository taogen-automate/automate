#!/bin/bash

github_user=tagnja
proj_name=hot-crawler
target_name=hotcrawler

if ! [ -x "$(command -v git)" ]; then
	echo -e "\n\nInstall git...\n\n"
	sudo apt-get install git -y
	echo -e "\n\nGit installation is successful!\n\n"
fi

if ! [ -x "$(command -v mvn)" ]; then
	echo -e "\n\nInstall maven...\n\n"
	sudo apt-get install maven -y
	echo -e "\n\nMaven installation is successful!\n\n"
fi


if ! [[ -n $(ls $proj_name) ]]; then
	git clone https://github.com/$github_user/$proj_name.git
fi

cd $proj_name

echo -e "\n\nPull project...\n\n"
git pull
echo -e "\n\nPull project is successful!\n\n"

echo -e "\n\nBuild project...\n\n"
mvn package spring-boot:repackage
echo -e "\n\nBuild project is successful!\n\n"

if [[ -n $(pgrep -f java) ]]; then
	pid=$(pgrep -f java | head -n 1)
	echo -e "\n\nTo kill pid $pid...\n"
	sudo kill -9 $pid
	echo -e "Kill pid $pid is successful!\n\n"
fi

echo -e "\n\nStart project...\n\n"
java -jar ./target/$target_name-1.0-SNAPSHOT.jar &
