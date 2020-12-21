# create a directory to build the ISO from
mkdir iso

# extract the contents of the ISO to the directory, except the original squashfs image
# UBUNTU_ISO_PATH=path to the Ubuntu live ISO downloaded earlier
7z x '-xr!filesystem.squashfs' -oiso "$UBUNTU_ISO_PATH"

# copy our custom squashfs image and manifest into place
cp newfilesystem.squashfs iso/casper/filesystem.squashfs
stat --printf="%s" iso/casper/filesystem.squashfs > iso/casper/filesystem.size
cp newfilesystem.manifest iso/casper/filesystem.manifest

# update state files
(cd iso; find . -type f -print0 | xargs -0 md5sum | grep -v "\./md5sum.txt" > md5sum.txt)

# remove obsolete files
rm iso/casper/filesystem.squashfs.gpg

# build the ISO image using the image itself
sudo docker run \
    -it \
    --rm \
    -v "$(pwd):/app" \
    ubuntulive:image \
    grub-mkrescue -v -o /app/ubuntulive.iso /app/iso/ -- -volid UbuntuLive
