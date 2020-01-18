The main program is the "Team Growth" file (referenced as the "main" program). The "dataset District_Points" file (refernced as the "dataset" program) creates the dataset that the main file uses. This is done to reduce internet use. All the data is downloaded once, then any team can be analysed. All downloaded data is stored on the computer. It will take approximately 100KB of space (as of 2019), and will increase by about 20KB each year.

If you attempt to run the main program before running the dataset program, you will recieve the error "Config file not found." This can be fixed by running the dataset program once. The dataset program creates the config file, and downloads and write several .csv files.
When running the dataset program, a lot of data is downloaded. To speed up the process, R may not respond. Do not interupt the program by running any other code. Do not close R while running. This will interupt the program and you will not have a complete dataset. A message will be displayed upon completion. If the program does get interupted for any reason, simply run the program again. Any old files will be overwritten and the dataset will be completed.

Important: Make sure you set a working directory before using the dataset program. If you do not, this could result in a bunch of files being created in an inconvienient place.
Once you have a dataset, you may freely run the main program as many times as you wish.

When you run the main program, you will be prompted to enter a team number. If you enter an invalid team number, you will recieve an error and the program will stop. Otherwise, a graph will be plotted.
There will be a box and whisker plot created. It will have a red line representing your team chosen previously.

IMPORTANT: THIS GRAPH REPRESENTS TEAM GROWTH, NOT TEAM SCORE. It uses district points to determine this. Each point represents a team's improvement (which can be negative) since the previous season.

Important: The red line represents the team which you entered before. If the line (at the vertex) falls within the box for a given year, then that team has not improved or declined in to an extent of any signifigance. If the line falls within the bars above or below, but not within the box, then they are improving or declining. If their line is beyond the box and whisker plot, then they either were extremely lucky or unlucky, and those points are not of any signigance.

To update the dataset, simply run the dataset program again. This will overwrite the old files and create new ones.
I recommend not including any uncompleted seasons, as they are not a good representation of team ablity.
If you wish to remove any years from the dataset, you will need to delete those files with your file manager, and delete the config file as well. Then run the dataset program with the most recent season you want analysed, which will create a new config file.



Additional Notes:
There is currently no GUI for the program, other than the occasional pop-up window. If you're lucky I'll make one.
There is currently no actual prediction. I have no current plans to add any prediction. Humans are expected to interpret the data themselves.