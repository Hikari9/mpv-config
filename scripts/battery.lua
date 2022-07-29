-- If the laptop is on battery, the profile 'lq' will be loaded; otherwise 'hq' is used
--
local lqprofile = "battery"
local hqprofile = "plugged"

local function powerstate()
    local f = io.popen("/usr/bin/pmset -g batt | head -n 1 | cut -d \\' -f2", 'r')
    if f == nil then return end
    local t = f:read("*a")
    local s = t:gsub("\n[^\n]*$", "")
    mp.msg.info(s)
    f:close()
    return s
end

local function adjust()
    local state = powerstate()
    -- this actually overrides automatically applied profiles
    -- like 'protocol.http'
    if state == 'Battery Power' then
        mp.msg.info("Running on battery, setting low-quality options.")
        mp.set_property("profile", lqprofile)
    else
        mp.msg.info("Not running on battery, setting high-quality options.")
        mp.set_property("profile", hqprofile)
    end
end
mp.add_hook("on_load", 1, adjust)
