echo "Splunk Univeral Forwarder Setup running..."
echo "Downloading binary from splunk.com"
curl https://download.splunk.com/products/universalforwarder/releases/9.1.1/linux/splunkforwarder-9.1.1-64e843ea36b1.x86_64.rpm --output /tmp/splunkforwarder-9.1.1-64e843ea36b1.x86_64.rpm
echo "Installing binary..."
rpm -Uvh splunkforwarder-9.1.1-64e843ea36b1.x86_64.rpm
chown -R splunkfwd:splunkfwd /opt/splunkforwarder
output=$(sudo -u splunkfwd /opt/splunkforwarder/bin/splunk start --accept-license --answer-yes --no-prompt --gen-and-print-passwd 2>&1 | tee /dev/tty)
pat='admin\spassword\:\s(.*?)\sSplunk'
echo "Enable init.d bootscript"
/opt/splunkforwarder/bin/splunk enable boot-start -user splunkfwd -systemd-managed 0
sudo -u splunkfwd /opt/splunkforwarder/bin/splunk restart

# Clean up
rm -f /tmp/splunkforwarder-9.1.1-64e843ea36b1.x86_64.rpm