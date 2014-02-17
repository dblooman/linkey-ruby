Linkey
=====

Link checker for BBC News/WS Sites

The idea is to quickly check a page for broken links by doing a status check on all the relative URL's on the page.  Set a URL, then set the point at which you want to strip out unwanted URLs, then set a filename to store the saved links.

To use run 

```ruby
./bin/linkey check URL BASEURL /regex Filename
```
Example

```ruby
./bin/linkey check http://www.live.bbc.co.uk/arabic http://www.live.bbc.co.uk /arabic arabic.md
```
Another

```ruby
/bin/linkey check http://www.theguardian.com/technology/2014/feb/15/year-of-code-needs-reboot-teachers http://theguardian.com /technology news.md
```