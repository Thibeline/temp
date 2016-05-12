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

files_log_location="/home/thib/temp/log/"
file_conf_location="/home/thib/temp/conf/"
log_location_name="${files_log_location}${domain_name}"
conf_location_name="${file_conf_location}${domain_name}"



######################################
############# FUNCTION ###############
######################################

# Disabled the domain enter in argument and reload nginx to applicate this modification
# OK
function disabled() { 

	if [ ! -e "$file_conf_location${domain_name}.conf" ]; then
		echo "  File ""$file_conf_location""$domain_name"".conf not found"
		exit FILE_NOT_FOUND 
	fi

	mv "$file_conf_location""$domain_name".conf "$file_conf_location""$domain_name".disabled

	systemctl reload nginx

}

# Enabled the domain enter in argument and reload nginx to applicate this modification
#OK
function enabled() {
	
	if [ ! -e "${conf_location_name}.disabled" ]; then
		echo " File ${conf_location_name}.disable not found"
		exit FILE_NOT_FOUND 
	fi

	mv "$conf_location_name".disabled "$conf_location_name".conf

	systemctl reload nginx

}

#Create an empty conf file and log files related
#OK
function created() {

	if [ -e "${conf_location_name}"* ]; then
		echo "Error : This domain already exist."
		exit DOMAIN_EXISTING
	fi

	touch "${conf_location_name}".conf
	mkdir "$log_location_name"
	touch "${log_location_name}/error.log" "${log_location_name}/access.log"

	systemctl reload nginx

}

#Remove conf and log files related to a domain name
#OK
function remove() {

	if [ ! -e "${conf_location_name}"* ]; then
		echo "  File ${conf_location_name}.conf not found"
		exit FILE_NOT_FOUND 
	fi

	rm "${conf_location_name}".*
	rm -rf "${log_location_name}"
	

	systemctl reload nginx

}

#List all the active domain
#Vérifier comportement des options, fontionne de manière isolée
function list() {

declare -A result

result[0, 0]=DOMAIN
result[0, 1]=STATUS

j=1

if [[ -n "${opt_a}" ]]; then
	for entry in "${file_conf_location}"*; do

		p=`basename "$entry"`
		t=${p%.*}
		result[$j, 0]=$t

		echo "$p" | grep 'disable' > /dev/null
		not_found=$?

			if [[ $not_found == 1 ]]; then
			    result[$j, 1]=Active
			else
			    result[$j, 1]=Inactive
			fi
			
		((j++))

	done

elif [[ -n "${opt_d}" ]]; then
	for entry in "${file_conf_location}"*; do
		p=`basename "$entry"`
		t=${p%.*}
		echo "$p" | grep 'disable' > /dev/null
	    not_found=$?
			if [[ $not_found == 0 ]]; then
			    result[$j, 1]=Inactive
			    result[$j, 0]=$t
			    ((j++))
			fi

	done
else

	for entry in "${file_conf_location}"*; do
		p=`basename "$entry"`
		t=${p%.*}
		echo "$p" | grep 'disable' > /dev/null
	    not_found=$?
		if [[ $not_found == 1 ]]; then
		    result[$j, 1]=Active
		    result[$j, 0]=$t
		    ((j++))
		fi

	done
fi

let "k=${#result[@]}/2"

for ((i=0;i<=k;i++)) do
    printf   '%-30s %-30s\n' ${result[$i, 0]} ${result[$i, 1]}; 
done

unset -v result

}


function main() {


case "$func" in
	created)
		created
		;;
	disabled)
		disabled
		;;
	enabled)
		enabled
		;;
	remove)
		remove
		;;
	list)
		list
		;;
esac

}
######################################
############# PROTECTED ##############
######################################

######################################
################ MAIN ################
######################################

func="$1"
shift;

OPTS=$( getopt -o a,d -l all,disable -- "$@" )

eval set -- "$OPTS"

while true ; do
  case "$1" in
    -a|--all) 
      shift;
      opt_a=AAA
      ;;
    -d|--disable) 
	  shift;
	  opt_d=BBB
	  ;;
    --)
      break;
      ;;
  esac
done


for last; do true; done
domain_name=$last

log_location_name="${files_log_location}${domain_name}"
conf_location_name="${file_conf_location}${domain_name}"

main

exit