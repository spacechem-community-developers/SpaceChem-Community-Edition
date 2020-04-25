
# SpaceChem Community Edition

This project will replace your [SpaceChem](http://www.zachtronics.com/spacechem/) game executable to add new features to the game.

This project is the **Zachtronics-approved** continuation of the [SpaceChem Community update (v1013)](https://steamcommunity.com/games/92800/announcements/detail/1737729728308220584), 
with more features added that are not either ready or polished enough to land in the official release of SpaceChem.

## Supported game versions

The only supported version is the Steam version of the game.
This is unlikely to change in the future, for legal reasons related to the game distribution.

## Installing the update

In the [Release Page](https://github.com/spacechem-community-developers/SpaceChem-Community-Edition/releases/latest) you'll find a `SpaceChem.exe` executable file.
This file needs to be placed in the Steam directory of SpaceChem, whose default path is:
* Windows: `C:\Program Files (x86)\Steam\steamapps\common\SpaceChem`
* Linux `~/.steam/steam/steamapps/common/SpaceChem`

Overwrite the original file, it'll still be possible to recover it by verifying the game files via Steam.

On Mac, the .exe file is within `~/Library/Application Support/Steam/steamapps/common/SpaceChem/SpaceChem.app`. In the Finder, right-click on `SpaceChem.app` and select *Show Package Contents*. Then navigate to `Contents/Resources/SpaceChem.exe` and replace the file with the new SpaceChem.exe file. (To display the `~/Library` folder in the Finder, hold down the option key while viewing the Go menu and select *Library*.)

## Always-on improvements

There are some small general improvements, mostly small QoL stuff, and then some bigger things:

### Multiple solution support

SpaceChem is the only Zachtronics puzzle game that doesn't allow you to keep multiple solutions for the same puzzle. If you want to
try optimizing the same puzzle for multiple goals, you need to throw your old solutions away, bury them deep in the undo stack, or
use tools like SaveChem to export and import them and maintain them outside the game. This improvement lets you maintain an unlimited
number of additional solutions per puzzle and freely switch between them while the game is running.

The UI follows the example set by Exapunks: you first need to load the level you want to play, then you can open a solution picker
window by clicking on the new button added below the Undo and Redo buttons on the toolbar. This window lets you create blank new
solutions or copy one of the existing ones. For technical reasons, your original solution is listed as "(Default solution)". This
solution cannot be deleted or renamed. This is the only solution visible to the original game, so if you intend to switch back
and forth between the original and the Community Edition, this is the one you need to keep up to date.

**NOTE**: This improvement has to make changes to your save file the original would never do. While we've done some preliminary
testing and it seems to be safe, it's recommended to back up your save file before you create any new solutions.

### Support for the import/export used in tournaments
The [SpaceChemTool](https://github.com/spacechem-community-developers/SpaceChemTool) (SCT for friends), used for the tournaments,
can export and import solutions to custom puzzles.

This ability is replicated here and is extended to all puzzles and all solutions (see above). To use it, open the solution picker window, then:

* Select `Export` to export solutions to your clipboard, in a format identical to what the SCT would produce.
  You can either export the currently loaded solution, or all solutions of the current puzzle.
* Select `Import` to import solutions from your clipboard. If the clipboard contains just one solution, it's also possible to overwrite the current
  solution instead of importing the data into a new one. This is useful if you need to share a solution with the original game, which can
  only see the default. Overwriting is not a destructive operation: you can undo it if you change your mind later, just like you can with regular
  solution changes.

Importing a solution into a puzzle it wasn't created in may work if the puzzle available tools are fully compatible, but will usually fail.

### Keyboard accessibility
* PgUp/PgDn moves to previous/next page in ResNet lists
* PgUp/PgDn switches between planets in the level selector
* In the custom assignment list, you can navigate via arrow keys or WASD, play by pressing Enter and delete by pressing Delete
* The ResNet Access Denied screen can be dismissed with Enter and you can go back with Escape

### Return to assignment after completing it

After completing an assignment, you can click on the (now enabled) Back button or press Escape to return to the assignment. This lets you iterate
on your solution a bit more quickly when optimizing.

### Enhanced ResearchNet research puzzles

You can have up to 4 sensors, fusion lasers, fission lasers and quantum tunnels in a puzzle now.
A Split instruction triggers all fission lasers in a reactor and a Fuse instruction triggers all fusion lasers.
Sensing instructions will activate if any of the sensors detects the specified element.
Quantum tunnels work in a "round-robin" fashion: tunnel #1 will teleport atoms to tunnel #2, tunnel #2 will teleport to tunnel #3 and so on,
except for the highest-numbered tunnel, which will teleport to tunnel #1.  
Please read the "Compatibility Notes" section below if you also want to run the original game alongside the modified version.

### "Free-form" ResearchNet production puzzles

This is a highly experimental addition to the ResearchNet puzzle editing functionality. When creating a free-form production puzzle, you can place items like
inputs (both random and programmable), outputs, recyclers and fixed reactors (like on planet Flidais) on the terrain freely, instead of being limited to
a fixed number of inputs and outputs. If you move any pipes from their default state, those pipes also become locked and not editable while playing.

Once placed, inputs and outputs are editable via double-click or by using the context menu. Input rates can be changed from the default 10 cycles, and in the case
of random inputs, the random seed can be changed to get a different molecule order. Outputs can have a different target count than the default 40.

In addition to the free-form placement features, you can also define four custom reactor types that are unique to your puzzle. You can then enable them to
be used freely by the player, or place them as fixed parts of the level and force the player to work around the forced placement. The custom reactor types
can have their own names, have a custom amount of any supported feature, and can look like any of the existing reactors. Finally, you can disable the
second input and second output pipe, getting a result similar to assembly and disassembly reactors, but without forcing the set of available features.
(The input pipes are a fixed part of the reactor artwork, so a disabled bottom input pipe can't be visually hidden. To avoid confusion, you should pick
the disassembly reactor artwork if and only if you disable the bottom input pipe, so the appearance agrees with the behavior.)

Free-form puzzles can only be played in the Community Edition v4.3 or later. The vanilla game will treat them as if they were created by a future version
of SpaceChem. This is necessary in order not to confuse the vanilla game and to make sure it doesn't corrupt the puzzle while trying to load it.

This is a very experimental feature at the moment, so we may have to break backwards compatibility to fix issues or to add missing features.

## Togglable improvements

Most of the changes are individually selectable using the new tab in the `Options` menu in the Main Screen.
Once the game has been launched once, a new file storing the new settings will be created in the main SC saves directory, called `mod_config.ini`,
there it's possible to set all the new settings without the game and change some more experimental settings which do not have a corresponding entry in the in-game menu.

Default settings directory location:
* Windows: `C:\Users\<your user>\AppData\Local\Zachtronics Industries\Spacechem\mod_config.ini`
* Linux: `~/.local/share/Zachtronics Industries/SpaceChem/mod_config.ini`
* Mac: `~/.local/share/zachtronics industries/spacechem/mod_config.ini`

### GUI settings

* `AllowIllegalBondsInCustomPuzzles`: Allow bonds that exceed the bond limit of the participating atoms
  when editing input and output molecules in ResearchNet puzzles.
  Puzzle creators have been building unique puzzles like this for a while now,
  by editing the puzzle data manually, but with this patch, they can do it a bit more easily.  
  As a side effect, arbitrary bonds are also allowed in reactor output notes.
* `DeclassifyDefenses`: Shows the normal leaderboard/histograms on defenses, both after completion and on hover on the campaign screens,
  so that it's easy to see the stats.  
  Sadly the game has no histogram data for these levels, but the friends scores are visible.
* `DefaultDebondInDisassemblyReactors`: In disassembly reactors, the Bond+ instruction is always ignored because the bonders can only remove bonds in them.
  This setting replaces Bond+ with Bond- in the instruction toolbar for these reactors, so you don't need to manually switch them to the Bond- state.
* `ResNetProductionCustomAmount`: Allows changing the amount of outputs needed for ResNet production puzzles. The amount can be specified in
  the JSON, like for researches. The output count used by the game is 4x the amount in the file, to keep the 10 -> 40 behaviour of the vanilla game.
* `ReverseOrderCustomResNetAssignments`: The ResearchNet custom assignments are normally sorted by ascending creation date, meaning
  that you need to scroll the most to get to the latest puzzles. By enabling this patch, the order is reversed, so you can quickly open
  your most recent assignments and only need to scroll for the older ones.
* `AllowReactorRecordingInProduction`: When recording a production assignment,
  the game makes a video of the currently opened reactor like it would do in a research assignment,
  instead of a video of the whole pipeline, if you have a reactor open at the moment of completing the assignment.  
  This is useful to make intelligible videos of 1-reactor production assignments,
  or to record each reactor individually then splice them together in a video editing tool to share your full solution.
* `ConfirmExitRunningSimulation`: Controls if the confirmation dialog to exit a level is shown when trying to exit while the simulation is running.
* `IndicateWaldoDirection`: A visual indicator of the direction a waldo is travelling is drawn on the waldo.
  As of now, the indicator is a different color for the half on the back.
* `ResNetDuplicateCopiesSolution`: In ResearchNet custom assignments, the Duplicate button normally just duplicates the puzzle definition and
  lets you start with a blank solution. With this option enabled, the button will also duplicate the solution of the assignment if it's present.
  To duplicate the puzzle without the solution, you can still export to the clipboard and immediately import the result back while this feature is enabled.

### Experimental settings

The following settings do not have a corresponding entry in the in-game menu, modify at your risk:
* `SpeedSlow`:   cycles/sec for the 1st speed button
* `SpeedMedium`: cycles/sec for the 2nd speed button
* `SpeedFast`:        cycles/sec for the 3rd speed button in non-defense levels
* `SpeedFastDefense`: cycles/sec for the 3rd speed button in defense levels
* `SpeedWarp`:        cycles/sec for the 4th speed button in non-defense levels
* `SpeedWarpDefense`: cycles/sec for the 4th speed button in defense levels
* `SpeedDeltaCtrl`: extra cycles/sec added to the base speed if it's selected with Ctrl pressed
* `SpeedRecording`: cycles/sec for the video recordings

## Compatibility Notes

While the Community Edition allows extending the normal limits of ResearchNet research puzzles, it can't make the vanilla game load those "extended" puzzles properly.
In order not to confuse the vanilla game, and to prevent it from "fixing" the puzzle definition, these puzzles are saved with a custom type. The vanilla game
will assume they were created by a future version of SpaceChem, and won't let you edit or play them. While editing a research puzzle, the Community Edition will warn
you if your choices result in a puzzle not compatible with the vanilla game. These puzzles are still safe to create and share even if you switch back to the vanilla
version, they will just not be playable in that version.

In version 4.2 and earlier, such research puzzles weren't handled specially and the vanilla game "fixed" them (i.e. forced the feature counts into the usual bounds)
every time you opened the Custom Assignments screen. If you're upgrading from such a version, please make sure to open the Custom Assignments screen in the Community
Edition before opening it in the vanilla game. This will convert your puzzles where necessary, and will make sure no data loss happens in the future.

## Versioning

The goal of this edition is to keep up with the latest official version of the game while incorporating some new features. This is reflected in the version number as well. The format is `major.minor.patch`.
* The **major** version is always the last digit of the version number of the official game used as a starting point. The first released version is based on v1014, so its version number is 4.0.
* The **minor** version will get incremented whenever a new feature is added, or an existing feature is significantly changed.
* The **patch** version will get incremented whenever bugs get fixed without (intentionally) changing feature functionality.

## Authors

This project is developed by two authors:
* [csaboka](https://github.com/csaboka)
* [12345ieee](https://github.com/12345ieee)

Because of legal limitations, we can't accept help from other contributors. Feature requests and bug reports are welcome, however, using the Issues feature of Github.

## Acknowledgments

The authors would like to thank Zach Barth, the head of Zachtronics,
for allowing access to the source of the game to make this Community Edition possible.
