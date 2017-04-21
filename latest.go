package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"path/filepath"
	"runtime"
	"strings"
)

var extDEB = ".deb"
var extRPM = ".rpm"

func main() {

	var arch string
	var repo string
	var asset string
	var version string
	var showVer bool
	var dry bool

	flag.StringVar(&asset, "asset", "", "The asset to download.")
	flag.StringVar(&repo, "repo", "", "The repo slug such USER/REPO.")
	flag.StringVar(&arch, "arch", "amd64", "The arch to select the asset.")
	flag.StringVar(&version, "version", "", "The version to select the asset.")
	flag.BoolVar(&showVer, "v", false, "Show version")
	flag.BoolVar(&dry, "dry", false, "Dry run")

	flag.Parse()

	if showVer {
		fmt.Println("latest - 0.0.1")
		os.Exit(0)
	}

	if repo == "" {
		fmt.Println("Missing required argument -repo")
		os.Exit(1)
	}

	x := strings.Split(repo, "/")
	name := x[1]

	if arch == "" {
		arch = runtime.GOARCH
	}

	dmBin := ""
	ext := ""
	if tryexec(`dpkg --version`) == nil {
		ext = extDEB
		dmBin = "dpkg"
	} else if tryexec(`dnf --version`) == nil {
		ext = extRPM
		dmBin = "dnf"
	} else if tryexec(`yum --version`) == nil {
		ext = extRPM
		dmBin = "yum"
	}

	if asset == "" {
		asset = fmt.Sprintf("%v-%v%v", name, arch, ext)
	}

	if version == "" {
		u := fmt.Sprintf(`https://api.github.com/repos/%v/releases`, repo)
		r := getURL(u)
		all := []map[string]interface{}{}
		json.Unmarshal(r, &all)

		found := false
		for _, ghVersion := range all {
			pr := ghVersion["prerelease"].(bool)
			if !pr {
				ghAssets := ghVersion["assets"].([]interface{})
				for _, ghAsset := range ghAssets {
					name := ghAsset.(map[string]interface{})["name"].(string)
					if filepath.Ext(name) == ext && strings.Index(name, "-"+runtime.GOARCH) > -1 {
						found = true
						if asset == "" {
							asset = name
						}
						break
					}
				}
			}
			if found {
				version = ghVersion["tag_name"].(string)
				break
			}
		}

		if !found {
			panic("latest version not found")
		}
	}

	fmt.Printf("Identified version %q and assset %q\n", version, asset)

	if dry == false {
		fmt.Println("Downloading and installing")
		assetU := fmt.Sprintf(`https://github.com/%v/releases/download/%v/%v`, repo, version, asset)
		dlURL(assetU, asset)

		if ext == extDEB {
			maybesudo(`%v -i %v`, dmBin, asset)
			maybesudo(`apt-get install --fix-missing --quiet`)
		} else if ext == extRPM {
			maybesudo(`%v install %v -y --quiet`, dmBin, asset)
		}

		removeAll(asset)
	}
}
