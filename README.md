# LiquidWeb

Perl Scripts for setting up RabbitMQ, consuming JSON Files, writing the JSON Files to InfluxDB and writing JSON Files to AWS S3.

Prerequisites Installation Steps:



1.Rabbit MQ 

echo 'deb http://www.rabbitmq.com/debian/ testing main' | sudo tee /etc/apt/sources.list.d/rabbitmq.list

wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -

sudo apt-get update

sudo apt-get install rabbitmq-server

2.InfluxDB

curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -

source /etc/lsb-release

echo "deb https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/influxdb.list

sudo apt-get update && sudo apt-get install influxdb

sudo service influxdb start

3.KairosDB

3.1 Java Installation

#check java is already installed
java -version

sudo apt-get install default-jre
sudo apt-get install default-jdk


sudo update-alternatives --config java

output:
There is only one alternative in link group java (providing /usr/bin/java): /usr/lib/jvm/java-8-openjdk-i386/jre/bin/java
Nothing to configure.

#set the java home
sudo gedit /etc/environment

 

JAVA_HOME=/usr/lib/jvm/java-8-openjdk-i386/jre/bin/java

export JAVA_HOME

3.2 Cassandra Installation

echo "deb-src http://www.apache.org/dist/cassandra/debian 22x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list

gpg --keyserver pgp.mit.edu --recv-keys F758CE318D77295D
gpg --export --armor F758CE318D77295D | sudo apt-key add -


gpg --keyserver pgp.mit.edu --recv-keys 2B5C1B00
gpg --export --armor 2B5C1B00 | sudo apt-key add -


gpg --keyserver pgp.mit.edu --recv-keys 0353B12C
gpg --export --armor 0353B12C | sudo apt-key add -

sudo apt-get update

sudo apt-get install cassandra

3.3 Kairos DB

Download the following repo and extract 
https://github.com/kairosdb/kairosdb/releases

go to location/bin

sudo ./kairosdb.sh run 

http://localhost:8080







