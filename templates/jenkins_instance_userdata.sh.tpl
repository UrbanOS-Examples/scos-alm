#!/bin/bash

export log=/var/log/user_data.sh.log
export docker_data_dir=${mount_point}/${directory_name}
export worker_data_dir=${mount_point}/worker
export worker_user_id=10000

echo "About to run yum update" >> $log
yum -y update
echo "About to install efs utils via yum" >> $log
yum install -y amazon-efs-utils

echo "About to create directory for mount point for EFS network drive" >> $log
mkdir -p ${mount_point}
echo "Changing perms on mount point directory" >> $log
chmod 777 ${mount_point}

echo "Creating /etc/fstab entry for EFS drive" >> $log
echo "${efs_file_system_id} ${mount_point}        efs     defaults,_netdev 0  0" | sudo tee -a /etc/fstab

res=1
c=0
mount_successful=1
while [ $res -ne 0 ] ; do
  c=$((c+1))
  echo "Attempting to mount ${mount_point} drive" >> $log
  mount -o tls ${mount_point}
  res=`echo $?`
  if [ $res -eq 0 ] ; then
    mount_successful=0
    echo "Successfully mounted drive: ${mount_point}." >> $log
    break
  elif [ $res -eq 32 ] ; then
    mount_successful=0
    echo "Apparently the drive was already mounted: ${mount_point}." >> $log
    break
  fi
  if [ $c -gt 12 ] ; then
    echo "Waited for more than 120 seconds for the EFS drive to mount and still hasn't.  Aborting mount retry..." >> $log
    break
  fi
  echo "Failed to mount drive.  Waiting to retry" >> $log
  sleep 10
done

if [ $mount_successful -eq 0 ] ; then
  echo "Since the EFS mount was successful, need to change the permissions on $docker_data_dir directory." >> $log
  mkdir -p $docker_data_dir
  chmod 777 $docker_data_dir

  if [[ ! -d $worker_data_dir ]]; then
    (
    set -e
    echo "Since the EFS mount was successful, need to ensure the $worker_data_dir directory exists" >> $log
    rm -rf $worker_data_dir
    mkdir -p $worker_data_dir
    chown -R $worker_user_id:$worker_user_id $worker_data_dir
    )
  fi
fi

echo "Stopping ECS daemon" >> $log
initctl stop ecs

echo "Updating ecs.config file" >> $log
echo ECS_CLUSTER=${cluster_name} >> /etc/ecs/ecs.config

echo "Starting ECS daemon" >> $log
initctl start ecs

echo "Exiting user_data.sh" >> $log
