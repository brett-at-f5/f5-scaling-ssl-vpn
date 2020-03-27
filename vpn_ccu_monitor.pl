#!/usr/bin/perl -w

#**
#** Name   : vpn_ccu_monitor.pl
#** Author : brett-at-f5
#** Description: Used in conjunction with vpn_ccu_monitor_irule
#** Version: 1.0
#**

use strict;

## Edit these variables

# User defined threshold. This is less than or equal to the total-connectivity-sessions (licensed)
my $threshold=400;

# Virtual Server hosting an iRule to update the APM status
my $vpn_monitor_vs="10.50.2.101";

##

# Subroutine that returns the current-connectivity-sessions (used)
sub used_ccu {
    my $tmsh=`tmsh show apm license field-fmt | grep current-connectivity-sessions`;
    $tmsh=~ s/^\s+|\s+$//g;
    my @ccu=split(' ', $tmsh);
    return $ccu[1];
}

# Subroutine to change the monitor state to Offline
sub offline {
    my ($vs) = @_;
    my $curl=`curl -s "http://$vs/offline"`;
}

# Subroutine to change the monitor state to Online
sub online {
    my ($vs) = @_;
    my $curl=`curl -s "http://$vs/online"`;
}

# Return the current-connectivity-sessions (used)
my $used=used_ccu();

my $status;

# If the current-connectivity-sessions is greater or equal to the defined threshold, mark the APM node as disabled
if ($used >= $threshold) {
    # add error log message to /var/log/ltm
    # offline
    $status = offline($vpn_monitor_vs);
} else {
    # online
    $status = online($vpn_monitor_vs);
}
