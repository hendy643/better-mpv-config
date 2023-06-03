TIME_SHIFT = 7.0
sub_end_time = nil


function time_change(event)
  if event["name"]  == "time-pos" and sub_end_time ~= nil then
    time_now = mp.get_property_number("time-pos")
    if time_now > sub_end_time then
      mp.unobserve_property("time-pos")
      mp.set_property("sub-visibility", "no")
      sub_end_time = nil
      mp.unregister_event(time_change)
    end
  end
end

function replay_previous_seconds(flag)
  mp.commandv("seek", -TIME_SHIFT, "relative+exact")

  if flag ~= true then return end

  mp.set_property("sub-visibility", "yes")
  if sub_end_time == nil then
    sub_end_time = mp.get_property_number("time-pos")
    mp.observe_property("time-pos")
    mp.register_event("property-change", time_change)
  end
end

function replay_previous_seconds_with_subtitles()
  replay_previous_seconds(true)
end

function init()
    mp.add_key_binding("a", "replay-previous-sentence", replay_previous_seconds)
    mp.add_key_binding("s", "replay-previous-sentence-with-subtitles", replay_previous_seconds_with_subtitles)
end

mp.register_event("file-loaded", init)