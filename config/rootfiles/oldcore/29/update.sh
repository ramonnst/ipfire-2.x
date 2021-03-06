#!/bin/bash
############################################################################
#                                                                          #
# This file is part of the IPFire Firewall.                                #
#                                                                          #
# IPFire is free software; you can redistribute it and/or modify           #
# it under the terms of the GNU General Public License as published by     #
# the Free Software Foundation; either version 3 of the License, or        #
# (at your option) any later version.                                      #
#                                                                          #
# IPFire is distributed in the hope that it will be useful,                #
# but WITHOUT ANY WARRANTY; without even the implied warranty of           #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            #
# GNU General Public License for more details.                             #
#                                                                          #
# You should have received a copy of the GNU General Public License        #
# along with IPFire; if not, write to the Free Software                    #
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA #
#                                                                          #
# Copyright (C) 2009 IPFire-Team <info@ipfire.org>.                        #
#                                                                          #
############################################################################
#
. /opt/pakfire/lib/functions.sh
/usr/local/bin/backupctrl exclude >/dev/null 2>&1
/etc/init.d/collectd stop
/etc/init.d/snort stop
extract_files
rm -rf /var/log/rrd*//collectd/localhost/disk-*[0-9]*
rm -rf /srv/web/ipfire/cgi-bin/networks.cgi
rm -rf /etc/snort/rules/community-*
cat /etc/snort/snort.conf | grep -v community- > /tmp/snort.conf
mv -f /tmp/snort.conf /etc/snort/snort.conf
chown nobody.nobody /etc/snort/snort.conf
chmod 644 /etc/snort/snort.conf
/etc/init.d/collectd start
/etc/init.d/snort start
perl -e "require '/var/ipfire/lang.pl'; &Lang::BuildCacheLang"
#Remove some old compat-wireless modules (why they have change the path ?)
rm -rf /lib/modules/2.6.27.25-ipfire/kernel/drivers/net/wireless/ath?k
rm -rf /lib/modules/2.6.27.25-ipfire/kernel/drivers/net/wireless/rtl818?.ko
#Rebuild module dep's
depmod -a
