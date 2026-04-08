package cmd

import (
	"bytes"
	"testing"
)

func TestVersionCommandOutput(t *testing.T) {
	oldVersion := Version
	Version = "v9.9.9"
	t.Cleanup(func() {
		Version = oldVersion
	})

	buf := new(bytes.Buffer)
	rootCmd.SetOut(buf)
	rootCmd.SetErr(buf)
	rootCmd.SetArgs([]string{"version"})

	if err := rootCmd.Execute(); err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	got := buf.String()
	want := "assinatura version v9.9.9\n"
	if got != want {
		t.Fatalf("unexpected output\nwant: %q\n got: %q", want, got)
	}
}
