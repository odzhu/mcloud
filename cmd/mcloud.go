package cmd

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"

	"github.com/davecgh/go-spew/spew"
)

//statefile is default state file name located in working dir
const statefile string = ".state.mc"
const defaultWorkDir string = "workdir"

//Mcloud type
type Mcloud struct {
	Projects map[string]*Project `json:"Projects"`
	Workdir  string
}

//newProject main constructor, runs during each execurtion
func newMcloud() *Mcloud {
	mc := &Mcloud{
		Projects: make(map[string]*Project),
		Workdir:  defaultWorkDir,
	}
	mc.load(statefile)

	return mc
}

//addProject constructor

func (mc *Mcloud) addProject(n string) {
	mc.Projects[n] = &Project{
		Name:     n,
		Networks: make(map[string]Network),
		Parent:   mc,
	}
	mc.Projects[n].addTFConf()
}

//load state from file
func (mc *Mcloud) load(f string) (err error) {
	var bytestate []byte

	if bytestate, err = ioutil.ReadFile(f); err == nil {
		err = json.Unmarshal(bytestate, &mc)
	}

	return err
}

//save saves state to statefile
func (mc *Mcloud) save(f string) (err error) {
	if jsonState, err := json.Marshal(mc); err != nil {
		fmt.Println("Was not able to marshal")
		log.Fatal(err)
	} else {
		if err := ioutil.WriteFile(f, jsonState, 0666); err != nil {
			fmt.Println("Was not able to write state to", f, "!")
			log.Fatal(err)
		}
		fmt.Println("Save function saves: \n", mc, "to file ", f)
	}

	return err
}

//init creates new state file and rotates previous one if exists
func (mc *Mcloud) init(f string) (err error) {
	fmt.Println("Init function ran and f is:", f)
	if _, err = os.Stat(f); err != nil {
		//backup and init
		fmt.Println(f, " file is missing!")
		goto Save
	}

	if err = os.Rename(f, f+".1"); err != nil {
		log.Fatalln("Was not able to rename ", statefile, " Err: ", err)
	}

	mc = newMcloud()
Save:
	if err = mc.save(f); err != nil {
		log.Fatalln("Was not able to save ", statefile, " Err: ", err)
	}

	return err
}

//showState print state
func (mc *Mcloud) show() {
	fmt.Println("\nState dumping:")
	spew.Dump(mc)
}
