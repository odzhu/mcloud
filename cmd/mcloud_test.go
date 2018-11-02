package cmd

import "testing"

func TestNewMcloud(t *testing.T) {
	if mc := newMcloud(); mc.Environments == nil {
		t.Errorf("newMcloud is not properly initialized, mc.Environments is nil")
	}
}
