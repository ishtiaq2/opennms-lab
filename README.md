nano ~/.bashrc
alias nms-sync='cd /home/my_github_repo/opennms-lab/automation && git pull origin main && cd /home/my_github_repo/opennms-lab && git add automation && git commit -m "chore: sync automation submodule" && git push origin main'
source ~/.bashrc
