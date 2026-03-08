# Operating System used
  CentOS 9


# Getting Started (Cloning & Setup)

If you are cloning this repository for the first time, you must include the --recursive flag. This tells Git to also download the code inside the automation and plugins folders.

1. Clone the Repository
   git clone --recursive https://github.com/ishtiaq2/opennms-lab.git
   cd opennms-lab

2. If you already cloned it (and folders are empty)
   If you forgot the flag and your automation or plugins folders are empty, run this inside the opennms-lab folder:
   git submodule update --init --recursive

# 🏗️ Environment Setup
  Once the code is pulled, follow these steps to launch the lab:

  Configure Environment:
  Edit nms.env with your desired credentials and database settings.

  Run the Orchestrator:
  
  Navigate to the automation folder and execute the setup script:   
  cd automation/setup/opennms/container
  chmod +x ./opennms-setup.sh
  ./opennms-setup.sh
  
# Check if your Podman containers are running:
  podman ps

# Pro Tip for New Users
  If you plan on contributing, don't forget to set up the nms-sync alias in your .bashrc as described in the Maintenance section below!

# 📋 Prerequisites
  Before cloning, ensure your system has the following tools installed and configured:
  <img width="698" height="389" alt="image" src="https://github.com/user-attachments/assets/b6638e03-0cb8-4f61-9808-6d3bc19c7267" />
  
  Tool	          Recommended Version	                Purpose

  Podman	        4.0+	                              Container engine (Daemonless)
  podman-compose	1.0.6+	                            Orchestrating multi-container setups
  Git	            2.25+	                              Managing submodules and versioning
  Python	        3.9+	                              Running provision_node.py and automation
  Java (JDK)	    11 or 17	                          Required for Plugin Development

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
