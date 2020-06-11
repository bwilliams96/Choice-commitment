# Choice-commitment

This repository contains the code for running the choice commitment task. To setup, the task parameters section of the code needs to be initialised. There are four parameters that need to be defined. These are described below:

* __*probs*__ - A matrix of length (n,4), where n in the number of conditions in the task. The vector _probs[c,:]_ contains  outcome probabilities for each stimuli in condition _c_. Outcome probabilities should be defined as percentages.  Please note, the vector _probs[:,1]_ should contain the probabilities for stimuli that will be selected as being preferred by participants.
* __*l1*__ - Number of trials before preference question.
* __*l2*__ - Number of trials after preference question.
* __*trueLength*__ - The number of trials over which the expected probablities defined in _probs_ are observed. Please note, _prob[m,n]*trueLength_ should be an integer.
