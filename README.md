# This lab is purely for education purpose.

# 📂 Project Structure

This lab uses a nested repository architecture. The parent repository manages the environment, while sub-repositories handle specific tasks

<img width="1557" height="579" alt="image" src="https://github.com/user-attachments/assets/1b45953f-b480-4be4-9b62-1449471b1224" />


opennms-lab/ (Parent Repo)
├── .git/
├── .gitmodules            <-- Configuration for Submodules
├── nms.env                <-- Global Environment Variables
├── README.md              <-- This Guide
│
├── automation/ (Sub-Repo)  <-- Independent Main/Sub-branches
│   ├── .git/
│   └── setup/
│       └── opennms/
│           └── container/
│               ├── opennms-setup.sh  <-- Main Deployment Script
│               └── nms.env (symlink/copy)
│
└── plugins/ (Sub-Repo)     <-- Independent Main/Sub-branches
    ├── .git/
    ├── README.md
    └── src/                <-- Plugin Source Code


# 1. Update Everything (Parent Lab)

  If you want to pull the latest versions of both the automation scripts and the plugins:    
  git submodule update --remote --merge

# 2. Developer "Super Sync" Alias
  
  To automate the process of pulling sub-repo changes and updating the parent lab's pointers, add this to your ~/.bashrc:  
  alias nms-sync='git submodule update --remote --merge && cd /home/maven-admin/my_github_repo/opennms-lab && git add . && git commit -m "chore: sync all submodules" && git push origin main'

# 🧪 Development Workflow
  Automation Changes: cd automation, create a branch, test your script, merge to main on GitHub.

  Plugin Changes: cd plugins, develop your feature, push to the plugin repo.

  Lab Sync: Run nms-sync from the root of opennms-lab to ensure the entire environment reflects your latest work.  


# GOALS:
  ## Goal 1:
    SNMP Manager.txt:
    What this means for your OpenNMS Lab
    In your current opennms-lab setup, this "RPI-B" logic is exactly what you are trying to automate.
    OpenNMS is your SNMP Manager (replacing the manual snmpget commands).
    The Submodule automation should eventually contain the "Agent side" configuration (how to set up the NET-SNMP-EXTEND on a target node).
    The Submodule plugins is where you would build a custom OpenNMS Poller to recognize that specific RPI-MONITOR-MIB automatically.
      ### How to add this custom RPI-MONITOR-MIB to OpenNMS so it can graph your Raspberry Pi CPU temperature automatically?