# HTML open-graph Plugin for DITA-OT

[![license](https://img.shields.io/github/license/jason-fox/fox.jason.open-graph.svg)](http://www.apache.org/licenses/LICENSE-2.0)
[![DITA-OT 4.0](https://img.shields.io/badge/DITA--OT-4.0-blue.svg)](http://www.dita-ot.org/4.0)

This is a [DITA-OT Plug-in](https://www.dita-ot.org/plugins) used to add open graph meta data to DITA HTML output.

The Open Graph Protocol is a defined system to convey the contents of webpages on SNS.
By setting Open Graph properly, a specified `image` `title`  and `description` is displayed when a web content is shared.

![](https://jason-fox.github.io/fox.jason.open-graph/open-graph.png)

<details>
<summary><strong>Table of Contents</strong></summary>

-   [Background](#background)
-   [Install](#install)
    -   [Installing DITA-OT](#installing-dita-ot)
    -   [Installing the Plug-in](#installing-the-plug-in)
-   [Usage](#usage)
-   [License](#license)

</details>

## Install

The DITA-OT open-graph Plug-in  has been tested against [DITA-OT 4.x](http://www.dita-ot.org/download). It is recommended
that you upgrade to the latest version.

### Installing DITA-OT

<a href="https://www.dita-ot.org"><img src="https://www.dita-ot.org/images/dita-ot-logo.svg" align="right" height="55"></a>

The DITA-OT open-graph Plug-in  is a file reader for the DITA Open Toolkit.

-   Full installation instructions for downloading DITA-OT can be found
    [here](https://www.dita-ot.org/4.0/topics/installing-client.html).

    1.  Download the `dita-ot-4.0.zip` package from the project website at
        [dita-ot.org/download](https://www.dita-ot.org/download)
    2.  Extract the contents of the package to the directory where you want to install DITA-OT.
    3.  **Optional**: Add the absolute path for the `bin` directory to the _PATH_ system variable.

    This defines the necessary environment variable to run the `dita` command from the command line.

```console
curl -LO https://github.com/dita-ot/dita-ot/releases/download/4.0/dita-ot-4.0.zip
unzip -q dita-ot-4.0.zip
rm dita-ot-4.0.zip
```

### Installing the Plug-in

-   Run the plug-in installation commands:

```console
dita install https://github.com/jason-fox/fox.jason.open-graph/archive/master.zip
```

The `dita` command line tool requires no additional configuration.

---


## Usage


#### Adding Open Graph Meta Data to HTML output

To run, use any `html` transform and add the `open-graph.url` parameter.
The new `args.open-graph.*` parameters follow the existing syntax used by DITA-OT for CSS files.

```console
PATH_TO_DITA_OT/bin/dita -f [html5]  -o out -i PATH_TO_DITAMAP \
  --open-graph.url=WEBSITE_URL
```

To refer to an exisiting file hosted on a server, use a URL as the `args.open-graphpath` parameter

```console
PATH_TO_DITA_OT/bin/dita -f [html5]  -o out -i PATH_TO_DITAMAP \
  --open-graph.url=WEBSITE_URL \
  --open-graph.image=https://example.com/static/assets/image.svg
```

To refer to an exisiting file hosted on a server, use a URL as the `args.open-graphpath` parameter

```console
PATH_TO_DITA_OT/bin/dita -f [html5]  -o out -i PATH_TO_DITAMAP \
  --open-graph.url=WEBSITE_URL \
  --open-graph.root=PATH_TO_FILE \
  --open-graph.image=image.svg
```


### Parameter Reference

-  `open-graph.image.root` - File Location of the Open Graph Image file.
-  `open-graph.image` - Relative path to an image for Open Graph and Twitter.
-  `open-graph.image.alt` - Optional image description for Open Graph and Twitter.
-  `open-graph.site.name` - Optional Site Name for Open Graph.
-  `open-graph.title` - Fallback page title for Open Graph and Twitter.
-  `open-graph.description` - Fallback page description for Open Graph and Twitter.
-  `open-graph.url` - Website URL for Open Graph and Twitter.
-  `twitter.site` - The Twitter `@username` the page should be attributed to.

## License

[Apache 2.0](LICENSE) © 2022 Jason Fox
