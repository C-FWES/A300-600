# Electrical system for A300/A310 by Joshua Davidson (it0uchpods/411).

var ELEC_UPDATE_PERIOD	= 0.5;						# A periodic update in secs
var STD_VOLTS_AC	= 115;						# Typical volts for a power source
var MIN_VOLTS_AC	= 115;						# Typical minimum voltage level for generic equipment
var STD_VOLTS_DC	= 28;						# Typical volts for a power source
var MIN_VOLTS_DC	= 25;						# Typical minimum voltage level for generic equipment
var STD_AMPS		= 0;						# Not used yet
var NUM_ENGINES		= 2;


									# Handy handles for DC source feed indices
var feed	= {	eng1	: 0,
			eng2	: 1,
			apu	: 2,
			batt	: 3,
			cart	: 4,
			rect1	: 5,
			rect2	: 6
		  };
var feed_status	= [0,0,0,0,0,0,0];					# For fast feed switch checking
var RECT_OFFSET = 5;							# Handy rectifier index offset

									# Other property handles:
var engines	= props.globals.getNode("/engines").getChildren("engine");
var sources	= props.globals.getNode("/systems/electrical").getChildren("power-source");
var apu_running	= props.globals.getNode("/systems/apu/running");
var sw_batt	= props.globals.getNode("/controls/switches/battery");
var sw_cart	= props.globals.getNode("/controls/switches/cart");
var cart_wow	= props.globals.getNode("/gear/gear[0]/wow");
var gndspd	= props.globals.getNode("velocities/groundspeed-kt",1);
var sw_gen	= props.globals.getNode("/controls/switches").getChildren("generator");
var test_dc	= props.globals.getNode("/systems/electrical/test-volts-dc");
var test_ac	= props.globals.getNode("/systems/electrical/test-volts-ac");
var bus_dc	= props.globals.getNode("/systems/electrical/bus-dc");
var bus_ac	= props.globals.getNode("/systems/electrical/bus-ac");


  var elec_main_on = func {
        setprop("systems/electrical/on", 1);;
		setprop("systems/electrical/outputs/efis", 25);	
		setprop("systems/electrical/outputs/mk-viii", 28);	
		setprop("engines/engine[0]/egt-degc", (getprop("engines/engine[0]/egt-degf") - 32) / 1.8);
		setprop("engines/engine[1]/egt-degc", (getprop("engines/engine[1]/egt-degf") - 32) / 1.8);
}

var update_electrical = func {
  elec_main_on();
  settimer(update_electrical,ELEC_UPDATE_PERIOD);			# Schedule next run
}


settimer(update_electrical, 2);						# Give a few seconds for vars to initialize