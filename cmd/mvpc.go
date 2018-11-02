package cmd

//MVPC is multicloud vpc type
type MVPC struct {
	Name string
	Vpcs map[string]*string
}

//newMVPC creates new MVPC
func (en *Environment) newMVPC(n string) *MVPC {
	en.MVPCs[n] = &MVPC{
		Name: n,
		Vpcs: make(map[string]*string),
	}
	return en.MVPCs[n]
}
