{...}: {
  wayland.windowManager.mango = {
    settings = ''
      #==================================================#
      # Key Bindings
      #==================================================#
      # key name refer to `xev` or `wev` command output,
      # mod keys name: super,ctrl,alt,shift,none

      # reload config(after rebuilding, reload_config)
      bind=SUPER,r,reload_config

      bind=SUPER,Return,spawn,ghostty
      bind=SUPER,T,spawn,foot
      bind=SUPER,O,spawn,firefox
      bind=SUPER,d,spawn,wofi --show drun
      bind=SUPER,Q,killclient
      #==================================================#
      # Scroller
      #==================================================#
      keymode=default
      bind=SUPER,h,focusdir,left
      bind=SUPER,l,focusdir,right
      bind=SUPER,k,focusstack,prev
      bind=SUPER,j,focusstack,next

      #==================================================#
      # Move windows
      #==================================================#
      bind=SUPER+SHIFT,h,exchange_client,left
      bind=SUPER+SHIFT,l,exchange_client,right
      bind=SUPER+SHIFT,k,exchange_stack_client,prev
      bind=SUPER+SHIFT,j,exchange_stack_client,next

      #==================================================#
      # Tile (Master/Stack)
      #==================================================#
      keymode=tile
      bind=SUPER,h,focusdir,left
      bind=SUPER,l,focusdir,right
      bind=SUPER,k,focusstack,prev
      bind=SUPER,j,focusstack,next

      #==================================================#
      # Move windows / Adjust Layout
      #==================================================#
      bind=SUPER+SHIFT,h,incnmaster,+1
      bind=SUPER+SHIFT,l,incnmaster,-1
      bind=SUPER+SHIFT,k,exchange_stack_client,prev
      bind=SUPER+SHIFT,j,exchange_stack_client,next

      #==================================================#
      # Sizing
      #==================================================#
      bind=SUPER,equal,setmfact,-0.05
      bind=SUPER+SHIFT,equal,setmfact,+0.05

      #==================================================#
      # Mouse Binds
      #==================================================#
      mousebind=SUPER,btn_left,moveresize,curmove
      mousebind=SUPER,btn_right,moveresize,curresize
      mousebind=NONE,btn_left,toggleoverview,-1
      #==================================================#
      # Grid
      #==================================================#
      keymode=grid
      bind=SUPER,h,focusdir,left
      bind=SUPER,l,focusdir,right
      bind=SUPER,k,focusdir,up
      bind=SUPER,j,focusdir,down

      #==================================================#
      # Move current window
      #==================================================#
      bind=SUPER+SHIFT,h,exchange_client,left
      bind=SUPER+SHIFT,l,exchange_client,right
      bind=SUPER+SHIFT,k,exchange_client,up
      bind=SUPER+SHIFT,j,exchange_client,down

    '';
  };
}
