# MD5 colliding executables

Generates executables from files found under `programs/` directory with same MD5 hash values. Uses [_Marc Stevens_](http://www.win.tue.nl/hashclash/)'s `fastcoll` program to generate colliding files.

## Dependencies
* boost (tested with 1.69.0)

## Usage
1) Build `fastcoll` executable:
```sh
# Downloads, extracts, patches and compiles fastcoll in one step.
# Patching is needed for newer boost libraries.
make fastcoll
```

2) Generate colliding executables:
```sh
make generate # default target
```

3) Validate results:
```sh
make show
```

### Example output
```text
md5sum bin/program-1 bin/program-2 bin/program-0
8bd5dcb93e855084fcd1a8dab222a7d2  bin/program-1
8bd5dcb93e855084fcd1a8dab222a7d2  bin/program-2
8bd5dcb93e855084fcd1a8dab222a7d2  bin/program-0
./bin/program-2:
IT security is the most interesting course.
./bin/program-1:
IT security is the best course in the faculty.
./bin/program-0:
IT security has the best students.
```

