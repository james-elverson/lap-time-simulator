function track = track_model(trackCfg)

switch lower(trackCfg.type)
    case "triangle_track"
        track = triangle_track(trackCfg);
    otherwise
        error("Unknown track type");
end

