-- IMPORTS
import XMonad
import XMonad.Util.EZConfig
import XMonad.Util.Ungrab
import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run
import XMonad.Hooks.ManageDocks

import qualified Data.Map as M
import qualified XMonad.StackSet as W

-- KEY BINDINGS
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $ 
    [ ((modm, xK_q), kill),
      ((modm, xK_e), spawn "rofi -show run"),
      ((modm, xK_Return), spawn $ XMonad.terminal conf),
      ((modm, xK_Tab), windows W.focusDown),
      ((modm .|. shiftMask, xK_Tab), windows W.focusUp),
      ((modm, xK_m), windows W.swapMaster),
      ((modm, xK_n), windows W.swapDown),
      ((modm .|. shiftMask, xK_n), windows W.swapUp),
      ((modm, xK_a), sendMessage (IncMasterN 1)),
      ((modm, xK_d), sendMessage (IncMasterN (-1))),
      ((modm, xK_slash), spawn "xmonad --recompile ; xmonad --restart"),
      ((modm, xK_w), sendMessage Expand),
      ((modm, xK_s), sendMessage Shrink),
      ((modm, xK_space), sendMessage NextLayout),

      ((modm, xK_f), spawn "firefox")
    ]
    ++
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

-- LAYOUT HOOK
myInternalSpace = 30
myGaps = gaps [(U, 27)]
mySpacing = spacingRaw False
                       (Border myInternalSpace 0 myInternalSpace 0)
                       True
                       (Border 0 myInternalSpace 0 myInternalSpace)
                       True
myLayout = myGaps $ mySpacing $ tiled ||| Mirror tiled
    where
        tiled = Tall nmaster delta ratio
        nmaster = 1
        ratio = 1/2
        delta = 3/100

-- MAIN
main :: IO ()
main = do
    xmproc <- spawnPipe "xmobar -x 0 .config/xmobar/xmobarrc"
    bg <- spawnPipe "~/.fehbg"
    picom <- spawnPipe "picom --experimental-backends"

    xmonad $ docks def
        { modMask = mod4Mask
        , terminal = "alacritty"
        , keys = myKeys

        -- HOOKS
        , logHook = dynamicLogWithPP xmobarPP {
              ppOutput = hPutStrLn xmproc,
              ppCurrent = xmobarColor "#751dc6" "" . wrap
                      ("<box type=Bottom width=2 mb=5 color=#6b14bc>") "</box>",
              ppHidden = xmobarColor "#1db8c6" "",
              ppHiddenNoWindows = xmobarColor "#497fcc" "",
              ppOrder = \(ws:l:t:exs) -> [ws,t],
              ppTitle = xmobarColor "#594ece" "" . shorten 50,
              ppSep = " | "

          }
        , layoutHook = myLayout
        , manageHook = manageDocks <+> manageHook def
        , workspaces = ["dev", "www", "vbox", "com", "mus", "vid", "doc", "game", "misc"]
        , normalBorderColor = "#497fcc"
        , focusedBorderColor = "#594ece"
        }
