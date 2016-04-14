#r2u

A tool to convert URIs to Docs repo names, and vice versa.

###Setup

```
$ git clone https://github.com/bentarnoff/r2u.git
$ cd r2u
$ bundle install
```

r2u pulls the info about the repos and URIs from the config YAMLs of the book repos. Make sure that `docs-book-cloudfoundry`, `docs-book-pivotalcf`, and `docs-book-runpivotal` are all in your `workspace` directory.

###Usage
`$ ruby r2u.rb [URI or repo name]`  

**Converts a URI to a repo name, and vice versa**

`$ ruby r2u.rb --all`  

**Prints the whole hash**

###Example
```
$ ruby r2u.rb docs-services
The URIs for docs-services are:
http://docs.pivotal.io/pivotalcf/services/
http://docs.run.pivotal.io/services/
http://docs.cloudfoundry.org/services/
```

###Add it to your bash_profile

```
$ echo "alias r2u='ruby ~/workspace/r2u/r2u.rb'" >> ~/.bash_profile
```

Now you can run it with:

```
$ r2u
```
