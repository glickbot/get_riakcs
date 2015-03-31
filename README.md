##get_riakcs

#### Description

```curl https://raw.githubusercontent.com/glickbot/get_riakcs/master/get_riakcs.sh | bash```

Fully automated one-liner to install a Riak CS cluster

#### Notes

* WIP
* Only for Centos6 at the moment

#### What's included

* ```get_riakcs.sh``` script, entry point for one-liner installs
* Vagrantfile to build tarball which includes a portable deployment of ansible w/Riak CS roles
* Ansible roles to spin up Riak CS cluster, and install Serf

#### TODO

* Configure Serf to setup cluster
* Future: Configure Serf for node/cluster lifecycle maintenance
* Future: Graphical/Web status view of cluster
* Future: Telemetry

#### Usage

		Usage: ./get_riakcs.sh [-v <ver>] [-r <rel>] [-t <tmp>] [-i <inst>] [-h]
		    Where:
		        -n <node_count> - number of nodes to expect
		        -t <tmp> - temp dir to use ( /tmp/ is default )
		        -i <inst> - get_riakcs install dir ( /opt/get_riakcs is default )
		        -h - this help screen

		############################################################

		Typical usage:

		    curl https://raw.githubusercontent.com/glickbot/get_riakcs/master/get_riakcs.sh | bash

		    curl https://raw.githubusercontent.com/glickbot/get_riakcs/master/get_riakcs.sh | <option>=<value> bash

		    Where <option>=<value> can be:
		        node_count=5
		        tmpdir="/other/dir"
		        install_path="/other/path"
