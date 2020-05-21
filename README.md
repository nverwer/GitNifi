If you read this, you probably know what Git is, and what Nifi is.
As the name implies, this project uses Git and [Apache Nifi](https://nifi.apache.org/).

# Why? #

When working with development teams on large Nifi flows, my experience was, that it is difficult to
have different people work on sub-flows and then merge their work into one flow.
This becomes more difficult if work is going on in several Git branches.

Nifi does have some facilities for flow versioning and merging.
Nifi Registry is great for versioning complete flows and deploying flows on different Nifi installations.
However, it works with complete flows or process groups, and does not support branching and merging.
It also does not provide a way to view the history of a flow or process group, like Git does.
Another possibility is to export top-level process groups as templates,
and keep the XML representations of these templates in Git.
Unfortunately, this does not work well for nested process groups or templates,
and it loses the connections between process groups.

The aim of GitNifi is to store process groups as XML files;
to handle nested process groups separately;
to use all the features of Git, like versioning, branching and merging.
GitNifi is not yet as user-friendly as I would hope, and contributions are welcome.
I hope that one day, GitNifi will become superfluous, and that a better integration of Nifi and Git
will be available.

# Usage #

GitNifi uses Nifi itself to turn a Nifi flow into source files, and to 'compile' these
source files into a flow.
GitNifi consists of two Nifi processing groups, one to split a Nifi flow into 'flow-maps',
and one to merge these flow-maps into one Nifi flow definition.

## Variables ##

GitNifi runs within Nifi itself.
All dependencies on the environment are passed in the following variables:

* `${gitnifi}` : The location of the split Nifi `...flow-map.xml` files and the generated `flow.xml.gz`.
  This is a directory that contains source code, and should be part of your Git repository.
* `${resources}` : The location of a directory containing a `gitnifi` sub-directory,
  which contains the GitNifi XSLT stylesheets and the GitNifi template.

I prefer to have different sets of global variables in properties-files, and to use the
`nifi.variable.registry.properties=...` setting in `conf/nifi.properties`.

## Installing ##

Make sure that the XSLT file of GitNifi are in the `${resources}/gitnifi` directory.

To install GitNifi into an existing flow, import and instantiate the GitNifi.xml template.

## Splitting a Nifi flow into flow-maps ##

To generate separate XML files for the Nifi flow, empty the `${gitnifi}` directory.
(You only need to remove those parts that will not be overwritten in the next step.)

Then copy the `flow.xml.gz` from a (running) Nifi installation into the `${gitnifi}` directory.
The copied `flow.xml.gz` will be deleted, so it will not end up in your Git repository.

Start the processing group called 'Split Nifi flow into flow-map files'.
This will result in a number of `...flow-map.xml` files in the `${gitnifi}` directory.
These files can be committed to your Git repository, and can be used to re-generate `flow.xml.gz`.

Stop the processing group 'Split Nifi flow into flow-map files', or it will continue to execute.

## Joining flow-maps into a Nifi flow ##

To generate a Nifi flow from `...flow-map.xml` files in the `${gitnifi}` directory, Nifi must be running.
Start the processing group called 'Merge flow-map files into Nifi flow'.

This will generate a new `flow.xml.gz` in the `${gitnifi}` directory.
Stop the processing group 'Merge flow-map files into Nifi flow'.

Stop Nifi, and copy the generated `flow.xml.gz` into the `conf` directory of your Nifi installation.
This will overwrite your existing `flow.xml.gz`, which you should copy to a backup location,
in case GitNifi does not work as expected.

Start Nifi again, and you will see the flow that was generated.

# Remarks #

I have tested GitNifi on several flows, doing a round-trip from `flow.xml.gz` to separate flow-map files,
and back to `flow.xml.gz`.
The only thing that changed was the processor status (running or stopped) of the GitNifi processing groups.
I have also used GitNifi to store and retrieve Nifi flows with a small team.
Nevertheless, you should not trust GitNifi to generate correct flows.
Fortunately, Nifi keeps a history of flows in `conf/archive`, so you can always go back to an earlier flow version.

The term 'flow-map' is used, because in an earlier stage, my intention was to make something similar
to sitemaps in Apache Cocoon.
A flow-map would have associated resources, which would be easily accessible from a process group.

