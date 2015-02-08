perlythingkeeper (formerly Get_A_Thing)
===========

Get things from thingiverse.com via their API.

It was taking me quite some time to download all the images, files and instructions for a given thing from thingiverse.
Originally, I was planning on scraping web pages for the information on each thing I wanted to save, but then
a friend mentioned API and I had one of those Duh! moments.  This project will contain many perl modules, based on Moose,
which will serve as a Perl interface to thingiverse's API: http://www.thingiverse.com/developers/rest-api-reference.

Thingiverse's documentation page http://www.thingiverse.com/developers/libraries lists examples for Ruby PHP but not
Perl and my efforts to find an example did not produce one (though that doesn't mean that one does or didn't exist).

This project is just starting and nearly nothing is yet working.  I will add versioning and claim 1.0 once I have 
methods for users and things that pass testing.

Update, Jan 18, 2015:

Much is working and I've written quite a lot of code.  I am surprisingly organized, and have put many of my thoughts into
Notes and ToDo's.  This project has a lot of potential and it's scope is quite large now.  I have yet to add any logical
versioning and this will likely take a bit more time as I have paused in my coding to learn and implement Dist::Zilla on the
advise of a good friend whose wisdom I value.

The ToDo/ToDo.mkdn is a bit disordered but still manages to list all of the major goals I have for this project, including
good documentation and example scripts, which I will begin shortly.  I would also like to implement a Caching mechanism and
methods for Thingiverse's new groups (actually this is largely done, and will likely remain in it's present state until the
API actually supports this new, experimental? feature).

Finally, this project will concentrate on a ReadOnly interface and ignore, Create, Update and Delete portions of CRUD.
These aspects all change the data stored at Thingiverse, which is outside of my original motiviation for beginning this
project.  I will also need to read the API terms of service again and carefully before I plunge into this phase of the project.

BUILD STEPS
===========

Assuming ubuntu at the moment because that's what I'm using.  This documentation should probably use cpan to get cpanm.

```
sudo apt-get install cpanminus build-essential libdist-zilla-perl
dzil authordeps --missing | sudo cpanm # sudo optional for non-lazy folks
dzil build
```

RUNNING TESTS
=============

```
sudo apt-get install libssl-dev
dzil listdeps | sudo cpanm
```
