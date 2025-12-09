[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/W7W32691S)

# mind$box

**mind$box** is a **debug console** for **[StepMania 5](https://github.com/stepmania/stepmania) and [OutFox](https://github.com/TeamRizu/OutFox)** 
designed to display information and data.

https://github.com/user-attachments/assets/6b68068e-5170-4935-9646-03ab4d3cb311

mind$box focuses to be compatible with newer game builds, so it may not be
compatible with older versions.

## Installation

  1. Install [tapLua](https://github.com/EngineMachiner/tapLua).

### Linux

  2. Run the next commands in the game directory:
  ```console
  curl -o mindbox.sh https://raw.githubusercontent.com/EngineMachiner/mindbox/refs/heads/master/setup.sh
  ./mindbox.sh; rm mindbox.sh
  ```

---

Or it can be installed manually:

Be aware that to successfully install mind$box in your game build, it's important to have a **basic understanding of scripting and theme structure**.

  2. Clone the repository in the modules folder.
  ```
  git clone https://github.com/EngineMachiner/mindbox mind\$box
  ```

  3. Load it after tapLua.
  ```lua
    LoadModule("mind$box/mind$box.lua") -- After loading tapLua...
  ```

  4. Use `mindbox.print(...)` to print on the console or `mindbox.sysPrint(...)` to use the system message function.

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
