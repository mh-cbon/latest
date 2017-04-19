package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
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

	flag.StringVar(&asset, "asset", "", "The asset to download.")
	flag.StringVar(&repo, "repo", "", "The repo slug such USER/REPO.")
	flag.StringVar(&arch, "arch", "amd64", "The arch to select the asset.")
	flag.StringVar(&version, "version", "", "The version to select the asset.")
	flag.BoolVar(&showVer, "v", false, "Show version")

	flag.Parse()

	if showVer {
		fmt.Println("latest - 0.0.1")
		os.Exit(0)
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
		u := fmt.Sprintf(`https://api.github.com/repos/%v/releases/latest`, repo)
		r := getURL(u)
		k := map[string]interface{}{}
		json.Unmarshal(r, &k)

		if x, ok := k["tag_name"]; ok {
			version = x.(string)
		} else {
			panic("latest version not found")
		}
	}
	fmt.Println("asset", asset)
	fmt.Println("version", version)

	assetU := fmt.Sprintf(`https://github.com/%v/releases/download/%v/%v`, repo, version, asset)
	dlURL(assetU, asset)

	if ext == extDEB {
		maybesudo(`%v -i %v`, dmBin, asset)
		maybesudo(`apt-get install --fix-missing`)
	} else if ext == extRPM {
		maybesudo(`%v install %v -y`, dmBin, asset)
	}

	removeAll(asset)
}
