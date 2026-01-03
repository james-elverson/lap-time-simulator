function track = load_track(trackName)
% load_track  Load a saved track struct from the tracks/ folder
%
% Usage:
%   track = load_track("silverstone");
%
% This loads:
%   tracks/silverstone_track.mat
%
% The .mat file must contain a variable named 'track'.

if nargin < 1
    error("You must provide a track name, e.g. load_track('silverstone').");
end

filename = fullfile("tracks", trackName + "_track.mat");

if ~isfile(filename)
    error("Track file '%s' not found.", filename);
end

data = load(filename, "track");

if ~isfield(data, "track")
    error("File '%s' does not contain a variable named 'track'.", filename);
end

track = data.track;
end
