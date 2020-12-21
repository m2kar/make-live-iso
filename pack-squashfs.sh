#!/bin/bash
set -x
set -e

# run an instance of the Docker image
CONTAINER_ID=$(sudo docker run -d ubuntulive:image /usr/bin/tail -f /dev/null)
# delete the auto-created .dockerenv marker file so it doesn't end up in the squashfs image
sudo docker exec "${CONTAINER_ID}" rm /.dockerenv
# extract the Docker image contents to a tarball
sudo docker cp "${CONTAINER_ID}:/" - > newfilesystem.tar
# get the package listing for installation from ISO
sudo docker exec "${CONTAINER_ID}" dpkg-query -W --showformat='${Package} ${Version}\n' > newfilesystem.manifest
# kill the container instance of the Docker image
sudo docker rm -f "${CONTAINER_ID}"
# convert the image tarball into a squashfs image
tar2sqfs --quiet newfilesystem.squashfs < newfilesystem.tar