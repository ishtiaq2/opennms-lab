nano ~/.bashrc

alias nms-sync='git submodule update --remote --merge && cd /home/maven-admin/my_github_repo/opennms-lab && git add . && git commit -m "chore: sync all submodules" && git push origin main'

source ~/.bashrc
