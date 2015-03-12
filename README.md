# Touchscreen-data-processing-scripts

These are two main scripts used to analyze differentially rewarded associative learning tasks using the Bussey-Saksida animal touchscreen platorm.

###First script is the VMCL (Visuomotor Conditional Learning) script: VMCLTraining.R
Input = one csv file with the raw data of all subjects ran in touchscreen experiments each day. 

  Each column are variables wanting to be extracted into a separate csv for plotting. 
  
Output = multiple csv files, each file represents one variable and its trend for each subject over days of training.

Note: scripts very inflexible: Need to manually specify number of animals trained, and how many days trained.

###Second script is the probe test script to tabulate decision making results under uncertainty
Input = 5 csv files for 5 variables: ambiguous stimuli presented, non-ambiguous stimuli, and action latencies.

Output: 2 csv files, one for summarized data for each animal and the 5 variables, the other one is frequency of decisions
