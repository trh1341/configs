----------------------------------------------------------------------
--                                                                  --
-- XMonad Settings                                                  --
--                                                                  --
--                                                                  --
-- XMonad version 0.8.1-darcs                                       --
-- XMonad config: 2009-06-25                                        --
--                                                                  --
-- by Nils                                                          --
--                                                                  --
-- For questions, write an email to:                                --
-- mail (at) n-sch . de                                             --
-- Or visit the #xmonad channel at irc.freenode.net                 --
--                                                                  --
--                                                                  --
-- Additional files:                                                --
-- http://www.n-sch.de/xmonad/icons.zip                             --
-- http://www.n-sch.de/xmonad/conkytoprc                            --
--                                                                  --
--                                                                  --
-- For the conkybar you need conky-cli or compile it with the       --
--     --disable-x11 option.                                        --
-- Notice: M-Shift-R will killall conky before restarting XMonad!   --
--                                                                  --
-- To make "clickable" work with dzen2, you need the                --
-- latest svn version.                                              --
--                                                                  --
--                                                                  --
--                                                                  --
-- {{{ Basic usage:                                                 --
--                                                                  --
-- mod + F1             - Start urxvt                               --
-- mod + F2             - Start dmenu                               --
-- mod + F3             - Start pcmanfm                             --
-- mod + F4             - Start chromium                            --
-- mod + F5             - Start pidgin on last workspace            --
-- mod + F6             - Start irssi in urxvt                      --
-- mod + F7             - Start mutt in urxvt                       --
-- mod + F8             - Start ncmpcpp in urxvt                    --
--                                                                  --
-- mod + j/k            - Go up/down in window list                 --
-- mod + h/l            - Adjust width/height of master             --
-- mod + ,/.            - Adjust numbers of master windows          --
-- mod + shift + j/k    - Adjust width/height of slaves             --
-- mod + space          - Next layout                               --
-- mod + shift + space  - Reset layout                              --
--                                                                  --
-- mod + 1-0            - View workspace x on screen 0              --
-- mod + ctrl + 1-0     - View workspace x on screen 1              --
-- mod + shift + ctrl + 1-0 - Default greedyView behaviour          --
-- mod + shift + 1-0    - Move current window to workspace x on     --
--                        current screen                            --
-- mod + <-             - Previous workspace                        --
-- mod + ->             - Next workspace                            --
-- mod + mousewheelUP   - Previous workspace                        --
-- mod + mousewheelDOWN - Next workspace                            --
-- mod + ^              - View last workspace ("com")               --
-- mod + tab            - Cycle through recent (hidden) workspaces  --
--                        tab - next workspace                      --
--                        esc - previous workspace                  --
--                        release mod to exit cycle mode            --
-- mod + a              - Cycle through visible screens             --
--                        a - next screen                           --
--                        s - previous screen                       --
--                        release mod to exit cycle mode            --
-- mod + s              - Swap current screen with visible ws       --
--                        s - next workspace                        --
--                        d - previous workspace                    --
--                        release mod to exit cycle mode            --
--                                                                  --
-- mod + q              - View urgent workspace                     --
-- mod + w              - Focus master window                       --
-- mod + w              - Swap current window with master           --
--                                                                  --
-- mod + f              - Toggle fullscreen                         --
-- mod + leftclick      - Float window                              --
-- mod + rightclick     - Adjust size of floated window             --
-- mod + t              - Push window back into tiling              --
-- mod + shift + t      - Push all windows back into tiling         --
--                                                                  --
-- Mediakeys            - Control MPD                               --
--                                                                  --
-- mod + shift + w      - Kill current window                       --
-- mod + shift + n      - Refresh current window                    --
-- mod + shift + r      - Restart XMonad                            --
--                                                                  --
-- mod + control + backspace - Exit XMonad                          --
--                                                                  --
-- }}}                                                              --
----------------------------------------------------------------------

-- {{{ imports

-- Core
import XMonad

import Data.Monoid
import System.IO
import System.Exit

import Control.Monad (liftM2)

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import qualified Data.List       as L

-- usefull stuff
import Graphics.X11.ExtraTypes.XF86 

-- Actions
import XMonad.Actions.CycleWS
import XMonad.Actions.CycleRecentWS
import XMonad.Actions.OnScreen
import XMonad.Actions.SinkAll
import XMonad.Actions.WindowGo

-- Utils
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.EZConfig

-- Hooks
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.FadeInactive

import XMonad.Hooks.ServerMode

-- Layouts
import XMonad.Layout.Reflect
import XMonad.Layout.PerWorkspace
import XMonad.Layout.LayoutHints
import XMonad.Layout.ToggleLayouts
--import XMonad.Layout.SimpleDecoration

import XMonad.Layout.ResizableTile
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Layout.ThreeColumns

import XMonad.Layout.IM
import Data.Ratio ((%))

-- }}}

-- mpd_host = "192.168.0.31"
mpd_host = "localhost"

-- {{{ Run XMonad

main = do
  dzen  <- spawnPipe myStatusBar 
  conky <- spawnPipe myConkyBar
  xmonad $ withUrgencyHookC NoUrgencyHook (urgencyConfig { suppressWhen = Focused }) defaultConfig {

      -- simple stuff
        terminal           = myTerminal
      , focusFollowsMouse  = myFocusFollowsMouse
      , borderWidth        = myBorderWidth
      , modMask            = myModMask
      , workspaces         = myWorkspaces
      , normalBorderColor  = myNormalBorderColor
      , focusedBorderColor = myFocusedBorderColor

      -- key bindings
      , keys               = myKeys
      , mouseBindings      = myMouseBindings

      -- hooks, layouts
      , layoutHook         = myLayout
      , manageHook         = myManageHook
      , handleEventHook    = myEventHook
      , logHook            = do
          dynamicLogWithPP (myLogHook dzen)
          fadeInactiveLogHook 0xdddddddd
      , startupHook        = myStartupHook

  }

-- }}}

-- {{{ Settings

-- workspaces
myWorkspaces            :: [String]
myWorkspaces            = clickable . (map dzenEscape) $ nWorkspaces 9 ["main", "web", "3", "torrents", "5", "6", "7", "8", "music","com"]

  where nWorkspaces n []= map show [1 .. n]
        nWorkspaces n l = init l ++ map show [length l .. n] ++ [last l]
        clickable l     = [ "^ca(1,xdotool key super+" ++ show (n) ++ ")" ++ ws ++ "^ca()"
                          | (i,ws) <- zip [1..] l
                          , let n = if i == 10 then 0 else i
                          ]


myTerminal              = "urxvt"

myModMask               = mod4Mask

myFocusFollowsMouse     = False

myBorderWidth           = 2
myNormalBorderColor     = "#000000"
myFocusedBorderColor    = "#555555"

-- }}}

-- {{{ Log hook

-- Statusbar with workspaces, layout and title
myStatusBar = "dzen2 -p -xs 1 -ta l -fg '" ++ myDzenFGColor ++ 
              "' -bg '" ++ myNormalBGColor ++ "' -fn '" ++ myFont ++ "' -w 1920"

myConkyBar  = "conky -c ~/.conkytoprc | dzen2 -p -xs 2 -ta l -fg '" ++ myDzenFGColor ++
              "' -bg '" ++ myNormalBGColor ++ "' -fn '" ++ myFont ++ "' -w 2560"

-- Colors, font and iconpath definitions:
myFont = "-xos4-terminus-medium-r-normal--12-*-*-*-*-*-*-u"

myDzenFGColor = "#3399ff"
myNormalFGColor = "#3399ff"
myNormalBGColor = "#000000"
myUrgentFGColor = "#88C4FE"
myUrgentBGColor = "#017CF2"


-- LogHook-Settings
myLogHook h = defaultPP
    { ppCurrent	    = dzenColor myNormalFGColor myNormalBGColor . pad . ("^i(.dzen/corner.xbm)" ++) -- current workspace
    , ppVisible	    = dzenColor "#5cafff" ""                 . pad                               -- visible workspaces on other screens
    , ppHidden	    = dzenColor "#aac4fe" ""                      . pad . ("^i(.dzen/corner.xbm)" ++) -- hidden workspaces with apps
    , ppHiddenNoWindows     = dzenColor "#444444"  ""           . pad                               -- empty workspaces
    , ppUrgent	    = dzenColor "" myUrgentBGColor                                                  -- urgent workspaces
    , ppTitle       = dzenColor myNormalFGColor ""              . pad . dzenEscape                  -- title of selected window
    , ppWsSep       = ""                                                                            -- workspace seperator
    , ppSep         = dzenEscape "|"                                                                -- workspace/layout/title seperator

    -- Layout icons
    , ppLayout      = dzenColor myNormalFGColor "" .
        (\ x -> case x of
                     "ResizableTall"                    -> pad "^i(.dzen/layout-tall-right.xbm)"
                     "Mirror ResizableTall"             -> pad "^i(.dzen/layout-mirror-bottom.xbm)"
                     "Full"                             -> pad "^i(.dzen/layout-full.xbm)"
                     "IM Grid"                          -> pad "^i(.dzen/layout-withim-left1.xbm)"
                     "IM Hinted ResizableTall"          -> pad "^i(.dzen/layout-withim-left2.xbm)"
                     "IM Mirror ResizableTall"          -> pad "^i(.dzen/layout-withim-left3.xbm)"
                     "IM Full"                          -> pad "^i(.dzen/layout-withim-left4.xbm)"
                     "IM ReflectX IM Full"              -> pad "^i(.dzen/layout-gimp.xbm)"
                     _                                  -> pad x
        )

	, ppOutput      = hPutStrLn h
    }

-- }}}

-- {{{ Other hooks

-- Event hook
myEventHook = const . return $ All True

-- Startup hook
myStartupHook = setWMName "LG3D"

-- Manage hook
myManageHook = composeAll . concat $

    -- Float apps
    [ [ className =? c                  --> doCenterFloat | c <- myCFloats    ]
    , [ resource  =? r                  --> doCenterFloat | r <- myRFloats    ]
    , [ title     =? t                  --> doCenterFloat | t <- myTFloats    ]

    -- "Real" fullscreen
    , [ isFullscreen                    --> doFullFloat ]

    -- Workspaces
    -- Be carefull with (!!) - if n is too big xmonad crashes!
    , [ className =? "Chrome"          --> doF (liftM2 (.) W.view W.shift $ myWorkspaces !! 0) ]
    , [ className =? "Opera"            --> doF (liftM2 (.) W.view W.shift $ myWorkspaces !! 0) ]
    , [ className =? "Xchat"            --> doF (liftM2 (.) W.view W.shift $ myWorkspaces !! 1) ]
    , [ resource  =? "irssi"            --> doF (W.shift $ myWorkspaces !! 1) ]
    , [ className =? "Pidgin"           --> doF (W.shift $ last myWorkspaces) ]
    , [ className =? "Dtella"           --> doF (W.shift $ myWorkspaces !! 4) ]
    , [ resource  =? "rtorrent"         --> doF (W.shift $ myWorkspaces !! 3) ]
    ]

  where myCFloats = ["Wine", "Switch2"]
        myRFloats = ["Dialog", "Download"]
        myTFloats = ["Schriftart auswählen"]
        qa /=? a  = fmap not (qa =? a)


-- }}}

-- {{{ Key & Mouse

myKeys conf = mkKeymap conf $

    -- General moving & stuff
    [ ("M-S-w", kill) -- close focused window 

    , ("M-<Space>", sendMessage NextLayout) -- Rotate through the available layout algorithms
    , ("M-S-<Space>", setLayout $ XMonad.layoutHook conf) --  Reset the layouts on the current workspace to default

    , ("M-n", refresh) -- Resize viewed windows to the correct size

    , ("M-j", windows W.focusDown) -- Move focus to the next window
    , ("M-<D>", windows W.focusDown) -- Move focus to the next window
    , ("M-k", windows W.focusUp  ) -- Move focus to the previous window
    , ("M-<U>", windows W.focusUp  ) -- Move focus to the previous window
    , ("M-q", focusUrgent        ) -- Focus urgent windows

    , ("M-w", windows W.focusMaster    ) -- Move focus to the master window
    , ("M-e", windows W.swapMaster     ) -- Swap the focused window and the master window
    , ("M-S-j", windows W.swapDown       ) -- Swap the focused window with the next window
    , ("M-S-k", windows W.swapUp         ) -- Swap the focused window with the previous window

    , ("M-,", sendMessage $ IncMasterN 1)      -- Increment the number of windows in the master area
    , ("M-.", sendMessage $ IncMasterN (-1))   -- Deincrement the number of windows in the master area

    , ("M-h", sendMessage Shrink) -- Shrink the master area
    , ("M-l", sendMessage Expand) -- Expand the master area
    , ("M-C-j", sendMessage MirrorShrink) -- Shrink slaves
    , ("M-C-k", sendMessage MirrorExpand) -- Expand slaves

    , ("M-S-f", sendMessage ToggleStruts >> sendMessage ToggleLayout) -- Toggle fullscreen
    , ("M-t", withFocused $ windows . W.sink) -- Push window back into tiling
    , ("M-S-t", sinkAll) -- Push all floating windows back into tiling

    , ("M-S-r", spawn "killall conky" >> restart "xmonad" True) -- Restart xmonad, quit conky first

    , ("M-C-<Backspace>", io $ exitWith ExitSuccess) -- quit xmonad
    ]
    ++

    -- Applications to run
    let myRunOrRaise cmd qry = ifWindow qry raiseHook (spawn cmd) in
    [ ("M-<F1>", spawn myTerminal)
    , ("M-y", spawn myTerminal)
    , ("M-d", spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"") -- launch dmenu
    , ("<Print>", spawn "scrot")
    , ("M-z", spawn "zim")
    , ("M-<F2>", spawn "exe=`dmenu_run -b` && eval \"exec $exe\"") -- launch dmenu
    , ("M-<F3>", spawn "pcmanfm")
    , ("M-f", spawn "pcmanfm")
    , ("M-<F4>", runOrRaise "google-chrome-beta" (className =? "Chrome"))
    , ("M-<F5>", runOrRaise "hipchat"  (className =? "Hipchat"))
    , ("M-<F6>", myRunOrRaise (myTerminal ++ " -name irssi -e zsh -c \"irssi\"") (resource =? "irssi"))
    , ("M-<F7>", myRunOrRaise (myTerminal ++ " -name rtorrent -e zsh -c \"screen -x || screen rtorrent\"") (resource =? "rtorrent"))
    , ("M-<F8>", myRunOrRaise ("export MPD_HOST=" ++ mpd_host ++ " && " ++ myTerminal ++ " -name ncmpcpp -e ncmpcpp") (resource =? "ncmpcpp"))
    , ("M-S-<F7>", myRunOrRaise (myTerminal ++ " -name abook -e abook ") (resource =? "abook"))
    , ("M-S-<F8>", runOrRaise "sonata" (className =? "sonata"))
    ]
    ++

    -- Multimedia keys
    -- Set according xmodmap!
    [ ("M-p",        spawn $ "export MPD_HOST=" ++ mpd_host ++ " && mpc toggle")
    , ("M-i",        spawn $ "export MPD_HOST=" ++ mpd_host ++ " && mpc prev")
    , ("M-o",        spawn $ "export MPD_HOST=" ++ mpd_host ++ " && mpc next")
    ]
    ++

    -- mod-[1..0]           , Switch to workspace N on screen 0
    -- mod-ctrl[1..0]       , Switch to workspace N on screen 1
    -- mod-shift-[1..0]     , Move focused client to workspace N on current screen,
    --                        then switch to it
    -- mod-ctrl-shift-[1..0], "Normal" greedyView-behaviour
    [ ("M-" ++ m ++ k, windows (f i))
         | (i, k) <- zip (workspaces conf) (map show ([1..9] ++ [0]))
         , (m, f) <- [ (""      , greedyViewOnScreen 0)
                     , ("C-"    , greedyViewOnScreen 1)
                     , ("S-"    , liftM2 (.) W.greedyView W.shift)
                     , ("C-S-"  , W.greedyView)] ]
    ++
    -- Move to the last workspace (my IM ws)
    [ ("M-^"  , windows $ viewOnScreen 0 (last myWorkspaces))
    , ("M-C-^", windows $ viewOnScreen 1 (last myWorkspaces))


    -- Cycle recent (not visible) workspaces, tab is next, escape previous in history
    , let options w     = map (W.greedyView `flip` w)   (hiddenTags w)
      in ("M-<Tab>" , cycleWindowSets options [xK_Super_L] xK_Tab xK_Escape)
    -- Swap visible workspaces on current screen, s is next, d previous
    , let options w     = map (W.greedyView `flip` w)   (visibleTags w)
      in ("M-s"     , cycleWindowSets options [xK_Super_L] xK_s xK_d)

    -- Cycle through visible screens, a is next, s previous
    , let options w     = map (W.view `flip` w)         (visibleTags w)
      in ("M-a"     , cycleWindowSets options [xK_Super_L] xK_a xK_s)

    , ("M-<R>", nextWS) -- Next workspace
    , ("M-<L>", prevWS) -- Previous workspace
    ]

  where hiddenTags w  = map W.tag $ W.hidden w ++ [W.workspace . W.current $ w]
        visibleTags w = map (W.tag . W.workspace) $ W.visible w ++ [W.current w]

        {-
        -- Run application when switching to workspace N
        -- Carefull with the (!!) operator
        spawnMaybe ws
            | ws == (workspaces conf !! 4) = spawn "urxvt"
            | otherwise = return ()
        -}


myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)) -- Set the window to floating mode and move by dragging
    , ((modMask, button2), (\w -> focus w >> sendMessage ToggleStruts >> sendMessage ToggleLayout)) -- Toggle fullscreen
    --, ((modMask, button2), (\w -> focus w >> windows W.shiftMaster)) -- Raise the window to the top of the stack
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)) -- Set the window to floating mode and resize by dragging
    , ((modMask, button4), (\_ -> prevWS)) -- previous Workspace
    , ((modMask, button5), (\_ -> nextWS)) -- next Workspace

    ]

-- }}}

-- {{{ Layouts
myLayout = smartBorders . avoidStruts . toggleLayouts Full $

    -- Layouts for workspaces
    -- onWorkspace (myWorkspaces !! 1) (Mirror tiled ||| tiled ||| Full) $
    onWorkspace (last myWorkspaces) myIM $

    -- Default
    Mirror tiled ||| tiled ||| Full ||| gimp 

  where
    tiled       = {- layoutHints $ -} ResizableTall 1 (3/100) (2/3) []

    myIM        = withIM (0.15) (Role "buddy_list") $ Grid ||| Mirror tiled ||| tiled ||| Full -- Pidgin buddy list
    gimp        = withIM (0.15) (Role "gimp-toolbox") $
                  reflectHoriz $
                  withIM (0.21) (Role "gimp-dock") Full

-- | Modify the current layout to add a tabbed 
--

-- }}}
