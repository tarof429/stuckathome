FROM centos:7

RUN yum update -y && \
	yum -y install java-11-openjdk 
COPY apache-tomcat-8.5.77.tar.gz .
RUN mkdir -p /opt/tomcat && \
	tar xzf apache-tomcat-8.5.77.tar.gz -C /opt/tomcat

COPY tomcat-users.xml /opt/tomcat/apache-tomcat-8.5.77/conf/tomcat-users.xml
COPY host-manager-context.xml /opt/tomcat/apache-tomcat-8.5.77/webapps/host-manager/META-INF/context.xml
COPY manager-context.xml /opt/tomcat/apache-tomcat-8.5.77/webapps/manager/META-INF/context.xml

EXPOSE 8080

CMD ["/opt/tomcat/apache-tomcat-8.5.77/bin/catalina.sh", "run"]
