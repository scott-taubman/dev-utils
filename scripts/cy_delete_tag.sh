#!/usr/bin/env bash

containeryard_host="https://containeryard.evoforge.org"
containeryard_service="Docker%20registry"

usage() { echo "Usage: $0 -u <user> -i <image> -t <tag>" 1>&2; exit 1; }

if [ $# -ne 6 ]; then usage; fi

while getopts "u:i:t:" o; do
    case "${o}" in
        u)
            containeryard_user=${OPTARG}
            ;;
	i)
            containeryard_image=${OPTARG}
            ;;
        t)
            containeryard_tag=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

read -s -p "Enter containeryard password for $containeryard_user: " containeryard_password
echo
echo

if [ -z "${containeryard_user}" ]; then echo "Missing user"; usage; fi
if [ -z "${containeryard_password}" ]; then echo "Missing password"; usage; fi
if [ -z "${containeryard_image}" ]; then echo "Missing image"; usage; fi
if [ -z "${containeryard_tag}" ]; then echo "Missing tag"; usage; fi

# log in using username and password to get the bearer token for api requests
echo "Logging in to containeryard as: ${containeryard_user}"
auth_resp=$(curl "${containeryard_host}/auth?service=${containeryard_service}&scope=repository:${containeryard_user}/${containeryard_image}:*" \
	         -u "${containeryard_user}:${containeryard_password}" \
                 -H 'Accept: application/json' \
		 -X GET \
		 --silent
	   )

# make sure the auth was successful
if [ "${auth_resp}" == "Auth failed." ]; then
  echo "ERROR login failed"
  exit 1
fi

# extract the bearer token
token=$(echo ${auth_resp} | jq -r '.token')
if [ "${token}" != "null" ]; then
  echo " - got bearer token"
  echo
else
  echo "ERROR unable to get containeryard bearer token - invalid username / password"
  exit 1
fi

# get tags for specified image
echo "Getting tags for image: ${containeryard_user}/${containeryard_image}"
tag_lookup=$(curl "${containeryard_host}/v2/${containeryard_user}/${containeryard_image}/tags/list" \
	          -H "Authorization: Bearer ${token}" \
	  	  -X GET \
		  --silent | \
		  jq -r "select(.tags | index(\"${containeryard_tag}\")) .tags[]"
	    )

# confirm we found the tag for the image
if [ "${tag_lookup}" != "" ]; then
  echo " - found tag: ${containeryard_tag}"
  echo
else
  echo "ERROR unable to find image tag: ${containeryard_tag}"
  exit 1
fi


echo "Getting manifest for tag: ${containeryard_tag}"
# get the manifest for the tag
manifest=$(curl "${containeryard_host}/v2/${containeryard_user}/${containeryard_image}/manifests/${containeryard_tag}" \
	        -I \
		-H "Authorization: Bearer $token" \
		-H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
		-X GET \
		--silent | \
		grep -i "docker-content-digest"  | \
		awk '{print $2}' | \
		tr -d '\r'
	  )


# confirm we found the manifest for the tag
if [ "${manifest}" != "" ]; then
  echo " - found manifest: ${manifest}"
  echo
else
  echo "ERROR unable to find manifest for tag: ${containeryard_tag}"
  exit 1
fi

echo "---"
echo
echo -e "\e[93mYou are about to delete: ${containeryard_host}/${containeryard_user}/${containeryard_image}:${containeryard_tag}.\e[0m"
echo
echo "---"
echo

if [ ! "$y" == "true" ]; then
  while true; do
    read -p "Are you sure? [y/n] " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
  done
fi

echo
echo "Deleting manifest: ${manifest}"
delete_resp=$(curl "${containeryard_host}/v2/${containeryard_user}/${containeryard_image}/manifests/${manifest}" \
                   -I \
                   -H "Authorization: Bearer $token" \
                   -X DELETE \
		   --silent
             )

if [ $? -eq 0 ]
then
   echo " - deleted"
else
  echo "ERROR unable to delete manifest"
  echo $delete_resp
  exit 1
fi

echo
