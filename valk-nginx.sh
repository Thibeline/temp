#!/bin/bash

######################################
########### DESCRIPTION ##############
######################################
# valk-nginx [sub-command] [arguments] [options] 
# To easly managed the configuration of website on nginx. 
# Regroup different tools which are automatizable.


######################################
############ ERROR CODE ##############
######################################

FILE_NOT_FOUND=10
DOMAIN_EXISTING=11

######################################
############ VARIABLE ################
######################################

domain_name=$1
files_log_location="/home/thib/var/www/"
file_conf_location="/etc/nginx/conf.d/"

######################################
############# FUNCTION ###############
######################################

# Disabled the domain enter in argument and reload nginx to applicate this modification
# OK
function disabled { 

	if [ ! -e "$file_conf_location""$domain_name"".conf" ]; then
		echo "  File ""$file_conf_location""$domain_name"".conf not found"
		exit FILE_NOT_FOUND 
	fi

	mv "$file_conf_location""$domain_name".conf "$file_conf_location""$domain_name".disabled

	systemctl reload nginx

}

# Enabled the domain enter in argument and reload nginx to applicate this modification
#OK
function enabled {
	
	if [ ! -e "$file_conf_location""$domain_name"".disabled" ]; then
		echo " File ""$file_conf_location""$domain_name"".disable not found"
		exit FILE_NOT_FOUND 
	fi

	mv "$file_conf_location""$domain_name".disabled "$file_conf_location""$domain_name".conf

	systemctl reload nginx

#Create an empty conf file and log files related
#OK
function created {

	if [ -e "$file_conf_location""$domain_name"* ]; then
		echo " This domain already exist."
		exit DOMAIN_EXISTING
	fi

	touch "$file_conf_location""$domain_name".conf
	mkdir "$files_log_location""$domain_name"
	touch "$files_log_location""$domain_name""/error-log" "$files_log_location""$domain_name""/acces-log"

	systemctl reload nginx

}

#Remove conf and log files related to a domain name
#OK
function remove {

	if [ ! -e "$file_conf_location""$domain_name"* ]; then
		echo "  File ""$file_conf_location""$domain_name"".conf not found"
		exit FILE_NOT_FOUND 
	fi

	rm "$file_conf_location""$domain_name".*
	rm -rf "$files_log_location""$domain_name"
	

	systemctl reload nginx

}

#List all the active domain
#ok
function list {

	echo "	DOMAIN" > int_name
	echo "		STATUS" > int_status

basename -a "$file_conf_location"*.conf > int.txt
#ls "$file_conf_location"*.conf *.disable > int.txt

cut -d '.' -f 1 < int.txt  >> int_name 

while read line
do
	echo "$line" | grep 'disable' > /dev/null
	not_found=$?

	if [[ $not_found == 1 ]]; then
		echo active >> int_status
	else
		echo inactive >> int_status
	fi

done < int.txt

paste int_name int_status

rm int*
}
######################################
############# PROTECTED ##############
######################################

######################################
################ MAIN ################
######################################


