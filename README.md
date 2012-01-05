ContextIO - Extract data from email
===================================

## DESCRIPTION

ContextIO is a Ruby wrapper for the [Context.IO][contextio] web service.

Context.IO is the missing email API that makes it easy and fast
to integrate your user's email data in your application.

ContextIO follows the rules of [Semantic Versioning][semver] and uses
[TomDoc][tomdoc] for inline documentation.

[contextio]: http://context.io
[semver]: http://semver.org
[tomdoc]: http://tomdoc.org


## INSTALLATION

The best way to install ContextIO is through Rubygems:

    $ [sudo] gem install context-io

If you're installing from source, you can use [Bundler][bundler] to pick up all
the gems:

    $ bundle install

[bundler]: http://gembundler.org

## USAGE

The ContextIO classes map pretty much one-to-one to the Context.IO API
resources, which you can find [on their documentation site][contextiodocs].

[contextiodocs]: http://context.io/docs/2.0

Contributing
------------

In the spirit of [free software][free-sw], **everyone** is encouraged to help
improve this project.

Here are some ways *you* can contribute:

* by using alpha, beta and prerelease versions
* by reporting bugs
* by suggesting new features
* by writing or editing documentation
* by writing specifications
* by writing code (**no patch is too small**: fix typos, add comments, clean up
  inconsistent whitespace)
* by refactoring code
* by closing [issues][issues]
* by reviewing patches

Submitting an Issue
-------------------

We use the [GitHub issue tracker][issues] to track bugs and features. Before
submitting a bug report or feature request, check to make sure it hasn't
already been submitted. You can indicate support for an existing issue by
writing a comment saying you have the same issue (please include what version
of the gem you are using, as well as what version of ruby). When submitting a
bug report, please include a [gist][gist] that includes a stack trace and any
details that may be necessary to reproduce the bug, including your gem version,
Ruby version and operating system. Ideally, a bug report should include a pull
request with failing specs.

Submitting a Pull Request
-------------------------

1. Fork the project.
2. Create a topic branch.
3. Implement your feature or bug fix.
4. Add documentation for your feature or bug fix.
5. Run `bundle exec rake rdoc`. If your changes are not 100% documented, go
   back to step 4.
6. Add specs for your feature or bug fix.
7. Run `bundle exec rake spec`. If your changes are not 100% covered, go back
   to step 6.
8. Commit your changes. If necessary, merge in upstream and rebase your
   changes. Push your changes.
9. Submit a pull request. Please do not include changes to the gemspec,
   version or history file.

[free-sw]: http://www.gnu.org/philosophy/free-sw.html
[issues]: https://github.com/dvyjones/context-io/issues


Copyright
---------

Copyright (c) 2012 Henrik Hodne. See LICENSE for details.
