package cmd

import "testing"

func TestNewMcloud(t *testing.T) {
	if mc := newMcloud(); mc.Projects == nil {
		t.Errorf("newMcloud is not properly initialized, mc.Projects is nil")
	}
}
