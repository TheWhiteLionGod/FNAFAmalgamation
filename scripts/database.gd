extends Node
class_name Database

# --- CONFIGURATION ---
const TABLE_ID = "847170"
var API_TOKEN = GameState.load_env_key("DATABASE_API_TOKEN")
const BASE_URL = "https://api.baserow.io/api/database/rows/table/" + TABLE_ID + "/?user_field_names=true"
const KEYS_LIST: Array = ["Name", "Score"]

var main: Node3D

@warning_ignore("SHaDOWED_VARIABLE")
func _init(main: Node3D) -> void:
	self.main = main

# Helpers
# Response Code 200 - Here is Data (Everything Worked)
# Response Code 204 - No Content (Everything Worked)
func _send_request(url: String, method: int, data: Dictionary = {}) -> Dictionary:
	var http = HTTPRequest.new()
	main.add_child(http)

	var headers = ["Content-Type: application/json", "Authorization: Token " + API_TOKEN]
	var body = JSON.stringify(data) if not data.is_empty() else ""
	
	http.request(url, headers, method, body)
	var response = await http.request_completed
	
	var response_code = response[1]
	var response_body = response[3].get_string_from_utf8() # Get string first
	
	http.queue_free()

	# 1. Check if the body is empty (Standard for DELETE/204)
	if response_body == "":
		return {"code": response_code, "data": {}}

	# 2. Only parse if there is actually text
	var json_data = JSON.parse_string(response_body)
	if json_data == null:
		# If it's not empty but still fails, it's a real parse error
		printerr("❌ JSON Parse Failed: ", response_body)
		return {"code": response_code, "data": {}}

	return {"code": response_code, "data": json_data}

func addData(values: Array) -> Dictionary:
	var data: Dictionary = {}
	for i in KEYS_LIST.size():
		data[KEYS_LIST[i]] = values[i]

	var result = await _send_request(BASE_URL, HTTPClient.METHOD_POST, data)
	if result.code == 201 or result.code == 200:
		return result.data 

	return {}

func getAllRows() -> Array:
	var response = await _send_request(BASE_URL, HTTPClient.METHOD_GET)

	if response.code == 200 and response.data.has("results"):
		return response.data["results"]

	return []

func deleteRow(rowId: int) -> bool:
	var url = "https://api.baserow.io/api/database/rows/table/" + TABLE_ID + "/" + str(rowId) + "/"
	var response = await _send_request(url, HTTPClient.METHOD_DELETE)
	
	return response.code == 204 or response.code == 200
