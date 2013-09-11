
# Koding Compiler Plus, The Reckoning

Welcome to what i am thinking of as *kdc-plus*. This project is a fork of the
normal kdc compiler with the purpose of adding features to KDC. The primary
of these features being a way to resolve dependencies for applications in
compile time and runtime.

## What dependencies?

Most KDApps at the time of this writing have no external dependencies. This
is okay for the basic stuff, but this severely limits the potential of the
applications *(in my modest opinion)*.

If you look at any popular language with a healthy community, you see a strong
packaging system behind this community. Allowing them to share libraries
and functionality. I'm not suggesting we build our own packaging system,
i don't see the need. I am suggesting that we create a system by which we
can include these packages as dependencies of our applications.

## So, how will this work?

To understand the implementation, we must understand the constraints that
KDApps put on us.

KDApps when "installed" from the main App List come with two files. This
process is simply a copying of two files, a compiled
JavaScript file, and a Manifest file. Users then run it, and that's it, any
serverside dependencies that we may depend on are not installed. We
have no installation phase for these users. So we need to make our own
installer *included* in this application.

For dependencies that are included *in* the source of the application *(that
JavaScript file)*, we need to include those at the time of compilation. We
will consider these compile-time dependencies. 

### Compile-Time Dependencies

Compile-time dependencies will be resolved by this process, before compiling.
By resolving it before compiling, we can then compile like normal and any
files from any npm/bower/etc libraries can be included in the manifest and
compilation like normal. No failed compilations due to missing npm modules.

### Runtime Dependencies

Runtime dependencies are a bit more complex. Because these can't be baked
with the application *(for multiple reasons)*, we must install them on the
user machine at the time of running the application. This means that we'll
have to inject this installer code into the compiled js file. It will run
in the background of the app launching and in a configurable way, and will
prompt the user informing that the KDApp has VM-side dependencies that
are being installed.

## To Wrap, or Merge

Since the compiler is created, made, and used by Koding primarily, we don't
want to reimplement that. With that said, my efforts will be focused on
working around the compiler. The way i see it, this feature set has two
options. Mering, or Wrapping.

### Merging

Merging is a pretty basic idea, when this is feature complete i'll make a PR
and FKA and I can discuss if this is an insane project hah. If he agrees
with it, this code will be merged back into the "official" kdc.

### Wrap / Brute Force

If he does not like kdc-plus *(not the end of the world)*, we still know that
we need these features. If it is decided that they are above and beyond
what kdc is intended for, we will rename this project and effectively make
this kdc-plus. The intention though, will still be not to replace any
functionality of kdc. With that said, we will have to wrap/inject/hack
into kdc upon installation. Likely by forcefully overwriting the global
kdc installation.

Why the brute force? Well we want to make sure and preserve the user Koding
centric workflow of `create app -> click compile -> view app` as well as
`create app -> open app -> compile during open -> view app`. Since we're
preserving that workflow, we have to use the `kdc` global namespace. Hence
the brute force overwriting.

## Drawbacks

There are a few issues with the above system, and in an effort to identify
shortcomings we will list them here.

- Runtime installations have to check each app run.
  
  For this, we need to recognize that runtime checks need to be in two phases,
  checking if the installation is valid, and installation. The first phase
  will need to be as fast as possible, and **non-blocking**. If we block
  the user app on every app-load, this is a failed system.

- Installation code updates require recompile of hosted applications.
  
  This is actually my biggest problem with this design, but i can't think
  of a workaround. The current alternative, is to bake in **everything**,
  so we're basically trading baking *everything* for a single thing, the
  installer code. It's a huge win, but it's not *perfect*.
