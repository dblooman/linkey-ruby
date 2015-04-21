# Linkey

[![gem_version.png](https://img.shields.io/gem/v/linkey.svg)](https://rubygems.org/gems/linkey) [![gem_downloads.png](https://img.shields.io/gem/dt/linkey.svg)](https://rubygems.org/gems/linkey) [![travis.png](https://img.shields.io/travis/DaveBlooman/linkey/master.svg)](https://travis-ci.org/DaveBlooman/linkey) [![code_climate.png](https://img.shields.io/codeclimate/github/DaveBlooman/linkey.svg)](https://codeclimate.com/github/DaveBlooman/linkey)

**Link checker for BBC News & World Services sites.**

The idea is to quickly check a page for broken links by doing a status check on all the relative URL's on the page.

There are 4 parts to this tool, the URL, the base URL, the regex and the filename.  

* **URL** is the page that you want to check for broken links, e.g `www.bbc.co.uk/news/uk-29928282`
* **Base URL** is used with the relative URL from the regex to create a full URL, e.g `www.bbc.co.uk`
* **Regex** is the point of the URL that you want to keep from the regex, e.g `bbc.co.uk/news/uk`, specifying `/news` would create `/news/uk`.  
* **Filename** is markdown (.md) file where all the page links are stored, this can be useful for manual checks, e.g `file.md`

## Installation

    gem install linkey

## Usage

### Command Line

```
linkey check <url> <base_url> <regex> <filename>
```

**Examples**

```
linkey check http://www.bbc.co.uk/arabic http://www.bbc.co.uk /arabic arabic.md
```

```
linkey check http://www.theguardian.com/technology/2014/feb/15/year-of-code-needs-reboot-teachers http://theguardian.com /technology news.md
```
**Output**

Once running, you'll see either a 200 with `Status is 200 for <URL>` or `Status is NOT GOOD for <URL>`.

### Script It

```ruby
require 'linkey'

url = 'http://www.live.bbc.co.uk/arabic'
base = 'http://www.live.bbc.co.uk'
reg = '/arabic'
filename = 'arabic.md'

page = Linkey::SaveLinks.new(url, filename)
status = Linkey::CheckResponse.new(url, base, reg, filename)

page.capture_links
status.check_links
```

### From a File

If you have a lot of URLs that you want to check all the time using from a file is an alternative option.  This will utilise the smoke option, then point to a YAML file with the extension.  In some situations, we are deploying applications that we don't want public facing, so ensuring they 404 is essential.  There is a status code option to allow a specific status code to be set against a group of URL's, ensuring builds fail if the right code conditions are met.

```
linkey smoke test.yaml
```

Example YAML Config:

```yaml
base: 'http://www.bbc.co.uk'

concurrency: 100

headers:
 -
   X-content-override: 'https://example.com'

status_code: 200

paths:
  - /news
  - /news/uk
```

Via a Ruby script:

```ruby
require 'linkey'

tests = Linkey::Checker.new("path/to.yaml")
tests.smoke
```
