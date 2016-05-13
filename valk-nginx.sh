#!/bin/bash

#Unofficial Bash Strict Mode
set -e
set -u
set -o pipefail
IFS=$'\n\t'

######################################
########### DESCRIPTION ##############
######################################
# valk-nginx [sub-command] [options] [arguments] 
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

nginx_log_dir="/home/thib/temp/log"
nginx_conf_dir="/home/thib/temp/conf"

######################################
############# FUNCTION ###############
######################################

# disable the domain enter in argument and reload nginx to applicate this modification
# OK
function disable() { 

	if [ ! -e "${domain_conf_path}.conf" ]; then
		echo "  File ${domain_conf_path}.conf not found"
		exit $FILE_NOT_FOUND 
	fi

	mv "${domain_conf_path}.conf" "${domain_conf_path}.disable"

	reload_nginx

}

# activate the domain enter in argument and reload nginx to applicate this modification
#OK
function activate() {
	
	if [ ! -e "${domain_conf_path}*" ]; then
		echo " File ${domain_conf_path} not found"
		exit $FILE_NOT_FOUND 
	fi

	mv "$domain_conf_path"* "$domain_conf_path".conf

	reload_nginx

}

#Create an empty conf file and log files related
#OK
function creat() {

	if [ -e "${domain_conf_path}"* ]; then
		echo "Error : This domain already exist."
		exit $DOMAIN_EXISTING
	fi

	touch "${domain_conf_path}".conf
	mkdir "$domain_log_path"
	touch "${domain_log_path}/error.log" "${domain_log_path}/access.log"

	reload_nginx

}

#Remove conf and log files related to a domain name
#OK
function remove() {

	if [ ! -e "${domain_conf_path}"* ]; then
		echo "  File ${domain_conf_path} not found"
		exit $FILE_NOT_FOUND 
	fi

	rm "${domain_conf_path}".*

	if [[ -z "${opt_k}" ]]; then
		rm -rf "${domain_log_path}"
	fi

	reload_nginx
}

#List all the active domain
#Vérifier comportement des options, fontionne de manière isolée
function list() {

declare -A result

result[0, 0]=DOMAIN
result[0, 1]=STATUS

j=1

set +e

if [[ -n "${opt_a}" ]]; then

	for entry in "${nginx_conf_dir}"/*; do

		p=`basename "$entry"`
		t=${p%.*}
		result[$j, 0]=$t

		echo "$p" | grep 'disable' > /dev/null
		not_found1=$?
		echo "$p" | grep '.conf' > /dev/null
		not_found2=$?

			if [[ $not_found1 == 0 ]]; then
			    result[$j, 1]=Inactive
			elif [[ $not_found2 == 0 ]]; then
			    result[$j, 1]=Active
			else 
				result[$j, 1]=Unknown
			fi
			
		((j++))

	done

elif [[ -n "${opt_d}" ]]; then

	for entry in "${nginx_conf_dir}"/*; do
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


	for entry in "${nginx_conf_dir}"/*; do
		p=`basename "$entry"`
		t=${p%.*}
		echo "$p" | grep '.conf' > /dev/null
	    not_found=$?
		if [[ $not_found == 0 ]]; then
		    result[$j, 1]=Active
		    result[$j, 0]=$t
		    ((j++))
		fi

	done
fi

set -e

let "k=${#result[@]}/2 - 1"

for ((i=0;i<=k;i++)) do
    printf   '%-30s %-30s\n' ${result[$i, 0]} ${result[$i, 1]}; 
done

unset -v result

}

#fucntion main who call the right function depending of the parameter
#ok
function main() {


case "$FUNC" in
	creat)
		creat
		;;
	disable)
		disable
		;;
	activate)
		activate
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

function reload_nginx() {
	
	systemctl reload nginx

}


function arguments() {

export FUNC="$1"
shift;

opt_a=""
opt_d=""
opt_k=""

#reading option put in input 
OPTS=$( getopt -o a,d,k -l all,disable -- "$@" )

eval set -- "$OPTS"

while true ; do
  case "$1" in
    -a|--all) 
      shift;
      export opt_a=AAA
      ;;
    -d|--disable) 
	  shift;
	  export opt_d=DDD
	  ;;
	-k|--keeplog)
	  shift;
	  export opt_k=KKK
	  ;;
    --)
      break;
      ;;
  esac
done

#reading the name of the domain we want to use
# NEED TO BE THE LAST ARG OF THE CALL
for last; do true; done
export domain_name=$last

export domain_log_path="${nginx_log_dir}/${domain_name}"
export domain_conf_path="${nginx_conf_dir}/${domain_name}"
}

function main() {

case "$FUNC" in
	creat)
		creat
		;;
	disable)
		disable
		;;
	activate)
		activate
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
################ MAIN ################
######################################

arguments "$@"

main 

exit