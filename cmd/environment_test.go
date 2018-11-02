package cmd

import "testing"

func TestNewEnvironment(t *testing.T) {
	if en := newMcloud().newEnvironment("testname"); en.MVPCs == nil {
		t.Errorf("MVPCs map is nil")
	}
}
