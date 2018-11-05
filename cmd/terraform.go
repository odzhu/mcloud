package cmd

//TFConf is responsible for maintaing terrform configuration
type TFConf struct {
	workdir string
}

//get makes terraform get
func (*TFConf) get() (err error) {
	return
}

//render object configuration to the filesystem
func (*TFConf) render() (err error) {
	return
}

//plan is doing terraform plan
func (*TFConf) plan() (err error) {
	return
}

//apply is doing terraform apply
func (*TFConf) apply() (err error) {
	return
}
