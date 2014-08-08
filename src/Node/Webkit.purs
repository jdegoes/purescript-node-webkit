module Node.Webkit where

  import Control.Monad.Eff (Eff())

  import Data.Function (Fn0(), Fn1(), Fn2(), Fn3())
  import Data.Maybe (Maybe())

  import Node.Events (on, Event(..), EventEff(), EventEmitter)

  instance eventEmitterNWWindow :: EventEmitter NWWindow

  type ManifestWindow =
    { title           :: String
    , width           :: Number
    , height          :: Number
    , toolbar         :: Boolean
    , icon            :: String
    , position        :: String
    , min_width       :: Number
    , min_height      :: Number
    , max_width       :: Number
    , max_height      :: Number
    , as_desktop      :: Boolean
    , resizable       :: Boolean
    , "always-on-top" :: Boolean
    , fullscreen      :: Boolean
    , show_in_taskbar :: Boolean
    , frame           :: Boolean
    , show            :: Boolean
    , kiosk           :: Boolean
    }

  defaultManifestWindow :: ManifestWindow
  defaultManifestWindow =
    { title: ""
    , width: 800
    , height: 600
    , toolbar: true
    , icon: ""
    , position: "center"
    , min_width: 800
    , min_height: 600
    , max_width: 800
    , max_height: 600
    , as_desktop: false
    , resizable: true
    , "always-on-top": false
    , fullscreen: false
    , show_in_taskbar: true
    , frame: true
    , show: true
    , kiosk: false
    }

  foreign import data IFrame :: *
  foreign import data NWShell :: *
  foreign import data NWWindow :: *
  foreign import data NW :: !
  foreign import data WindowPolicy :: *
  foreign import data WindowPolicyEff :: !

  foreign import nwShell
    "function nwShell() {\
    \  return require('nw.gui').Shell;\
    \}" :: forall eff. Eff (nw :: NW | eff) NWShell

  foreign import nwWindow
    "function nwWindow() {\
    \  return require('nw.gui').Window;\
    \}" :: forall eff. Eff (nw :: NW | eff) NWWindow

  foreign import get
    "function get(win) {\
    \  return function() {\
    \    return win.get();\
    \  }\
    \}" :: forall eff. NWWindow -> Eff (nw :: NW | eff) NWWindow

  foreign import open
    "function open(url) {\
    \  return function(opts) {\
    \    return function(win) {\
    \      return function() {\
    \        return win.open(url, opts);\
    \      }\
    \    }\
    \  }\
    \}" :: forall eff. String -> ManifestWindow -> NWWindow -> Eff (nw :: NW | eff) NWWindow

  foreign import shellOpen
    "function shellOpen(method) {\
    \  return function(url) {\
    \    return function(shell) {\
    \      return function() {\
    \        return shell[method](url);\
    \      }\
    \    }\
    \  }\
    \}" :: forall eff. String -> String -> NWShell -> Eff (nw :: NW | eff) NWShell

  openExternal :: forall eff. String -> NWShell -> Eff (nw :: NW | eff) NWShell
  openExternal = shellOpen "openExternal"

  openItem :: forall eff. String -> NWShell -> Eff (nw :: NW | eff) NWShell
  openItem = shellOpen "openItem"

  showItemInFolder :: forall eff. String -> NWShell -> Eff (nw :: NW | eff) NWShell
  showItemInFolder = shellOpen "showItemInFolder"

  foreign import showDevTools
    "function showDevTools(win) {\
    \  return function() {\
    \    return win.showDevTools();\
    \  }\
    \}" :: forall eff. NWWindow -> Eff (nw :: NW | eff) NWWindow

  foreign import closeWindow
    "function closeWindow(win) {\
    \  return function() {\
    \    return win.close(true);\
    \  }\
    \}" :: forall eff. NWWindow -> Eff (nw :: NW | eff) NWWindow

  foreign import windowPolicy
    "function windowPolicy(method) {\
    \  return function(policy) {\
    \    return function() {\
    \      return policy[method]();\
    \    }\
    \  }\
    \}" :: forall eff
        .  String
        -> WindowPolicy
        -> Eff (policy :: WindowPolicyEff | eff) Unit

  ignore         :: forall eff. WindowPolicy -> Eff (policy :: WindowPolicyEff | eff) Unit
  ignore         = windowPolicy "ignore"
  forceCurrent   :: forall eff. WindowPolicy -> Eff (policy :: WindowPolicyEff | eff) Unit
  forceCurrent   = windowPolicy "forceCurrent"
  forceDownload  :: forall eff. WindowPolicy -> Eff (policy :: WindowPolicyEff | eff) Unit
  forceDownload  = windowPolicy "forceDownload"
  forceNewWindow :: forall eff. WindowPolicy -> Eff (policy :: WindowPolicyEff | eff) Unit
  forceNewWindow = windowPolicy "forceNewWindow"
  forceNewPopup  :: forall eff. WindowPolicy -> Eff (policy :: WindowPolicyEff | eff) Unit
  forceNewPopup  = windowPolicy "forceNewPopup"

  onBlur :: forall eff
         .  Fn0 (Eff eff Unit)
         -> NWWindow
         -> Eff (event :: EventEff | eff) NWWindow
  onBlur = on $ Event "blur"

  onCapturepagedone :: forall eff
                    .  Fn1 String (Eff eff Unit)
                    -> NWWindow
                    -> Eff (event :: EventEff | eff) NWWindow
  onCapturepagedone = on $ Event "capturepagedone"

  onClose :: forall eff
          .  Fn0 (Eff eff Unit)
          -> NWWindow
          -> Eff (event :: EventEff | eff) NWWindow
  onClose = on $ Event "close"

  onClosed :: forall eff
           .  Fn0 (Eff eff Unit)
           -> NWWindow
           -> Eff (event :: EventEff | eff) NWWindow
  onClosed = on $ Event "closed"

  onDevtoolsClosed :: forall eff
                   .  Fn0 (Eff eff Unit)
                   -> NWWindow
                   -> Eff (event :: EventEff | eff) NWWindow
  onDevtoolsClosed = on $ Event "devtools-closed"

  onDevtoolsOpened :: forall eff
                   .  Fn1 String (Eff eff Unit)
                   -> NWWindow
                   -> Eff (event :: EventEff | eff) NWWindow
  onDevtoolsOpened = on $ Event "devtools-opened"

  onDocumentEnd :: forall eff
                .  Fn1 (Maybe IFrame) (Eff eff Unit)
                -> NWWindow
                -> Eff (event :: EventEff | eff) NWWindow
  onDocumentEnd = on $ Event "document-end"

  onDocumentStart :: forall eff
                  .  Fn1 (Maybe IFrame) (Eff eff Unit)
                  -> NWWindow
                  -> Eff (event :: EventEff | eff) NWWindow
  onDocumentStart = on $ Event "document-start"

  onEnterFullscreen :: forall eff
                    .  Fn0 (Eff eff Unit)
                    -> NWWindow
                    -> Eff (event :: EventEff | eff) NWWindow
  onEnterFullscreen = on $ Event "enter-fullscreen"

  onFocus :: forall eff
          .  Fn0 (Eff eff Unit)
          -> NWWindow
          -> Eff (event :: EventEff | eff) NWWindow
  onFocus = on $ Event "focus"

  onLeaveFullscreen :: forall eff
                    .  Fn0 (Eff eff Unit)
                    -> NWWindow
                    -> Eff (event :: EventEff | eff) NWWindow
  onLeaveFullscreen = on $ Event "leave-fullscreen"

  onLoaded :: forall eff
           .  Fn0 (Eff eff Unit)
           -> NWWindow
           -> Eff (event :: EventEff | eff) NWWindow
  onLoaded = on $ Event "loaded"

  onLoading :: forall eff
            .  Fn0 (Eff eff Unit)
            -> NWWindow
            -> Eff (event :: EventEff | eff) NWWindow
  onLoading = on $ Event "loading"

  onMaximize :: forall eff
             .  Fn0 (Eff eff Unit)
             -> NWWindow
             -> Eff (event :: EventEff | eff) NWWindow
  onMaximize = on $ Event "maximize"

  onMinimize :: forall eff
             .  Fn0 (Eff eff Unit)
             -> NWWindow
             -> Eff (event :: EventEff | eff) NWWindow
  onMinimize = on $ Event "minimize"

  onMove :: forall eff
         .  Fn2 Number Number (Eff eff Unit)
         -> NWWindow
         -> Eff (event :: EventEff | eff) NWWindow
  onMove = on $ Event "move"

  onNewWinPolicy :: forall eff
          .  Fn3 (Maybe IFrame) String WindowPolicy (Eff eff Unit)
          -> NWWindow
          -> Eff (event :: EventEff | eff) NWWindow
  onNewWinPolicy = on $ Event "new-win-policy"

  onResize :: forall eff
           .  Fn2 Number Number (Eff eff Unit)
           -> NWWindow
           -> Eff (event :: EventEff | eff) NWWindow
  onResize = on $ Event "resize"

  onRestore :: forall eff
            .  Fn0 (Eff eff Unit)
            -> NWWindow
            -> Eff (event :: EventEff | eff) NWWindow
  onRestore = on $ Event "restore"

  onUnmaximize :: forall eff
               .  Fn0 (Eff eff Unit)
               -> NWWindow
               -> Eff (event :: EventEff | eff) NWWindow
  onUnmaximize = on $ Event "unmaximize"

  onZoom :: forall eff
         .  Fn1 Number (Eff eff Unit)
         -> NWWindow
         -> Eff (event :: EventEff | eff) NWWindow
  onZoom = on $ Event "zoom"
