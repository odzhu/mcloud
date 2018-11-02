package cmd

//Environment type
type Environment struct {
	Name  string
	MVPCs map[string]*MVPC
}

//newEnvironment constructor

func (mc *Mcloud) newEnvironment(n string) *Environment {
	mc.Environments[n] = &Environment{
		Name:  n,
		MVPCs: make(map[string]*MVPC),
	}

	return mc.Environments[n]
}
