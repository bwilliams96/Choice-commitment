function dynDisp(object) {
    /*
    Created by: Brendan Williams

    The function takes one JavaScript object as input
    object[0] provides the identity of either the least, or second least chosen stimuli
    object[1] provides the identity of either the least, or second least chosen stimuli
    object[2] is an (M,N) matrix where each stimulus has its own column. The first
        row in this matrix needs to be the number of times a stimulus has been
        displayed, the second row needs to be the number of times it has been
        chosen. Additional rows in the matrix are optional and can be customised
        depending on needs.
    */

   function shuffle(array) {
    for (let i = array.length - 1; i > 0; i--) {
        let j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
        }
    }

    object[0] = 0;
    object[1] = 0;

    /*
    Randomly choose stimuli for the first trial or when all stimuli have been 
    chosen an equal number of times
    */
    var nchoice = [object[2][0][1], object[2][1][1], object[2][2][1], object[2][3][1]];
    var range = Math.max(...nchoice) - Math.min(...nchoice);
    if (range == 0) {
        while (object[0] == object[1]) {
            object[0] = Math.floor(Math.random()*4);
            object[1] = Math.floor(Math.random()*4);
        }
    } 
    else {
        /*
        Find the proportion of trials that each stimuli has been chosen, minus
        the proportion of trials for the stimulus with the largest
        proportion, and square
        */
       var sum = nchoice.reduce(function(total, cv){
           return total + cv;
       }, 0);
       var prob = [(object[2][0][1])/sum, (object[2][1][1])/sum, (object[2][2][1])/sum, (object[2][3][1])/sum];
       var maximum = Math.max(...prob);
       prob = [Math.pow((prob[0])-maximum,2), Math.pow((prob[1])-maximum,2), Math.pow((prob[2])-maximum,2), Math.pow((prob[3])-maximum,2)];
       
       //Find the two least selected images (these will have the largest and second largest numbers)
       var least = prob.indexOf(Math.max(...prob));
       prob[prob.indexOf(Math.max(...prob))] = 0;
       var newleast prob.indexOf(Math.max(...prob));
       var stim = least.concat(newleast);
       shuffle(stim);
       object[0] = stim[0];
       object[1] = stim[1];
    }

    return object
};

function leastShow(object) {
    /*
    Created by: Brendan Williams

    The function takes one JavaScript object as input
    object[0] provides the identity of either the least, or second least displayed stimuli
    object[1] provides the identity of either the least, or second least displayed stimuli
    object[2] is an (M,N) matrix where each stimulus has its own column. The first
        row in this matrix needs to be the number of times a stimulus has been
        displayed, the second row needs to be the number of times it has been
        chosen. Additional rows in the matrix are optional and can be customised
        depending on needs.
    */

   function shuffle(array) {
    for (let i = array.length - 1; i > 0; i--) {
        let j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
        }
    }

    object[0] = 0;
    object[1] = 0;

    /*
    Randomly choose stimuli for the first trial or when all stimuli have been 
    displayed an equal number of times
    */
    var nshow = [object[2][0][0], object[2][1][0], object[2][2][0], object[2][3][0]];
    var range = Math.max(...nshow) - Math.min(...nshow);
    if (range == 0) {
        while (object[0] == object[1]) {
            object[0] = Math.floor(Math.random()*4);
            object[1] = Math.floor(Math.random()*4);
        }
    } 
    else {
        /*
        Find the proportion of trials that each stimuli has been displayed, minus
        the proportion of trials for the stimulus with the largest
        proportion, and square
        */
       var sum = nshow.reduce(function(total, cv){
           return total + cv;
       }, 0);
       var prop = [(object[2][0][0])/sum, (object[2][1][0])/sum, (object[2][2][0])/sum, (object[2][3][0])/sum];
       var maximum = Math.max(...prop);
       prop = [Math.pow((prop[0])-maximum,2), Math.pow((prop[1])-maximum,2), Math.pow((prop[2])-maximum,2), Math.pow((prop[3])-maximum,2)];
       
       //Find the two least displayed images (these will have the largest and second largest numbers)
       var least = prop.indexOf(Math.max(...prop));
       prop[prop.indexOf(Math.max(...prop))] = 0;
       var newleast prop.indexOf(Math.max(...prop));
       var stim = least.concat(newleast);
       shuffle(stim);
       object[0] = stim[0];
       object[1] = stim[1];
    }

    return object
};

function makeMatrix(l1, l2, prob, trueLength) {
    /*

    Created by: Brendan Williams

    PLEASE NOTE!!!
    OBSERVED PROBABILITIES WILL NOT RELIABLY MATCH WITH EXPECTED PROBABILITIES
    IF prob*trueLength OR prob*(1-trueLength) ARE NOT INTEGERS DUE TO ROUNDING.

    Function requires 4 inputs:
    l1 = number of trials before choice commitment question
    l2 = number of trials after choice commitment
    prob = probability of winning for each option after choice commitment
    trueLength = number of trials over which expected probabilities are observed.

    The function has 1 output:
    output[0] = binary matrix of outcomes before choice commitment with 
    (l1,length(prob)) dimensions. 0 represents a loss and 1 represents a win.

    output[1] = binary matrix of outcomes after choice commitment with 
    (l1,length(prob)) dimensions. 0 represents a loss and 1 represents a win.

    */

    function shuffle(array) {
        for (let i = array.length - 1; i > 0; i--) {
            let j = Math.floor(Math.random() * (i + 1));
            [array[i], array[j]] = [array[j], array[i]];
        }
    }

   var l1tL = Math.ceil(l1 / trueLength);
   var l2tL = Math.ceil(l2 / trueLength);

   var output = [];
   output[0] = [[], [], [], []];
   output[1] = [[], [], [], []];

   for (let i = 0; i < l1tL; i++) {
       var temp = [[], [], [], []];
       for (let ii = 0; ii < prob.length; ii++) {
           var z = Array(Math.ceil(trueLength / 2)).fill(0);
           var o = Array(Math.ceil(trueLength / 2)).fill(1);
           var zo = z.concat(o);
           shuffle(zo);
           output[0][ii] = output[0][ii].concat(zo);
        }
   }

   for (let i = 0; i < l2tL; i++) {
    var temp = [[], [], [], []];
    for (let ii = 0; ii < prob.length; ii++) {
        var probability = prob[ii] / 100;
        var z = Array(Math.floor(trueLength * (1-probability))).fill(0);
        var o = Array(Math.ceil(trueLength * probability)).fill(1);
        var zo = z.concat(o);
        shuffle(zo);
        output[1][ii] = output[1][ii].concat(zo);
        }
    }

    return output
};