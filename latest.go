package main

import (
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"net/http"
	"os"
	"runtime"
	"strings"

	"github.com/mh-cbon/latest/stringexec"
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
		fmt.Println("url", u)
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
		if tryexec("type sudo") == nil {
			exec(`sudo %v -i %v`, dmBin, asset)
			exec(`sudo apt-get install --fix-missing`)
		} else {
			exec(`%v -i %v`, dmBin, asset)
			exec(`apt-get install --fix-missing`)
		}
	} else if ext == extRPM {
		if tryexec("type sudo") == nil {
			exec(`sudo %v install %v -y`, dmBin, asset)
		} else {
			exec(`%v install %v -y`, dmBin, asset)
		}
	}

	os.Remove(asset)
}

func tryexec(w string, params ...interface{}) error {
	w = fmt.Sprintf(w, params...)
	cwd, err := os.Getwd()
	if err != nil {
		return err
	}
	fmt.Println("exec", w)
	cmd, err := stringexec.Command(cwd, w)
	if err != nil {
		return err
	}
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}

func exec(w string, params ...interface{}) {
	if err := tryexec(w, params...); err != nil {
		panic(err)
	}
}

func getURL(u string) []byte {
	response, err := http.Get(u)
	if err != nil {
		panic(err)
	}
	defer response.Body.Close()
	var ret bytes.Buffer
	_, err = io.Copy(&ret, response.Body)
	if err != nil {
		panic(err)
	}
	return ret.Bytes()
}

func dlURL(u, to string) bool {
	response, err := http.Get(u)
	if err != nil {
		panic(err)
	}
	defer response.Body.Close()
	f, err := os.Create(to)
	if err != nil {
		panic(err)
	}
	defer f.Close()
	_, err = io.Copy(f, response.Body)
	if err != nil {
		panic(err)
	}
	return true
}
