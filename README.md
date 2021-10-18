# Libabigail Dev

This will show you how to install a development libabigail alongside spack, and then
run it as an analyzer, optionally with Spack monitor. Note that [this pull request](https://github.com/spack/spack/pull/26807/files)
will need to be merged for this to work (the Dockerfile uses the spack develop branch).
If you want to pull the [base container from Docker Hub](https://hub.docker.com/r/vanessa/libabigail-dev) instead you can do:

```bash
$ docker pull vanessa/libabigail-dev
```

And skip down to [development environment](#development-environment)

### Source code

Since we want to work on libabigail source code locally, you'll first want to clone that
to your present working directory (or CD to where you have it)

```bash
git clone https://sourceware.org/git/libabigail.git
```

### Docker Build

Then you'll want to build the [Dockerfile](Dockerfile). You can also use spack locally,
but this reproduces what I've tested.

```bash
$ docker build -t vanessa/libabigail-dev .
```

### Development Environment

Then you'll want an interactive development environment. you can bind the libabigail directory to somewhere in the container (e.g., `/src`).

```bash
$ docker run -it --rm -v $PWD/libabigail:/src vanessa/libabigail-dev bash
```

You're present working directory will be the spack environment, and your source code will be in `/src`.
If you do the same steps as above, you'll be in the activated environment:

```bash
$ . /opt/spack/share/spack/setup-env.sh
$ spack env activate .
```

At this point you can edit files on your local machine, and since it's bound to /src they will
update in the container too! When you are ready to rebuild, do:

```bash
$ spack install
```

If you need more debug info:

```bash
$ spack --debug install
```

And then you can easily use spack load to add the executables to the path (and use them!)

```bash
$ spack load libabigail
$ which abidw
/opt/spack/opt/spack/linux-ubuntu18.04-skylake/gcc-11.0.1/libabigail-master-hwl7dqya5eoni3266kd5mqhiqlcug5ri/bin/abidw
# abidw -v
abidw: 2.1.0
```

And that's it! This workflow should make it easy to install development versions of libabigail with spack.
