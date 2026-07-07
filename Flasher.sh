#!/bin/bash
set -euo pipefail

# A simple shell script for flashing USB drives using the dd command

echo "Available disks:"
diskutil list external
read -rp "Enter USB drive identifier from options above:" identifier
read -rp "Enter path to disk image:" image

if [[ ! "$identifier" =~ ^disk[0-9]+$ ]]; then 
  echo "Invalid disk identifier."
  exit 1
fi

if [[ ! -f "$image" ]]; then
  echo "File doesn't exist."
  exit 1
fi

target="/dev/r$identifier"

echo
echo "Image: $image"
echo "Target: $target"
echo "THIS WILL ERASE THE TARGET DRIVE ENTIRELY."
read -rp "Type flash to continue: " confirmation

if [[ "$confirmation" != "flash"]]; then
  echo "Cancelled"
  exit 0
fi

diskutil unmountDisk "$identifier"
sudo dd if="$image" of="$target" bs=4m status=progress
sync
diskutil eject $identifier

echo "Flash succesful."
