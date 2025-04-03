extends Node


const MAX_REWIND : int = 60 # physics frames

var trackers : Array[Tracker] = []

func rewind_by(amount : float, preview : bool):
	if amount == 0:
		return
	var frame_count : int = roundi(lerp(0, get_record_size(), amount))
	for t in trackers:
		t.rewind(frame_count, preview)

func get_record_size() -> int:
	return trackers[0].transform_record.size()
