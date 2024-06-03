ETCD_VER=v3.5.5
 
# URL для загрузки диструбутива
GOOGLE_URL=https://storage.googleapis.com/etcd
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GITHUB_URL}
 
# Удаляем прошлые установки если не первая попытка, и создаем новую папку для установки.
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd-download-test
 
# Скачиваем и распаковываем файлы приложения, удаляем временные файлы
curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download-test --strip-components=1
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
 
# Проверяем корректность установки
/tmp/etcd-download-test/etcd --version
/tmp/etcd-download-test/etcdctl version
mv /tmp/etcd-download-test/etcd* /usr/local/bin/