# bordify
Add a 1x1 black border to your screenshot from the command line.

##Setup
Clone `bordify` into your `workspace`, `cd` into it, run `bundle install`, and add an alias to your `bash_profile`. 
```
$ git clone https://github.com/bentarnoff/bordify.git
$ cd bordify
$ bundle install
$ echo "alias bordify='ruby ~/workspace/bordify/bordify.rb'" >> ~/.bash_profile
$ source ~/.bash_profile
```

##Usage

`bordify MY-SCREENSHOT.png`
**By default, Bordify will create a new image called `MY-SCREENSHOT-BORDERED.png`**

`bordify -o MY-SCREENSHOT.png`
**Using the `-o` flag will cause Bordify to overwrite the original image with the new bordered image.**
