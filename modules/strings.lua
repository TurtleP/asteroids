local strings =
{
    ["name"]       = "Name",
    ["score"]      = "Score",
    ["no_data"]    = "Could not access scores.",
    ["play"]       = "Play",
    ["highscores"] = "Highscores"
}

function STRING(name)
    return strings[name]
end
