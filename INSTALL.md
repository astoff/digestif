Installation guide
==================

This installation guide focuses on packaging for redistribution.  For
the final user, it is recommended to install via LuaRocks or using the
self-installing script; see the [README](README.md) for details.

Digestif has the following dependencies:

* Lua version 5.3 or 5.4
* LPeg (https://luarocks.org/modules/gvvaughan/lpeg)
* LuaFileSystem (https://luarocks.org/modules/hisham/luafilesystem)
* cjson (optional, https://luarocks.org/modules/openresty/lua-cjson)
* LuaZip (optional, https://luarocks.org/modules/mpeterv/luazip)

If the cjson library is missing, Digestif uses its own LPeg-based JSON
serializer, which is slower but adequate.  LuaZip is required only
when placing the data files in a zip archive.

All shell commands and file name references assume that the directory
containing this file is the current directory.

Standard packaging
------------------

For a regular installation of Digestif into, say, `PREFIX=/usr`, copy
the files as follows:

    install -Dt $PREFIX/bin bin/digestif
    install -Dt $PREFIX/share/lua/$LUA_VERSION digestif
    install -Dt $PREFIX/share/digestif data/*.tags

Before doing so, however, consider the following:

1. In order for the tags files to be found, add the following at the
   top of the `bin/digestif` script:

        require "digestif.config".data_dirs = {"$PREFIX/share/digestif"}

2. Make sure the `package.path` Lua variable includes the directory
   into which the `digestif` directory is installed.

3. It is recommended that the `package.path` and `package.cpath` Lua
   variables do not include the default relative entries such as
   `./?.lua`.  This is especially important if any of the optional
   dependencies are not installed.

4. If LuaZip is available, the tags files may also be placed in a zip
   file:

        zip -j data.zip data/*.tags
        install -Dt $PREFIX/share/digestif data.zip

   In this case, add the following line at the top of `bin/digestif`:

        require "digestif.config".data_dirs = {"$PREFIX/share/digestif/data.zip"}

Packaging for a TeX distribution
--------------------------------

For an installation depending only on the `texlua` interpreter from
LuaTeX (which bundles all dependencies except the optional cjson),
create a zip file containing `digestif/*.lua` and `data/*.tags` (no
subdirectories), place it anywhere kpathsearch will find it and use
the `bin/digestif.texlua` executable script.  For instance:

    zip -j digestif.zip digestif/*.lua data/*.tags
    install -Dt $TEXMF/scripts digestif.zip
    install bin/digestif.texlua $PREFIX/bin/digestif

Unbundled installation
----------------------

To install Digestif on a directory of its own, say
`PREFIX=/opt/digestif`, copy the `bin`, `data` and `digestif` folders
and add a symlink of the executable script somewhere in the `PATH`.
For instance:

    install -Dt $PREFIX bin data digestif
    ln -s $PREFIX/bin/digestif /opt/bin/digestif
