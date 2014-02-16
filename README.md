linky
=====

Link checker for BBC News/WS Sites

The idea is to quickly check a page for broken links by doing a status check on all the relative URL's on the page.  Set a URL, then set the point at which you want to strip out unwanted URLs, then set a filename to store the saved links.

To use run 

```ruby
./bin/linky check URL /regex Filename
```
Example

```ruby
./bin/linky check http://www.live.bbc.co.uk/arabic /arabic arabic.md
```