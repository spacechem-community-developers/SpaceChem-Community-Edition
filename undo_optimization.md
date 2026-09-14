# Optimizing undo data in your save file

## Who should read this?

This document is for solving the very specific issue of oversized SpaceChem save files.
If your save file is well below the 95MB limit enforced by Steam, you can safely ignore everything explained here.

That said, if you *do* struggle with the size of your save file, now you have several options for improving it:

## Option 1: Optimize undo records

As you may have already seen in the README, Community Edition writes optimized undo records since version 7.1.
While normally this only affects newly written records, there is an option to rewrite your existing data
in order to get the same benefit for your complete undo history. You should expect no more than 10% improvement
from this, altough there is at least one player whose save file shrunk from around 160MB to 140MB, an almost 25% improvement.
People with smaller save files should expect more modest results.

To optimize your undo records, open your `mod_config.ini` file, look for the line saying `optimizeUndoOnStartup = False`
and replace `False` with `True`. Next time you start the game, a progress bar should appear on top of the
regular main menu as the game is updating your data. You can cancel it at any time, but it will resume its work at the
next startup until you restore the `optimizeUndoOnStartup` setting. You will probably want to do that once the work
is complete, but keeping the option permanently on could be useful if you plan to regularly switch between the vanilla
version and CE. The CE will optimize levels touched by the vanilla version on startup, leaving already optimized levels alone.

## Option 2: Limit your undo history

This is the "nuclear option". Instead of trying to shrink your data, you get rid of it, at least partially. To do this,
open your `mod_config.ini` file and look for the line `maxUndoDepth = -1`. Change the `-1` part to a positive number,
the number of undo entries you wish to keep per level. The next time you make changes to a level, the game will
**permanently wipe** old undo entries for that level, keeping only the specified amount. For example, if you set this
to 10, you will be able to click Undo at most ten times on a given level, after which it will get disabled, just like
it usually does when you reach the beginning of the history. Levels are not affected until you modify them while the
setting is in effect. Increasing the number will keep more entries in the future, but won't bring back entries already deleted.

**Please don't use this together with option 1**. The interaction between the rewriting process and the wiping process
is untested and not well understood.

## Option 3: Compress your undo records

This is the most involved option, but it can also give the best results for huge save files. In the most extreme known
case, someone could shrink their save file from 140MB down to 47MB with this option. **It's recommended to apply option 1 first**, as the
two approaches stack on each other, but option 3 can slow down the undo/redo operations that option 1 does in large quantities.

To get started, you will first need to get the SQLite command-line tools from https://sqlite.org/download.html . Make sure to
pick the precompiled binaries appropriate for your OS and architecture. On Linux, you can probably also get it from your
package manager, but figuring out the exact steps is up to you.

Next, you will need the file `compressed_undo.sql`, which should be next to the file you are reading right now.

Finally, open a command prompt and execute the following:<br>
`sqlite3 save_file_path < path_to_compressed_undo_sql`<br>
where `save_file_path` is the full path of the save file you need to shrink and `path_to_compressed_undo_sql` is the full
path of `compressed_undo.sql`. (If you extracted the command-line tools rather than installing them from your package manager,
you may also need to adjust your PATH variable or reference `sqlite3` with its full path.)
**You should back up your save file** before doing this, to be on the safe side.

If you ever change your mind, you should be able to restore the original save file schema by running
`compressed_undo_reset.sql` (which should also be next to this file) the same way you ran `compressed_undo.sql`.

### How it works

SpaceChem uses a generic undo/redo implementation that works directly at the database level, agnostic of any game logic that
makes the database changes. To achieve this, it stores SQL statements (INSERTs, UPDATEs and DELETEs) in its undo records,
each of which will counteract exactly one SQL statement from the original change. This results in a very space-inefficient
table that repeats SQL keywords as well as table and column names. Even numeric values need to be stored as text, in decimal, as
required by SQL syntax.

The storage is in fact so redundant that even a very simple compression scheme, one that replaces fixed words with one-byte
markers, can significantly decrease its size. Such a scheme can be implemented by a cascade of REPLACE functions directly in SQL.
Once we compress the existing data like this, we need to create a view that decompresses it on the fly, and two INSTEAD OF triggers
that compress new data as it arrives, and we can optimize the storage without the game noticing the change at all.

To improve things further, we also optimize the `level_id` column of the Undo table. This column contains redundant copies of level
names, when all we need is a unique integer level ID. We store the mapping between level names and integer IDs in a new table named
LevelNameDedup. When the game tries to access the Undo table (now actually a view), we do a join to substitute level names for the
integer IDs.

### Known issues

There is one known issue. The vanilla version of the game gets slightly confused by changes made to the tables introduced by the compression
scheme. As a result, when undoing or redoing a reactor change (such as switching waldo colors, locking layers or hiding layers), it
will send the player back to the pipeline view instead of opening the affected reactor. The change itself is otherwise undone or redone
properly. This may eventually get fixed whenever a new vanilla version is released, but in the meantime, you may want to stick to using
Community Edition when using a compressed save file.