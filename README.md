
# SpaceChem Community Edition

This project will replace your [SpaceChem](http://www.zachtronics.com/spacechem/) game executable to add new features to the game.

This project is the continuation of the [SpaceChem Community update (v1013)](https://steamcommunity.com/games/92800/announcements/detail/1737729728308220584), 
with more features added that are not either ready or polished enough to land in the official release of SpaceChem.

## Supported game versions

The only supported version is the Steam version of the game.
This is unlikely to change in the future, for legal reasons related to the game distribution.

## Installing the update

In the [Release Page](https://github.com/spacechem-community-developers/SpaceChem-Community-Edition/releases/latest) you'll find a `SpaceChem.exe` executable file.
This file needs to be placed in the Steam directory of SpaceChem, whose default path is:
* Windows: `C:\Program Files (x86)\Steam\steamapps\common\SpaceChem`
* Mac: `~/Library/Application Support/Steam/steamapps/common/SpaceChem`
* Linux `~/.steam/steam/steamapps/common/SpaceChem`

Overwrite the original file, it'll still be possible to recover it by verifying the game files via Steam.

## Available improvements

Other than a few general enhancement, most of the changes are individually selectable using the new tab in the `Options` menu in the Main Screen.
Once the game has been launched once, a new file storing the new settings will be created in the main SC saves directory, called `mod_config.ini`,
there it's possible to set all the new settings without the game and change some more experimental settings which do not have a corresponding entry in the in-game menu.

Default settings directory location:
* Windows: `C:\Users\<your user>\AppData\Local\Zachtronics Industries\Spacechem\mod_config.ini`
* Linux: `~/.local/share/Zachtronics Industries/SpaceChem/mod_config.ini`
* Mac: `~/.local/share/zachtronics industries/spacechem/mod_config.ini`

## Available settings

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
* `MoreFeaturesInResNetResearch`: Increase the upper limit of allowed reactor features in custom ResearchNet research puzzles.
  You can have up to 4 sensors, fusion lasers, fission lasers and quantum tunnels in a puzzle now.
  A Split instruction triggers all fission lasers in a reactor and a Fuse instruction triggers all fusion lasers.
  Sensing instructions will activate if any of the sensors detects the specified element.
  Quantum tunnels work in a "round-robin" fashion: tunnel #1 will teleport atoms to tunnel #2, tunnel #2 will teleport to tunnel #3 and so on,
  except for the highest-numbered tunnel, which will teleport to tunnel #1.  
  Please read the "Compatibility Notes" section below if you also want to run the original game alongside the modified version.
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
* `SctImportExport`: This feature allows exporting and importing custom ResearchNet solutions in the same format used by [SpaceChemTool](https://github.com/spacechem-community-developers/SpaceChemTool). This tool is used for easy sharing of puzzle solutions, especially during tournaments. Now you can select one of your custom puzzles and export its solution to your clipboard using the Export Solution button. Importing solutions is also possible by copying the solution text to your clipboard, selecting the puzzle whose solution you want to import, then clicking on Import Solution. Selecting a puzzle is necessary because SCT doesn't export the definition of the puzzle you're solving, but a puzzle definition is needed for importing. Importing a solution into a puzzle it wasn't created in may work in some cases, but will usually fail. **NOTE**: Import functionality isn't tested "in the wild" yet, and in the worst case, it may create broken solutions or even corrupt your save file. The risk is bigger if you import a solution for the "wrong" definition. Please back up your save file before importing to make sure you don't permanently lose data!

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

There is currently one setting that may cause compatibility issues with the vanilla game:

* When `MoreFeaturesInResNetResearch` is active, the puzzle descriptions used by the game are extended with new fields to store the selected feature counts.
  When the vanilla game loads these descriptions, it will ignore the new fields and enforce the old limits.
  When it's loading a puzzle solution, it will also remove the "extra" features it finds that are above the expected limits.  
  The result is, whenever you open the Custom Assignments screen in ResearchNet with the vanilla game, you will lose features in your existing solutions, and restoring those features is tricky at the moment.
  If you wish to switch between the vanilla and patched versions of the game, it's better to avoid opening this screen, or even to use different game profiles for the two versions.  
  Exporting puzzles should work normally, but if you publish your puzzle somewhere, please let the players know that they will need to use the Community Edition to be able to play the puzzle properly.
  The `MoreFeaturesInResNetResearch` is the only setting necessary, all others can stay disabled if the player prefers the original game behavior.

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
