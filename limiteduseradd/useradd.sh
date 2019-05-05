#!/bin/bash

# highlights color
Red='\e[0;31m'
Green='\e[0;32m'
Cyan='\e[0;36m'
Yellow='\e[0;33m'
NC='\e[0m'

function createuser()
{
	# enter username
	flagEnterUser=0
	
	while [[ $flagEnterUser != 1 ]]; do
		IFEXISTS=0
		read -p "Please enter the name of user:" NEWUSER
		
		#IFEXISTS=$(cat /etc/passwd | awk 'BEGIN{FS=":"}{print $1}' |grep $NEWUSER| wc -l)
		
		# check user to exists in /etc/passwd
		for line in $(cat /etc/passwd | awk 'BEGIN{FS=":"}{print $1}' |grep $NEWUSER); do
			if [[ $line == $NEWUSER ]]; then
				IFEXISTS=1
			fi
		done
	
		if [[ $IFEXISTS == 1 ]]; then
			echo -e "User ${Yellow} $NEWUSER ${NC} is already exists in /etc/passwd. Please choose another name"
			continue
		fi

		echo -e "new user is ${Green} $NEWUSER ${NC}" 
		flagEnterUser=1
	
	done

	# enter password
	read -p "Please enter a password for user:" NEWPASSWD
	
	# approve changes to the system
	#useradd -s /bin/bash -p $(openssl passwd -1 ${NEWPASSWD}) -d ${NEWHOMEFOLDER} ${NEWUSER}
	useradd -s /bin/bash ${NEWUSER}
	usermod -G wheel ${NEWUSER}
	echo ${NEWUSER}:${NEWPASSWD} | chpasswd
	#mkdir -p ${NEWHOMEFOLDER}
	#chown ${NEWUSER}:${NEWUSER} ${NEWHOMEFOLDER}
	EXPIRATION_DATE=$(date -d "$(date +%Y%m%d)+3 month" +%Y-%m-%d)
	chage -E "${EXPIRATION_DATE}" ${NEWUSER}
}

function update_expiration_date()
{
	read -p "Please enter the name of user:" CURRENTUSER
	EXPIRATION_DATE=$(date -d "$(date +%Y%m%d)+3 month" +%Y-%m-%d)
	chage -E "${EXPIRATION_DATE}" ${CURRENTUSER}
	echo -e "Expiration date for ${Green} $CURRENTUSER ${NC} was updated, and now this is ${EXPIRATION_DATE}"
}

function update_expiration_date()
{
	read -p "Please enter the name of user for deletion:" DELETEUSER
	userdel ${DELETEUSER}
}

# main functionality
echo ""
echo "Please select operations with backup users."
echo -en "${Cyan}"
cat << 'EOF'
Create user (C)
Delete user (D)
Update expiration date (U)
EOF
echo -en "${NC}"
#read -p "Please select operations with backup users. Create user(C) Delete user(D) Update user(U) Update quota(Q) Show limits for users(S):" opts
read -p "Your choose is: " opts

        case "${opts}" in
                C | c)
                        echo 'Create user'
                        createuser
                        exit
                ;;
                D | d)
                        echo 'Delete user'
                        deleteuser
                        exit
                ;;
		U | u)
		        echo 'Update expiration date'
			update_expiration_date
			exit
		;;
                *)
                        echo "Option is not correct. Please make your choose"
                ;;

esac
