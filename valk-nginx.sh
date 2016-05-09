#!/bin/bash

######################################
########### DESCRIPTION ##############
######################################
# valk-nginx [options] [command] [arguments]
# To easly managed the configuration of website on nginx. 
# Regroup different tools which are automatizable.


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

	if [ ! -e "/etc/nginx/conf.d/""$domain_name"".conf" ]; then
		echo " file /etc/nginx/conf.d/""$domain_name"".conf not found" 
		exit 10

	fi

mv /etc/nginx/conf.d/"$domain_name".conf /etc/nginx/conf.d/"$domain_name".disabled

	systemctl reload nginx

######################################
############# PROTECTED ##############
######################################

######################################
################ MAIN ################
######################################


