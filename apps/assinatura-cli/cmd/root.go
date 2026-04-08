package cmd

import "github.com/spf13/cobra"

// Version can be overridden at build time with -ldflags "-X github.com/BryanIP/runner/apps/assinatura-cli/cmd.Version=vX.Y.Z".
var Version = "v0.0.1"

var rootCmd = &cobra.Command{
	Use:   "assinatura",
	Short: "CLI de assinatura do Sistema Runner",
	Long:  "CLI de assinatura do Sistema Runner para operações de assinatura e validação.",
}

func init() {
	rootCmd.AddCommand(versionCmd)
}

func Execute() error {
	return rootCmd.Execute()
}
