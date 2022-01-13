echo "Splunk Univeral Forwarder Setup running..."
echo "Downloading binary from splunk.com"
curl https://download.splunk.com/products/universalforwarder/releases/7.3.3/linux/splunkforwarder-7.3.3-7af3758d0d5e-linux-2.6-x86_64.rpm --output /tmp/splunkforwarder-7.3.3-7af3758d0d5e-linux-2.6-x86_64.rpm
echo "Installing binary..."
rpm -Uvh splunkforwarder-7.3.3-7af3758d0d5e-linux-2.6-x86_64.rpm
chown -R splunk:splunk /opt/splunkforwarder
output=$(sudo -u splunk /opt/splunkforwarder/bin/splunk start --accept-license --answer-yes --no-prompt --gen-and-print-passwd 2>&1 | tee /dev/tty)
pat='admin\spassword\:\s(.*?)\sSplunk'
echo "Enable init.d bootscript"
/opt/splunkforwarder/bin/splunk enable boot-start -user splunk -systemd-managed 0
[[ $output =~ $pat ]]
splunkpw=("${BASH_REMATCH[1]}")
echo "Setting deployment server..."
sudo -u splunk /opt/splunkforwarder/bin/splunk set deploy-poll localhost:8089 -auth admin:$splunkpw
sudo -u splunk /opt/splunkforwarder/bin/splunk restart

# Clean up
rm -f /tmp/splunkforwarder-7.3.3-7af3758d0d5e-linux-2.6-x86_64.rpm