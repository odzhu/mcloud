package cmd

//TFConf is responsible for maintaing terrform configuration
type TFConf struct {
	Workdir string
	Parent  *Project `json:"-"`
}

//addTFConf initializes new object

func (p *Project) addTFConf() {
	p.TFC = TFConf{
		Parent:  p,
		Workdir: p.Parent.Workdir + "/" + p.Name,
	}
	//fmt.Println("addTFConfig seing parent variables in that way")
	//spew.Dump(p.Parent)
}
