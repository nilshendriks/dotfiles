hs.alert.show("utils loaded...")

local U = {}
local webview = nil

function U.closeHUD()
    if webview then
        webview:delete()
        webview = nil
    end
end
function U.showKeybindingsGUI()
    local html = [[
    <html>
        <head>
            <meta charset="UTF-8">
            <title>Keybindings</title>
            <style>
                body {
                    background-color: rgba(0, 0, 0, 0.8);
                    color: white;
                }
                h2 {
                    margin-top: 0;
                    color: blue;
                }
                p {
                    font-size: 16px;
                }
                b {
                    font-weight: bold;
                }
            </style>
        </head>
        <body style="font-family: -apple-system; padding: 20px;">
            <h2>Keybindings</h2>
            <p><b>Hyper + H</b> – Focus window left</p>
            <p><b>Hyper + J</b> – Focus window down</p>
            <p><b>Hyper + K</b> – Focus window up</p>
            <p><b>Hyper + L</b> – Focus window right</p>
            <p><b>HyperShift + A</b> – Open ChatGPT</p>
        </body>
    </html>
    ]]

    if webview then
        webview:delete()
    end

    webview = hs
        .webview
        .new({ x = 300, y = 200, w = 600, h = 500 })
        :html(html)
        :transparent(true) -- make background transparent
        :allowGestures(true) -- optional: allow scrolling/gestures
        :closeOnEscape(true)
        :windowStyle({ "titled", "closable" })
        :show()
        :bringToFront(true)
end

return U
