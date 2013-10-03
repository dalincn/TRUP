TRUP is a pipeline designed for analyzing RNA-seq data from Tumor samples..


Learn More
---
Cancer cells express many rearranged transcripts posing increased complexity to transcriptome analysis. As an unified pipeline, TRUP is designed to sensitively and accurately dissect the complexity of the cancer transcriptome by analyzing RNA-seq data obtained from tumour tissues. The current functionalities of TRUP include: 1) identification of fusion transcripts; 2) Gene and isoform expression quantification and 3) Differential Expression analysis.


Dependencies
---
+   Samtools.
+   Bowtie2.
+   GSNAP (version > 2012-07-20).
+   Velvet (https://github.com/dzerbino/velvet).
+   Oases (https://github.com/dzerbino/oases).
+   R libraries: feilds, KernSmooth, lattice, RColorBrewer and R2HTML.
+   Bioconductor packages: DESeq2, edgeR.

Annotation files
---
Annotation files are available upon request. Currently hg19 and mm10 are available. 

Installation
---
No installation is required if pre-compiled binaries in bin/ are compatible with your system.

If pre-compiled binaries are incompatible with your system, you will need to rebuild them from source.

Make sure you have installed Bamtools (https://github.com/pezmaster31/bamtools). Then write down the bamtools_directory where ./lib/ and ./include/ sub-directories are located. Currently bamtools 2.0 has been tested.

run make in following way to install

	$ make BAMTOOLS_ROOT=/bamtools_directory/

The binaries will be built at bin/. Any existing files will be overwritten.


Usage
---

TRUP can be run with UNIX command-line interface.

Assuming that in the directory "RP" there are two gzipped fastq-files are called as SAMPLE_R?1(_XXX)?.fq.gz and SAMPLE_R?2(_XXX)?.fq.gz (where "\_R?1" and "\_R?2" means mate 1 and mate 2 reads, XXX means a run ID, R and _XXX are optional that can be missing), the path to the directory of the pipeline is called "PD" and the path to tha annotation files are called "AD", one can run the pipeline in the following way:

**Run-level 1** (Quality check, mapping of spiked-in read pairs and give a rough estimate of the insert size etc.):

	$ perl RTrace.pl --runlevel 1 --sampleName SAMPLE --readpool RP --root PD --threads TH --anno AD 2>>run.log 

where "TH" is the number of computing threads. If one wants to stop after the quality check, add ``--QC`` in the command call.

**Run-level 2** (mapping with gsnap [default] or tophat 1/2, generating reports):

	$ perl RTrace.pl --runlevel 2 --sampleName SAMPLE --readpool RP --$root PD --anno AD --threads TH --WIG --patient ID --tissue type --threads TH --gf pdf 2>>run.log

where ``--WIG`` is set to generate bigWiggle file for visualization purpose. ``--patient`` and ``--tissue`` can be set if user need to run edgeR and cuffdiff after processing all the samples. If a X11 is not always available, set ``--gf`` to be ``pdf`` to generate the report figures in pdf format instead of png. However, if X11 is available, do not set the --gf option.

**Run-level 3** (collect regions containning potential breakpoints from the mapping of gsnap, perform regional assembly in the candidate regions):

	$ perl RTrace.pl --runlevel 3 --sampleName SAMPLE --readpool RP --root PD --anno AD --threads TH --RA 1 2>>run.log

where ``--RA`` is set to 1 to indicate an independent regional assembly around each breakpoint.

**Run-level 4** (Dectecting fusion events using the assembled transcripts):

	$ perl RTrace.pl --runlevel 4 --sampleName SAMPLE --readpool RP --root PD --anno AD --threads TH 2>>run.log

If user could not use BLAT, ``--BT`` should be set to use GMAP in this step.

**Run-level 5** (run cufflinks for gene/isoform quantification):

	$ perl RTrace.pl --runlevel 5 --sampleName SAMPLE --readpool RP --root PD --anno AD --threads TH --gtf-guide --known-trans refseq 2>>run.log

where ``--known-trans`` can be set to 'ensembl' or 'refseq' to indicate the annotation to be used for cufflinks.

**Run-level 6** (run cuffdiff for diffrential gene/isoform expression analysis):

	$ perl RTrace.pl --runlevel 6 --root PD --anno AD --threads TH 2>>run.log

**Run-level 7** (run edgeR for diffrential gene expression analysis):

	$ perl RTrace.pl --runlevel 7 --root PD --anno AD --threads TH --priordf 5 --spaired 1 2>>run.log

where ``--priordf`` sets the prior.df parameter in edgeR. ``--spaired`` should be set to 1 if the samples are paired (paired normal-diese samples from the sample patient).

Note: do not set ``--lanename`` for runlevel 6 and 7, as these two runlevels are dealing with multiple samples. 

The Run-levels metioned above can also be combined in the same command line, as following,

	$ perl RTrace.pl --runlevel 1-4 --sampleName SAMPLE --readpool RP --root PD --anno AD --threads TH --WIG --patient ID --tissue type --gf pdf --RA 1 2>>run.log

One can also call combinations of different Run-levels, such as ``--$runlevel 1,2`` or ``--runlevel 2,3,4``. But in these combined ways, one should specify all necessary options in the command line.

Runlevel dependencies (->): 4->3->2->1, 6->5->2->1, 7->2->1

Options
---
check the options by running the program without options or with ``--help``.


Contact
---
Sun Ruping

Current Affiliation:
Califano Lab, Department of Systems Biology, Columbia University, New York, NY, USA

Previous Affiliation:
Dept. Vingron (Computational Molecular Biology)
Max Planck Institute for Molecular Genetics. Ihnestr. 63-73, D-14195 Berlin, Germany

Email: rs3412@columbia.edu

Project Website: https://github.com/ruping/TRUP
