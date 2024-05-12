# Turbo Pascal

This brief page documents how to get started with Turbo Pascal 3.00A, compiling a hello-world program.

To get started run:

     P> turbo

You should now be looking at the Turbo Pascal splash screen, showing the version, copyright message and which terminal is configured. At the bottom you'll be asked whether you want to `Include error messages`. For the moment press `Y`.

Now you will be presented with the main screen. You have a number of commands on this screen, which are accessed by a single letter as indicated by the `(X)` brackets:

     Logged drive: P

     Work file:
     Main file:

     (E)dit     (C)ompile  (R)un   (S)ave

     e(X)ecute  (D)ir      (Q)uit  compiler (O)ptions

     Text:     0 bytes (8118-8118)
     Free: 22253 bytes (8119-D806)

     >

The first thing you should do is to configure things to actually generate `.com` files when you run the compilation step.  Start by pressing `O` to choose the `compiler Options`, which will show you this:

     compile -> Memory
           Com-file
           cHn-file

     Find run-time error  Quit

Choose `Com-file` by pressing `C`, then press `Q` to go back to the main-menu.  If the main menu doesn't appear press `?`.

Now you can launch the editor by pressing `E`.  You'll be prompted for a file to edit, so you can choose something like "steve.pas".  Enter the following program:


           Line 1    Col 1   Insert    Indent  A:STEVE.PAS
       program Hello;
       begin
         writeln ('Hello, world.');
       end.

Now you can exit the editor by pressing `Ctrl-k d`, once again you'll be at the main-menu.  If that doesn't appear press `?`.

Compile your work by pressing `C`:

       >

       Compiling  --> A:STEVE.COM
         5 lines

       Code:    54 bytes (20E2-2118)
       Free: 47009 bytes (2119-D8BA)
       Data:   135 bytes (D8BB-D942)


Press `Q` to exit the environment, and you'll then be able to execute your binary:

     P> STEVE
     Hello, world.


## Keybindings

Keybindings within the editor-environment are based on those used in Wordstar, the following reference is a useful resource:

* http://www.wordstar.org/index.php/wsdos-documentation/wsdos-commands/108-wordstar-3-for-dos-commands-reference
