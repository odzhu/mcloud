package cmd

//Network is multicloud vpc type
type Network struct {
	Name string
	Vpcs map[string]*string
}

//newNetwork creates new Network
func (en *Project) newNetwork(n string) *Network {
	en.Networks[n] = &Network{
		Name: n,
		Vpcs: make(map[string]*string),
	}
	return en.Networks[n]
}
