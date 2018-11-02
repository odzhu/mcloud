package cmd

import "testing"

func TestNewProject(t *testing.T) {
	if en := newMcloud().newProject("testname"); en.Networks == nil {
		t.Errorf("Network map is nil")
	}
}
