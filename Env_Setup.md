# Operating System used
  CentOS 9
    Copy lab to your Centos machine by executing the following commands:
    [maven-admin@localhost tmp]$ mkdir nms_lab
    [maven-admin@localhost tmp]$ cd nms_lab/
    [maven-admin@localhost nms_lab]$ scp -r ishtiaqh@192.168.1.244:~/devel/mavensw/mavennms/lab/* /tmp/nms_lab/
    
# Aleternatively, copylab from remote machine to local machine using sshfs
    ishtiaqh@MVNIT21021:/tmp/_z_temp_plugin$ sshfs -o allow_other maven-admin@192.168.1.181:/tmp/nms_lab .

# Install Core Tools (Podman, Git, Python, Java)
    ## Install Podman, Git, and Java 17
    sudo dnf install -y podman git java-17-openjdk-devel python3

    ## Install podman-compose via pip (recommended for latest version)
       pip3 install podman-compose
    
    Install Apache Maven (For Plugin Development)
    OpenNMS plugins require Maven to compile Java code into .jar files.   
    sudo dnf install -y maven
    
    # Verify installation
    mvn -version


# 🏗️ Environment Setup
  Configure Environment:
  Edit nms.env with your desired credentials and database settings.

  Run the Orchestrator:
  
  Navigate to the automation folder and execute the setup script:   
  cd automation/setup/opennms/container
  chmod +x ./opennms-setup.sh
  ./opennms-setup.sh
  
# Check if your Podman containers are running:
  podman ps

# 📋 Prerequisites  
  Tool	          Recommended Version	                Purpose

  Podman	        4.0+	                              Container engine (Daemonless)
  podman-compose	1.0.6+	                            Orchestrating multi-container setups
  Git	            2.25+	                              Managing submodules and versioning
  Python	        3.9+	                              Running provision_node.py and automation
  Java (JDK)	    17	                          Required for Plugin Development

