[![Build Status](https://travis-ci.org/DaveBlooman/linkey.png?branch=master)](https://travis-ci.org/DaveBlooman/linkey)
Linkey
=====

Link checker for BBC News/WS Sites

The idea is to quickly check a page for broken links by doing a status check on all the relative URL's on the page.

There are 4 parts to this tool, the URL, the base URL, the regex and the filename.  

The URL is the page that you want to check for broken links, e.g www.bbc.co.uk/news/uk-29928282
The Base URL is used with the relative URL from the regex to create a full URL, e.g www.bbc.co.uk  
The regex is the point of the URL that you want to keep from the regex, e.g bbc.co.uk/news/uk, specifying /news would create /news/uk.  
The filename is .md file where all the page links are stored, this can be useful for manual checks, e.g file.md

## Install

`gem install linkey`

## Command line usage

To use run

```
linkey check URL BASEURL /regex Filename
```
Example

```
linkey check http://www.live.bbc.co.uk/arabic http://www.live.bbc.co.uk /arabic arabic.md
```
Another

```
linkey check http://www.theguardian.com/technology/2014/feb/15/year-of-code-needs-reboot-teachers http://theguardian.com /technology news.md
```
Output

Once running, you'll see either a 200 with
`Status is 200 for URL`
or
`Status is NOT GOOD for URL`

## Script it
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
## From a file

If you have a lot of URLs that you want to check all the time using from a file is an alternative option.  This will utilise the smoke option, then point to a YAML file with the extension.

```
linkey smoke test.yaml
```

Example yaml file
```yaml
base: 'http://www.bbc.co.uk'

paths:
  - /news
  - /news/uk
```


Smoke test

```ruby
require 'linkey'

tests = Linkey::Checker.new("path/to.yaml")
tests.smoke
```
