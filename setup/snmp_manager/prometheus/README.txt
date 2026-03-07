Instal Prometheus: 
wget https://github.com/prometheus/prometheus/releases/download/v2.54.1/prometheus-2.54.1.linux-arm64.tar.gz

# Extract the files
tar xvfz prometheus-2.54.1.linux-arm64.tar.gz

# Enter the directory
cd prometheus-2.54.1.linux-arm64

# Move the binaries to your system path
sudo cp prometheus /usr/local/bin/
sudo cp promtool /usr/local/bin/
sudo cp prometheus.yml /usr/local/bin
prometheus --version

# Verify architecture
uname -m


# Install SNMP Exporter according to architecture
wget https://github.com/prometheus/snmp_exporter/releases/download/v0.29.0/snmp_exporter-0.29.0.linux-arm64.tar.gz
tar xvf snmp_exporter-0.29.0.linux-arm64.tar.gz
sudo mv snmp_exporter-0.29.0.linux-arm64/snmp_exporter /usr/local/bin/
sudo chmod +x /usr/local/bin/snmp_exporter



# 2. Extract
tar xvfz snmp_exporter-*.tar.gz

# 3. Move binary
sudo cp snmp_exporter-*.linux-amd64/snmp_exporter /usr/local/bin/


# Prepare Your Workspace
mkdir -p ~/snmp-lab/mibs
cp RPI-MONITOR-MIB.txt ~/snmp-lab/mibs
cd ~/snmp-lab
nano snmp.yml:
 modules:
  rpi_module:
    walk:
    - 1.3.6.1.3.99

sudo /usr/local/bin/snmp_exporter --config.file=snmp.yml   

# On agent side a single rpi_monitor.py and edit agent snmpd.conf with:
# pass .1.3.6.1.3.99 /usr/bin/python3 /usr/local/bin/rpi_monitor.py and
# uncomment all other pass or extend lines

# curl "http://localhost:9116/snmp?target=192.168.0.38&module=rpi_module"


#### Prometheus #############
cd ~/snmp_manager/prometheus/prometheus-2.54.1.linux-arm64
nano prometheus.yml: 
  global:
  scrape_interval: 15s
  evaluation_interval: 15s
  # Alertmanager configuration
  alerting:
    alertmanagers:
      - static_configs:
          - targets:
            # - alertmanager:9093

  rule_files:
    scrape_configs:
  # Job 1: Monitor Prometheus itself (Keep this)
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]

  # Job 2: YOUR SNMP JOB (This was missing!)
  - job_name: 'rpi_snmp'
    static_configs:
      - targets:
        - 192.168.0.38  # <--- IP of your RPi3 Agent
    metrics_path: /snmp
    params:
      module: [rpi_module]
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: 192.168.0.37:9116 # <--- IP of the SNMP Exporter (RPi4)


./prometheus --config.file=prometheus.yml
http://192.168.0.37:9090

cp ../snmp_lab/prometheus.yml ~/snmp_manager/prometheus/prometheus-2.54.1.linux-arm64/