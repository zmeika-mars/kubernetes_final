#!/bin/bash

current_date=$(date +%d-%m-%Y)
source /etc/etcd.env

backup_dir="/opt/backup"

if [ -d ${backup_dir} ] && [ -e /etc/etcd.env ] 
then
  etcdctl snapshot save ${backup_dir}/etcd-snapshot-${current_date} --endpoints="127.0.0.1:2379" \
	  --cacert="${ETCD_TRUSTED_CA_FILE}" \
	  --cert="${ETCD_CERT_FILE}"\
	  --key="${ETCD_KEY_FILE}"
  find ${backup_dir} -type f -mtime +5 -delete
elif [ ! -d ${backup_dir} ] && [ -e /etc/etcd.env ]
then
  mkdir -p ${backup_dir} && \
  etcdctl snapshot save ${backup_dir}/etcd-snapshot-${current_date} --endpoints="127.0.0.1:2379" \ 
          --cacert="${ETCD_TRUSTED_CA_FILE}" \
	  --cert="${ETCD_CERT_FILE}" \
	  --key="${ETCD_KEY_FILE}"
else
  echo "Проверьте существование файла etcd.env в директории /etc"
  exit 1
fi

