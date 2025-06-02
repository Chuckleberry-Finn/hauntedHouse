stats = {
	sanity: 5,
	smarts: 5,
	strength: 5,
	speed: 5
};

min_stat = 0;
max_stat = 10;


function adjust_stat(_name, _amount) {
    if (stats[_name] != undefined) {
        stats[_name] = clamp(stats[_name] + _amount, min_stat, max_stat);
    } else {
        show_debug_message("Unknown stat: " + string(_name));
    }
};