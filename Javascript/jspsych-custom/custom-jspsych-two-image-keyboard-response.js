/**
 * jspsych-2image-keyboard-response
 * Josh de Leeuw, adapted by Brendan Williams
 *
 * plugin for displaying a stimulus and getting a keyboard response
 *
 * documentation: docs.jspsych.org
 *
 **/


jsPsych.plugins["2image-keyboard-response"] = (function() {

    var plugin = {};
  
    jsPsych.pluginAPI.registerPreload('2image-keyboard-response', 'stimulus', 'image');
  
    plugin.info = {
      name: '2image-keyboard-response',
      description: '',
      parameters: {
        stimulus1: {
          type: jsPsych.plugins.parameterType.IMAGE,
          pretty_name: 'Stimulus1',
          default: undefined,
          description: 'The image to be displayed on the left hand side'
        },
        stimulus2: {
            type: jsPsych.plugins.parameterType.IMAGE,
            pretty_name: 'Stimulus2',
            default: undefined,
            description: 'The image to be displayed on the right hand side'
          },
        showchoice: {
            type: jsPsych.plugins.parameterType.STRING,
            pretty_name: 'Image chosen',
            default: null,
            description: 'The chosen image will be displayed, the others will be transparent'
        },
        choices: {
          type: jsPsych.plugins.parameterType.KEYCODE,
          array: true,
          pretty_name: 'Choices',
          default: jsPsych.ALL_KEYS,
          description: 'The keys the subject is allowed to press to respond to the stimulus.'
        },
        prompt: {
          type: jsPsych.plugins.parameterType.STRING,
          pretty_name: 'Prompt',
          default: null,
          description: 'Any content here will be displayed below the stimulus.'
        },
        stimulus_duration: {
          type: jsPsych.plugins.parameterType.INT,
          pretty_name: 'Stimulus duration',
          default: null,
          description: 'How long to hide the stimulus.'
        },
        trial_duration: {
          type: jsPsych.plugins.parameterType.INT,
          pretty_name: 'Trial duration',
          default: null,
          description: 'How long to show trial before it ends.'
        },
        response_ends_trial: {
          type: jsPsych.plugins.parameterType.BOOL,
          pretty_name: 'Response ends trial',
          default: true,
          description: 'If true, trial will end when subject makes a response.'
        },
      }
    }
  
    plugin.trial = function(display_element, trial) {

      var transparency = {stim1: 1, stim2: 1}

      if (trial.showchoice == "left"){
        transparency.stim2 = 0
      } // center left image chosen
      if (trial.showchoice == "right"){
        transparency.stim1 = 0
      } // center right image chosen

      // display stimulus
      var html = '<div class="row" style="display:flex" width="100%">'
      html += '<div class="column" style="padding:10px"><img src="'+trial.stimulus1+'" id="jspsych-image-keyboard-response-stimulus" style="width: 100%; height: 100%; opacity:0;"></img></div>'
      html += '<div class="column" style="padding:10px"><img src="'+trial.stimulus1+'" id="jspsych-image-keyboard-response-stimulus" style="width: 100%; height: 100%; opacity:'+transparency.stim1+';"></img></div>'
      html += '<div class="column" style="padding:10px"><img src="'+trial.stimulus2+'" id="jspsych-image-keyboard-response-stimulus" style="width: 100%; height: 100%; opacity:'+transparency.stim2+';"></img></div>'
      html += '<div class="column" style="padding:10px"><img src="'+trial.stimulus2+'" id="jspsych-image-keyboard-response-stimulus" style="width: 100%; height: 100%; opacity:0;"></img></div>'
      html +='</div>';
  
      // add prompt
      if (trial.prompt !== null){
        html += trial.prompt;
      }
  
      // render
      display_element.innerHTML = html;
  
      // store response
      var response = {
        rt: null,
        key: null
      };
  
      // function to end trial when it is time
      var end_trial = function() {
  
        // kill any remaining setTimeout handlers
        jsPsych.pluginAPI.clearAllTimeouts();
  
        // kill keyboard listeners
        if (typeof keyboardListener !== 'undefined') {
          jsPsych.pluginAPI.cancelKeyboardResponse(keyboardListener);
        }
  
        // gather the data to store for the trial
        var trial_data = {
          "rt": response.rt,
          "stimulus": trial.stimulus,
          "key_press": response.key
        };
  
        // clear the display
        display_element.innerHTML = '';
  
        // move on to the next trial
        jsPsych.finishTrial(trial_data);
      };
  
      // function to handle responses by the subject
      var after_response = function(info) {
  
        // after a valid response, the stimulus will have the CSS class 'responded'
        // which can be used to provide visual feedback that a response was recorded
        display_element.querySelector('#jspsych-image-keyboard-response-stimulus').className += ' responded';
  
        // only record the first response
        if (response.key == null) {
          response = info;
        }
  
        if (trial.response_ends_trial) {
          end_trial();
        }
      };
  
      // start the response listener
      if (trial.choices != jsPsych.NO_KEYS) {
        var keyboardListener = jsPsych.pluginAPI.getKeyboardResponse({
          callback_function: after_response,
          valid_responses: trial.choices,
          rt_method: 'performance',
          persist: false,
          allow_held_key: false
        });
      }
  
      // hide stimulus if stimulus_duration is set
      if (trial.stimulus_duration !== null) {
        jsPsych.pluginAPI.setTimeout(function() {
          display_element.querySelector('#jspsych-image-keyboard-response-stimulus').style.visibility = 'hidden';
        }, trial.stimulus_duration);
      }
  
      // end trial if trial_duration is set
      if (trial.trial_duration !== null) {
        jsPsych.pluginAPI.setTimeout(function() {
          end_trial();
        }, trial.trial_duration);
      }
  
    };
  
    return plugin;
  })();
  