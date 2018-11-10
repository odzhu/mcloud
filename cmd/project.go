package cmd

//Project type
type Project struct {
	Name     string
	Networks map[string]Network
	Parent   *Mcloud `json:"-"` // ignore on un/marshal
	TFC      TFConf
}

//newNetwork creates new Network
func (p *Project) addNetwork(n string) {
	p.Networks[n] = Network{
		Name:   n,
		Vpcs:   make(map[string]string),
		Parent: p,
	}
}
