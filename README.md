# Tiago's Linux environment

| Ubuntu               | Architecture | Status                                                                                                                                                           |
| -------------------- | ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 22.04 Jammy          | AMD64        | [![Build Status](https://github.com/LASER-Robotics/linux-setup/workflows/Jammy/badge.svg)](https://github.com/LASER-Robotics/linux-setup/actions)                              |

## Summary

This repo contains settings of Tiago's Linux work environment.

It could be summarized as follows:
* **ROS 2 - Humble Hawksbill**
* **i3** (i3gaps) tiling window manager with i3bar and vim-like controls
  * **i3-layout-manager** for saving and loading window layouts
* **urxvt** terminal emulator with ability to show images (when using the *ranger* file manager)
* **tmux** terminal multiplexer is running all the time
  * **tmuxinator** for automation of tmux session
  * vim-compatible key bindings for split switching
* **vim** is everywhere
  * pluginized for smooth c++ and ROS development
  * youcompleteme
  * UltiSnips
  * shared clipboards between vim, tmux and OS
  * Ctrl+P
  * smooth latex development with vimtex and zathura
  * Tim Pope is the king
* **athame** gives you vim in the terminal (zsh)
  * handfull of plugins in terminal: ultisnips, vim-surround, targets.vim, vim-exchange, etc.
* **zsh** better shell for everyday use
* **ranger** terminal file manager
* **profile_manager** and **epigen** for switching between machine-specific configurations (profiles within dotfiles)
  * all-in-one configuration, no git branching, no more cherrypicking
  * sharing configs between multiple users
  * sharing configs between different machines
  * seamless switching of colorschemes
* **tweaks** ubuntu plus settings manager
* **chrome** Google Chrome browser
* **sublime** Sublime text
* **zoom** Zoom meeting app
* **slack** Slack social app
* **dolphin** File manager
* **My tools** terminal file manager
  * **tlp** battery/power manager
  * **nativefier** webapp creator
   * nodejs
  

To clone and install everything run following code. **BEWARE**, running this will **DELETE** your current .i3, tmux, vim, etc. dotfiles.
```bash
cd /tmp
echo "mkdir -p ~/my_git
cd ~/my_git
sudo apt-get -y install git
git clone https://github.com/LASER-Robotics/linux-setup.git
cd linux-setup
./install.sh" > run.sh && source run.sh
```
**Calling install.sh repeatedly** will not cause acumulation of code in your .bashrc, so feel free to update your configuration by rerunning it.

# Credits

I thank the following source for inspiration. It helped me to learn a lot:

* Tomas Baca, https://github.com/klaxalk

# Troubleshooting

It is possible and probable that after you update using ```git pull```, something might not work anymore.
This usually happens due to new programs, plugins, and dependencies that might not be satisfied anymore.
I suggest re-running **install.sh**, after each update.

# Disclaimer

This software is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.
