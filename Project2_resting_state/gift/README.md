# Use GIFT ICA for resting state analysis of ADI

Use a g6 compute server `getserver -sL -g6`

### Prerequisites:

Nifti-input needs to be unzipped (see `prepare_files_for_gift.sh`)

### Settings for the Analysis

The longitudinal design is taken care of in the statistical analysis [here](https://sourceforge.net/p/icatb/mailman/message/36736151/)

As Vince Calhoun and his group advocate minimal preprocessing prior to GIFT [here](https://sourceforge.net/p/icatb/mailman/message/34483940/) and [here](https://sourceforge.net/p/icatb/mailman/message/31466068/) and [here](https://sourceforge.net/p/icatb/mailman/message/35714727/). So no nuisance regression or further data cleaning.

Regarding intensity normalization:the rest2anat data are not normalized, thus setting the options to intensity normalization and no scaling are used to obtain change in data units/percent signal change [here](https://sourceforge.net/p/icatb/mailman/message/35901562/).

### Run analysis:

Load and open GUI `MATLAB --version 9.7 matlab`

Add ICATB toolbox to path `addpath(genpath('/data/pt_02161/Analysis/Project2_resting_state/gift/GroupICATv4.0b'))`

Modify input_File `Test_analysis_1.m` for your analysis.

Run `icatb_batch_file_run(inputFile)`
