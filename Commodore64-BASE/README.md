# 🌆🅲🅸🆃🆈🆇🅴🅽☯️ 8 & 16 bit hijinx and programming!

# GPIO Tracker - Commodore 64 Version

![screen4](https://github.com/cityxen/GPIOTracker/blob/master/images/screen4.jpg)

Version: 1.0 by Deadline with code from Dorktronic: https://github.com/dorktronic

This program will set the user port output for 32 pin GPIO board from Dorktronic.

## Features:
* Up to 256 Tracks, Up to 16 Patterns of 256 different states
* Speed up or Slow down during playback with programmable command
* Stop playback with programmable command

## Notes:
* GPIOTracker Data is located from $4000 - $9fff (Note this could be reworked to use RAM Expansion devices in the future, or some other enhanced method than it is using now)
* Each block of GPIOTracker data is 1280 bytes

## Build Notes:
* Edit Build.bat to set it for your environment
* Requires DASM and KickAssembler to build
* Uses Macros and Constants from https://github.com/cityxen/Commodore64_Programming repo

## Commands:

### Storage

        D - change drive number (toggles between drives 08,09,10,11)

        F - change filename (allows you to change the working filename)

        $ - shows directory of current disk

        S - saves data to filename on drive

        L - loads data from filename from drive

        E - Erase File

        N - Clear memory

### Playback

        P - Play/Pause

### Editing:

        F1 - Moves Track Block Cursor UP

        F3 - Moves Track Block Cursor DOWN

        F2 - Track Block Length DOWN

        F4 - Track Block Length UP

        ; - Changes Pattern for current track UP

        : - Changes Pattern for current track DOWN

        Cursor Down - Move Pattern Cursor Down

        Cursor Up - Move Pattern Cursor Up

        Cursor Right - Move GPIO Cursor right

        Cursor Left - Move GPIO Cursor left

        SPACE - Toggle pin within current GPIO Cursor

        MINUS - Turn off all pins on current line

        PLUS - Turn on all oins on current line

        HOME - Move Pattern Cursor to TOP

        CLR - Move Pattern Cursor to BOTTOM

        F5 - Pattern Cursor Page UP

        F7 - Pattern Cursor Page DOWN

        C - Change Command

                Command   Value
                SPEED   = 00 - 3F (Change the speed of playback.. Lower = Faster)
                STOP    = IGNORED (Stops playback)
                FUTURE  = IGNORED (Future command slot available with values from 00-1f)

        * - Change Command Data Value Up (Command Data range is from 00-3F)

        = - Change Command Data Value Down

### Additional Features

        J - Toggle Joystick Control Mode

                JCM Modes:
                
                OFF  = Joystick doesn't affect anything
                PLAY = While fire button is pressed, track will play
                SS   = Fire release toggles playback (start / stop)
                Future modes:                
                *EDIT = Move Joystick Cursor within Pattern area to move, Fire toggle GPIO pin
