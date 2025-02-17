FIRST_NAMESPACE = blue-namespace
SECOND_NAMESPACE = lemon-namespace
VETH_BLUE = veth-blue
VETH_LEMON = veth-lemon
BLUE_IP = 192.168.0.1
LEMON_IP = 192.168.0.2
NETWORK_MASK = 24



# ENAMBLE IP FORWARDING

enaIp:
     sudo sysctl -w net.ipv4.ip_forward=1


# Create two different Namespace

ns1: 
    sudo ip netns add $(FIRST_NAMESPACE)

ns2: 
    sudo ip netns add $(SECOND_NAMESPACE)


# Create a peer oneside veth_blue and other side veth_lemon


veth:
    sudo ip link add $(VETH_BLUE) type veth peer name $(VETH_LEMON)


set_blu:
       sudo ip link set $(VETH_BLUE) netns $(FIRST_NAMESPACE)

set_lemo:
	sudo ip link set $(VETH-LEMON) netns $(SECOND_NAMESPACE)



# Assign IP Addresses to the interfaces

blu_IP:
      suod ip netns exec $(FIRST_NAMESPACE) ip addr add $(BLUE_IP)/$(NETWORK_MASK) dev $(VETH_BLUE)


lem_IP:
      suod ip netns exec $(SECOND_NAMESPACE) ip addr add $(LEMON_IP)/$(NETWORK_MASK) dev $(VETH_LEMON)



# Set the Interface Up


Int_Up_Blu:
	  suod ip netns exec $(FIRST_NAMESPACE) ip link set $(VETH_BLUE) up

Int_Up_Lem:
	 suod ip netns exec $(SECOND_NAMESPACE) ip link set $(VETH_LEMON) up


# Set Default Route

  
set_def_route_Blu:
                 sudo ip netns exec $(FIRST_NAMESPACE) ip route add default via $(BLUE_IP) dev $(VETH_BLUE)


set_def_route_Lem:
                sudo ip netns exec $(SECOND_NAMESPACE) ip route add default via $(LEMON_IP) dev $(VETH_LEMON)


# Check Route

che_r_Blu:
         sudo ip netns exec $(FIRST_NAMESPACE) route

che_r_Lem:
	 sudo ip netns exec $(SECOND_NAMESPACE) route

# Test connectivity



pin_Blu:
	   sudo ip netns exec $(FIRST_NAMESPACE) ping $(LEMON_IP) 

pin_lemon:
		sudo ip netns exec $(SECOND_NAMESPACE) ping $(BLUE_IP)