# Maintenance

As a best practice, if you know a node will be down for maintenance, it is best to drain and cordon the node. A node that is drained will tell the scheduler to place existing pods on other nodes. A cordoned node will not be able to schedule pods. 

After maintenance is completeed (for example, a reboot of the server), the node should be uncordoned. 