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



# Disabled the domain enter in argument and reload nginx to applicate this modification
# OK

function disabled { 

	if [ ! -e "/etc/nginx/conf.d/""$domain_name"* ]; then
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


