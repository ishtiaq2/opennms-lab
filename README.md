Getting Started

Lab Orchestration & Submodules

To add a new component (like a plugin development folder) that has its own main branch and lifecycle:
Create the repo on GitHub (e.g., opennms-plugins).

Initialize the submodule in the parent lab:
# Navigate to the lab root
cd /home/maven-admin/my_github_repo/opennms-lab

# Link the new repository
git submodule add https://github.com/ishtiaq2/opennms-plugins.git plugins

# Commit the new link to the parent repo
git add .
git commit -m "feat: added plugins development sub-repository"
git push origin main

2. Synchronization Alias
   To keep all submodules (Automation, Plugins, etc.) in sync with a single command, add the following alias to your shell profile.
   1. Open your bash configuration:
     nano ~/.bashrc

   2. Add the "Super Sync" alias:
     This command pulls the latest main for all submodules and updates the parent lab pointers automatically.     
     alias nms-sync='git submodule update --remote --merge && cd /home/maven-admin/my_github_repo/opennms-lab && git add . && git commit -m "chore: sync all submodules" && git push origin main'
     
   3. Apply the changes:
     source ~/.bashrc

3. Development Workflow
   Work on a Feature: Navigate into a submodule (e.g., cd automation), create a branch (git checkout -b feature-name), and push changes to that specific repo.

   Update the Lab: Once a sub-repo branch is merged to its main on GitHub, simply run nms-sync from anywhere to update the entire lab environment.

   
