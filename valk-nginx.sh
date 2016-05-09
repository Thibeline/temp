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
		echo " File /etc/nginx/conf.d/""$domain_name"".conf not found"
		exit 10 
	fi

	mv /etc/nginx/conf.d/"$domain_name".conf /etc/nginx/conf.d/"$domain_name".disabled

	systemctl reload nginx

}

# Enabled the domain enter in argument and reload nginx to applicate this modification
#OK
function enabled {
	
	if [ ! -e "/etc/nginx/conf.d/""$domain_name"".disabled" ]; then
		echo " File /etc/nginx/conf.d/""$domain_name"".disable not found"
		exit 10 
	fi

	mv /etc/nginx/conf.d/"$domain_name".disabled /etc/nginx/conf.d/"$domain_name".conf

	systemctl reload nginx

}

######################################
############# PROTECTED ##############
######################################

######################################
################ MAIN ################
######################################


