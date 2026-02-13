-- Enable the new experimental command-line features.
_G.Config.now(function()
    require("vim._core.ui2").enable({
        msg = {
            ---@type 'cmd'|'msg' Where to place regular messages, either in the
            ---cmdline or in a separate ephemeral message window.
            target = "cmd",
            -- Time a message is visible in the message window.
            timeout = 2000,
        },
    })
end)
