function dynDisp(object) {
    /*
    Created by: Brendan Williams

    The function takes one JavaScript object as input
    object[0] provides the identity of the least chosen stimuli
    object[1] provides the identity of the second least chosen stimuli
    object[2] is an (M,N) matrix where each stimulus has its own column. The first
        row in this matrix needs to be the number of times a stimulus has been
        displayed, the second row needs to be the number of times it has been
        chosen. Additional rows in the matrix are optional and can be customised
        depending on needs.
    */

    object[0] = 0;
    object[1] = 0;

    /*
    Randomly chose stimuli for the first trial or when all stimuli have been 
    chosen an equal number of times
    */
    var nchoice = [object[2][0][1], object[2][1][1], object[2][2][1], object[2][3][1]];
    range = Math.max(...nchoice) - Math.min(...nchoice);
    if (range == 0) {
        while (object[0] == object[1]) {
            object[0] = Math.floor(Math.random()*4);
            object[1] = Math.floor(Math.random()*4);
        }
    } 
    else {
        /*
        Find the proportion of trials that each stimuli has been chosen, minus
        the proportion of chosen trials of the stimulus with the largest
        proportion, squared
        */
       var sum = nchoice.reduce(function(total, cv){
           return total + cv;
       }, 0);
       var prob = [(object[2][0][1])/sum, (object[2][1][1])/sum, (object[2][2][1])/sum, (object[2][3][1])/sum];
       var maximum = Math.max(...prob);
       prob = [Math.pow((prob[0])-maximum,2), Math.pow((prob[1])-maximum,2), Math.pow((prob[2])-maximum,2), Math.pow((prob[3])-maximum,2)];
       
       //Find the two least displayed images (these will have the largest and second largest numbers)
       object[0] = prob.indexOf(Math.max(...prob));
       prob[prob.indexOf(Math.max(...prob))] = 0;
       object[1] = prob.indexOf(Math.max(...prob));
    }

    return object
}