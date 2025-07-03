[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/W7W32691S)

# mind$box

**mind$box** is a **debug console** for **[StepMania 5](https://github.com/stepmania/stepmania) and [OutFox](https://github.com/TeamRizu/OutFox)** 
designed to display information and data.

https://github.com/user-attachments/assets/6b68068e-5170-4935-9646-03ab4d3cb311

mind$box focuses to be compatible with newer game builds, so it may not be
compatible with older versions.

## Installation

  1. Install [tapLua](https://github.com/EngineMachiner/tapLua).

### Bash

mind$box can be installed using the next bash command in the game directory:
```console
curl -o mindbox.sh https://raw.githubusercontent.com/EngineMachiner/tapLua/refs/heads/master/mindbox.sh
./mindbox.sh; rm mindbox.sh
```

---

Or it can be installed manually:

Be aware that to successfully install mind$box in your game build, it's important to have a **basic understanding of scripting and theme structure**.

### OutFox

  2. Clone the repository in the fallback's Modules folder.
  ```
  git clone https://github.com/EngineMachiner/mindbox mind\$box
  ```

  3. Load tapLua first, then load mind$box once through a script. 
  
  4. Add the console actor in `ScreenSystemLayer aux.lua` to make the console actor persistent:
  ```lua
  -- Themes/_fallback/BGAnimations/ScreenSystemLayer aux.lua
  return mindbox.console()
  ```

### Legacy

  2. Clone the repository in the same Modules folder following the same
  steps for tapLua cloning.
  ```
  git clone https://github.com/EngineMachiner/mindbox mind\$box
  ```

  3. Load tapLua first, then load mind$box once through a script. 
  
  4. Add the console actor in `ScreenSystemLayer aux.lua` to make the console actor persistent:
  ```lua
  -- Themes/_fallback/BGAnimations/ScreenSystemLayer aux.lua
  return mindbox.console()
  ```

---

  5. Use `mindbox.print(...)` to print into the console or `mindbox.sysPrint(...)`
  if you want to use the system message function.

---

Remember, if you're having problems with the texture being white, not showing up 
and you're using legacy builds, you should enable only OpenGL as renderer in 
your `Preferences.ini` due to D3D not being able to render textures in these builds.
```
VideoRenderers=opengl
```

## Credits
- [TeamRizu](https://github.com/TeamRizu)

Thank you to everyone who contributed to the development of this project!
