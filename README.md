Comparison of Crystallographic Information File format v1.1 and v2.0 parsers
============================================================================

Various parsers for Crystallographic Information File (CIF) format v1.1 and v2.0 are compared as continuation of research published in [Merkys et al. 2016](http://scripts.iucr.org/cgi-bin/paper?po5052).
Original purpose of this research is to find out the differences in reactions of various CIF parsers while parsing curious cases of both valid and erroneous CIF files.

Tested CIF v1.1 parsers
-----------------------

* [Atomic Simulation Environment (ASE)](http://wiki.fysik.dtu.dk/ase)
* [cif2cif](https://doi.org/10.1107/S0021889896006371)
* [CIFXOM](https://journals.iucr.org/j/issues/2011/03/00/he5526/index.html)
* [ciftools-java](https://github.com/rcsb/ciftools-java)
* [CIF API](https://github.com/COMCIFS/cif_api)
* [COD::CIF::Parser of cod-tools](http://wiki.crystallography.net/cod-tools/)
* [crystcif-parse](https://github.com/stur86/crystcif-parse)
* [gemmi](https://github.com/project-gemmi/gemmi.git)
* [OpenBabel](https://github.com/openbabel/openbabel)
* [PyCIFRW](https://bitbucket.org/jamesrhester/pycifrw/)
* [pymatgen](https://pymatgen.org)
* [STAR::Parser](http://pdb.sdsc.edu/STAR/index.html)
* [vcif](http://www.iucr.org/resources/cif/software/archived/vcif-1.2)
* [ZINC](http://www.iucr.org/__data/iucr/cif/software/zinc/doc/zinc-paper.pdf)

Parsers to be tested:

* [Jmol](https://jmol.sourceforge.net)
* [mmCIF parser](https://github.com/gjbekker/cif-parsers)

Tested CIF v2.0 parsers
-----------------------

* [CIF API](https://github.com/COMCIFS/cif_api)
* [COD::CIF::Parser of cod-tools](http://wiki.crystallography.net/cod-tools/)
* [PyCIFRW](https://bitbucket.org/jamesrhester/pycifrw/)

Formely tested parsers
----------------------

* [StarTools](https://www.globalphasing.com/startools/) - Python 2 only
* [ucif](https://doi.org/10.1107/S0021889811041161) - source no longer available
* [vcif2](http://www.iucr.org/resources/cif/software/archived/vcif-1.2) - fails to build

Structure
---------

Drivers for parsers are located at [1.1/drivers/](1.1/drivers/) and [2.0/drivers/](2.0/drivers/).
Tests are located at [1.1/tests/](1.1/tests/) and [2.0/tests/](2.0/tests/).
Tables with the results are located in relative ``outputs/table.tex`` and ``outputs/table.html`` files.
Versions are listed in [versions.tab](versions.tab).

Comparing a local Ada parser
----------------------------

The ``compare-ada`` target evaluates a locally built
[Ada CIF parser](https://github.com/jarekrzdbk/ada_cif_parser) on both test
corpora and adds its classifications to the parser results recorded in this
repository:

```sh
make compare-ada \
    ADA_CIF_PARSER=/absolute/path/to/bin/cif_parse \
    ADA_RESULTS_DIR=/absolute/path/to/results
```

This target does not use Apptainer and does not install or rerun the other
parsers. Their columns come from the checked-in outputs and correspond to the
versions in [versions.tab](versions.tab). The target uses the existing cases,
driver result protocol, and table generators, but works in a temporary tree so
the checked-in outputs remain unchanged. It creates CIF 1.1 and CIF 2.0 tables
under ``ADA_RESULTS_DIR`` in Markdown, HTML, LaTeX, and TSV formats.

Reporting and Contribution
--------------------------

Bug reports and contributions are welcome.
