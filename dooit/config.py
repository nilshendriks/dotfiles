from dooit.api.theme import DooitThemeBase
from dooit.ui.api import DooitAPI, subscribe
from dooit.ui.api.events import Startup


class TokyoNightNight(DooitThemeBase):
    _name = "tokyo-night-night"

    background1: str = "#1a1b26"
    background2: str = "#16161e"
    background3: str = "#2f3549"

    foreground1: str = "#a9b1d6"
    foreground2: str = "#c0caf5"
    foreground3: str = "#cdd6f4"

    red: str = "#f7768e"
    orange: str = "#ff9e64"
    yellow: str = "#e0af68"
    green: str = "#9ece6a"
    blue: str = "#7aa2f7"
    purple: str = "#bb9af7"
    magenta: str = "#bb9af7"
    cyan: str = "#7dcfff"

    primary: str = "#7aa2f7"
    secondary: str = "#bb9af7"


@subscribe(Startup)
def layout_setup(api: DooitAPI, _):
    api.css.set_theme(TokyoNightNight)
