package cmd

//Project type
type Project struct {
	Name     string
	Networks map[string]*Network
}

//newProject constructor

func (mc *Mcloud) newProject(n string) *Project {
	mc.Projects[n] = &Project{
		Name:     n,
		Networks: make(map[string]*Network),
	}

	return mc.Projects[n]
}
