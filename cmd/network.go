package cmd

//Network is multicloud vpc type
type Network struct {
	Name   string
	Vpcs   map[string]string
	Parent *Project
}
