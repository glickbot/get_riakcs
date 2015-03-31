VERSION=0.01

all: centos6

centos6:
	cd build/centos6 && tar -czf get_riakcs-v$(VERSION)-centos6.tar.gz ./get_riakcs

upload-centos6:
	s3cmd put --acl-public --guess-mime-type build/centos6/get_riakcs-v0.01-centos6.tar.gz s3://ps.basho/get_riakcs/get_riakcs-v0.01-centos6.tar.gz

