package cmd

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"

	"github.com/davecgh/go-spew/spew"
)

//Mcloud type
type Mcloud struct {
	Environments map[string]*Environment `json:"Environments"`
}

//newEnvironment main constructor, runs during each execurtion
func newMcloud() *Mcloud {
	mc := &Mcloud{
		Environments: make(map[string]*Environment),
	}
	mc.load(statefile)

	return mc
}

//statefile is default state file name located in working dir
const statefile string = ".state.mc"

//load state from file
func (s *Mcloud) load(f string) (err error) {
	var bytestate []byte

	if bytestate, err = ioutil.ReadFile(f); err == nil {
		err = json.Unmarshal(bytestate, &s)
	}

	return err
}

//save saves state to statefile
func (s *Mcloud) save(f string) (err error) {
	if jsonState, err := json.Marshal(s); err != nil {
		fmt.Println("Was not able to marshal")
		log.Fatal(err)
	} else {
		if err := ioutil.WriteFile(f, jsonState, 0666); err != nil {
			fmt.Println("Was not able to write state to", f, "!")
			log.Fatal(err)
		}
		fmt.Println("Save function saves: \n", s, "to file ", f)
	}

	return err
}

//init creates new state file and rotates previous one if exists
func (s *Mcloud) init(f string) (err error) {
	fmt.Println("Init function ran and f is:", f)
	if _, err = os.Stat(f); err != nil {
		//backup and init
		fmt.Println(f, " file is missing!")
		goto Save
	}

	if err = os.Rename(f, f+".1"); err != nil {
		log.Fatalln("Was not able to rename ", statefile, " Err: ", err)
	}

	s = newMcloud()
Save:
	if err = s.save(f); err != nil {
		log.Fatalln("Was not able to save ", statefile, " Err: ", err)
	}

	return err
}

//showState print state
func (s *Mcloud) show() {
	fmt.Println("\nState dumping:")
	spew.Dump(s)
}
