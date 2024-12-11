global.weatherHandler.lighting_triggered = true;

alarm[0] = irandom_range(600, 1600);

if (global.is_server) {
	var buffer = buffer_create(256, buffer_grow, 1);
	buffer_write(buffer, buffer_u8, 3); // Event type: Lightning Trigger
	buffer_write(buffer, buffer_bool, true); // Notify clients to trigger lightning
	network_broadcast_all(buffer);
	buffer_delete(buffer);

	show_debug_message("Server: Lightning triggered.");
}