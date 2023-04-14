#!/usr/bin/env ash

#
# NVMe Storage Patch by AuxXxilium
#

getnvmestorage () {
    nvme0=$(udevadm info --query path --name nvme0n1 | awk -F "\/" '{print $4 ":" $5 }' | awk -F ":" '{print $2 ":" $3}' | sed 's/,*$//')
    nvme1=$(udevadm info --query path --name nvme1n1 | awk -F "\/" '{print $4 ":" $5 }' | awk -F ":" '{print $2 ":" $3}' | sed 's/,*$//')
    nvme2=$(udevadm info --query path --name nvme2n1 | awk -F "\/" '{print $4 ":" $5 }' | awk -F ":" '{print $2 ":" $3}' | sed 's/,*$//')
    nvme3=$(udevadm info --query path --name nvme3n1 | awk -F "\/" '{print $4 ":" $5 }' | awk -F ":" '{print $2 ":" $3}' | sed 's/,*$//')
    mdstat=$(cat /proc/mdstat | grep "md" | wc -l)
    patchnvmestorage
}

patchnvmestorage () {
    echo "NVMe Storage Init started"
#    if [ "$mdstat" -gt 2 ]; then
#        mdsys=$(cat /proc/mdstat | grep "md" | wc -l)
        if [ -n "$nvme0" ]; then
            echo 1 > /run/synostorage/disks/nvme0n1/m2_pool_support
#            nvmestat0=$(cat /proc/mdstat | grep "md" | grep "nvme0n1p3" | wc -l)
#            if [ "$nvmestat0" -eq 0 ]; then
#                synopartition --part --force /dev/nvme0n1 13
#                mdadm /dev/md0 -a /dev/nvme0n1p1
#                mdadm /dev/md1 -a /dev/nvme0n1p2
#                mdev0=$(expr $mdsys + 0)
#                echo "Create Nvme on /dev/md$mdev0"
#                mdadm  --stop /dev/md$mdev0
#                echo y | mdadm --create /dev/md$mdev0 --level=1 --raid-devices=1 --force /dev/nvme0n1p3
#                echo 0 > /sys/block/md$mdev0/queue/rotational
#                vgcreate vg1 /dev/$mdev0
#                echo "Nvme Storage 1 complete"
#            fi
        fi
        if [ -n "$nvme1" ]; then
            echo 1 > /run/synostorage/disks/nvme1n1/m2_pool_support
#            nvmestat1=$(cat /proc/mdstat | grep "md" | grep "nvme1n1p3" | wc -l)
#            if [ "$nvmestat1" -eq 0 ]; then
#                synopartition --part --force /dev/nvme1n1 13
#                mdadm /dev/md0 -a /dev/nvme1n1p1
#                mdadm /dev/md1 -a /dev/nvme1n1p2
#                mdev1=md$(expr $mdsys + 1)
#                echo "Create Nvme on /dev/$mdev1"
#                mdadm  --stop /dev/$mdev1
#                echo y | mdadm --create /dev/$mdev1 --level=1 --raid-devices=1 --force /dev/nvme1n1p3
#                echo 0 > /sys/block/$mdev1/queue/rotational
#                vgcreate vg2 /dev/$mdev1
#                echo "Nvme Storage 2 complete"
#            fi
        fi
        if [ -n "$nvme2" ]; then
            echo 1 > /run/synostorage/disks/nvme2n1/m2_pool_support
#            nvmestat2=$(cat /proc/mdstat | grep "md" | grep "nvme2n1p3" | wc -l)
#            if [ "$nvmestat2" -eq 0 ]; then
#                synopartition --part --force /dev/nvme2n1 13
#                mdadm /dev/md0 -a /dev/nvme2n1p1
#                mdadm /dev/md1 -a /dev/nvme2n1p2
#                mdev2=md$(expr $mdsys + 2)
#                echo "Create Nvme on /dev/$mdev2"
#                mdadm  --stop /dev/$mdev2
#                echo y | mdadm --create /dev/$mdev2 --level=1 --raid-devices=1 --force /dev/nvme2n1p3
#                echo 0 > /sys/block/$mdev2/queue/rotational
#                vgcreate vg3 /dev/$mdev2
#                echo "Nvme Storage 3 complete"
            fi
        fi
        if [ -n "$nvme3" ]; then
            echo 1 > /run/synostorage/disks/nvme3n1/m2_pool_support
#            nvmestat3=$(cat /proc/mdstat | grep "md" | grep "nvme3n1p3" | wc -l)
#            if [ "$nvmestat3" -eq 0 ]; then
#                synopartition --part --force /dev/nvme3n1 13
#                mdadm /dev/md0 -a /dev/nvme3n1p1
#                mdadm /dev/md1 -a /dev/nvme3n1p2
#                mdev3=md$(expr $mdsys + 3)
#                echo "Create Nvme on /dev/$mdev3"
#                mdadm  --stop /dev/$mdev3
#                echo y | mdadm --create /dev/$mdev3 --level=1 --raid-devices=1 --force /dev/nvme3n1p3
#                echo 0 > /sys/block/$mdev3/queue/rotational
#                vgcreate vg4 /dev/$mdev3
#                echo "Nvme Storage 4 complete"
            fi
        fi
    fi
}

getnvmestorage