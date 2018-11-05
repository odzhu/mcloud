package cmd

//Project type
type Project struct {
	Name     string
	Networks map[string]*Network
	TFC      *TFConf
}

//newNetwork creates new Network
func (en *Project) newNetwork(n string) *Network {
	en.Networks[n] = &Network{
		Name: n,
		Vpcs: make(map[string]*string),
	}
	return en.Networks[n]
}
