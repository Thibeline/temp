#!/bin/bash

######################################
########### DESCRIPTION ##############
######################################

######################################
############ ERROR CODE ##############
######################################

######################################
############ VARIABLE ################
######################################

domain_name=$1

######################################
############# FUNCTION ###############
######################################

# Check if the domain name exist. If he exists return 0 else return 1.
function check_domain_name {


	if [ -f "/etc/nginx/conf.d/""$domain_name"* ];then
		return 0
	else
		return 1
	fi

}

# Disabled the domain enter in argument and reload nginx to applicate this modification
function disabled { 
	i=check_domain_name domain_name

	if [ i=1 ] then
		echo " This domain doesn't exist"
		exit 10 
	fi

	mv /etc/nginx/conf.d/"$domain_name".conf /etc/nginx/conf.d/"$domain_name".disabled

	systemctl reload nginx

}

######################################
############# PROTECTED ##############
######################################

######################################
################ MAIN ################
######################################


