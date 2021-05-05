The goal for this collection of scripts are to supply the 
tools to validate http/https links within MAPBU documents:
 - test a single link
 - test a collection of links
 - detect and report links within a file
  - detect and report links within all files in a folder
 - detect and report links within a web page
  - detect and report links within a web site


Requirements and Priorities

##What is this thing?
A: A bad link detector


##How/Where should it be used
point to a whole guide
Provide output
List of bad links
Can I run this right before release? Response should be fast enough to be a validation tool at release time.
Point to a book. Just list of bad links. I want it fast.


##What should it detect

1. **Check for links to other versions and non-relative links**
The current checker checks internal links. 
We should avoid duplicating that. Ignore internal links and check external only?

1. Want it to process redirects
1. It should try to ignore the header and footer. Only content within body



##What is the expected way to communicate

1. A list consisting of only bad links.



## Questions:
* Can https also be tested without basic auth
* Do we want to test subnav links
* Does it test/return errors for anchors
* Is it more flakey than the current link checker. Does it return false errors?
* Ignore list
* Don't check twice


![Competitive Analysis](/images/competitive-analysis.png)