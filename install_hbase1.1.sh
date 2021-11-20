#set -x
echo "Starting hbase phoenix zookeeper installation"
echo " Step 1 - Download/Extract the tarball -> HBase installation -> Zookeeper Installation -> Phoenix Installation "
cd /home/hduser/install/
wget https://archive.apache.org/dist/hbase/1.1.10/hbase-1.1.10-bin.tar.gz
echo -e "hduser" | sudo -S rm -rf /usr/local/hbase
tar xvzf hbase-1.1.10-bin.tar.gz
echo -e "hduser" | sudo -S mv hbase-1.1.10 /usr/local/hbase

echo -e "hduser" | sudo -S rm -rf /usr/local/zookeeper
tar xvzf zookeeper-3.4.6.tar.gz
sudo mv zookeeper-3.4.6 /usr/local/zookeeper

wget http://archive.apache.org/dist/phoenix/apache-phoenix-4.11.0-HBase-1.1/bin/apache-phoenix-4.11.0-HBase-1.1-bin.tar.gz
tar xvzf apache-phoenix-4.11.0-HBase-1.1-bin.tar.gz
echo -e "hduser" | sudo -S rm -rf /usr/local/phoenix
sudo mv apache-phoenix-4.11.0-HBase-1.1-bin /usr/local/phoenix

hadoop fs -rmr /user/hduser/hbase

echo " Step 2 - Setup zookeeper, hbase conf "
cd /usr/local/zookeeper/conf
mv zoo_sample.cfg zoo.cfg
sed -i 's/dataDir=\/tmp\/zookeeper/dataDir=\/usr\/local\/zookeeper\/data/g' zoo.cfg
mkdir /usr/local/zookeeper/data

cd /usr/local/hbase/conf
echo 'export HBASE_MANAGES_ZK=false' >> hbase-env.sh
echo 'export HBASE_CLASSPATH=/usr/local/hbase/lib' >> hbase-env.sh

echo " Step 3 - Copy all dependencies for hbase phoenix integration "
cd /usr/local/phoenix/
cp phoenix-hive-4.11.0-HBase-1.1.jar /usr/local/hbase/lib/
cp phoenix-4.11.0-HBase-1.1-client.jar /usr/local/hbase/lib/
cp phoenix-core-4.11.0-HBase-1.1.jar /usr/local/hbase/lib/
cp phoenix-4.11.0-HBase-1.1-server.jar /usr/local/hbase/lib/


echo "Step 4 - Add the below line in hive-env.sh to locate hbase lib path as auxiliary hive jar path to use hbase jars" 

cd /usr/local/hive/conf/
mv hive-env.sh.template hive-env.sh
echo "export HIVE_AUX_JARS_PATH=/usr/local/hbase/lib" >> hive-env.sh

echo " Step 5 - Copy all dependencies for hbase and phoenix with hive integration "

cp /usr/local/hbase/lib/hbase-common-1.1.10.jar /usr/local/hive/lib/
cp /usr/local/hbase/lib/zookeeper-3.4.6.jar /usr/local/hive/lib/
cp /usr/local/hbase/lib/guava-12.0.1.jar /usr/local/hive/lib/
cp /usr/local/hbase/lib/hbase-protocol-1.1.10.jar /usr/local/hive/lib/
cp /usr/local/hbase/lib/hbase-server-1.1.10.jar /usr/local/hive/lib/
cp /home/hduser/install/antlr-runtime-3.5.2.jar /usr/local/hive/lib/
cp /home/hduser/install/phoenix-hive-4.11.0-HBase-1.1.jar /usr/local/hive/lib/
cp /home/hduser/install/twill-discovery-api-0.14.0.jar /usr/local/hive/lib/
cp /home/hduser/install/twill-zookeeper-0.14.0.jar /usr/local/hive/lib/

cp hbasehivejars/hbase-site.xml /usr/local/hbase/conf/hbase-site.xml
