if (async_load[? "id"] == request_id_ip) {
    if (async_load[? "result"] != "") {
        local_ip = async_load[? "result"];
        status_message = "";
    } else {
        local_ip = "N/A";
        status_message = "Failed to fetch public IP.";
    }
}