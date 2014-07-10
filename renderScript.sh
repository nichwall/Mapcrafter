backupDir=$"/home/nicholas/backupsTemp/outNamed"
mapperDir=$"/home/nicholas/minecraftRenders/mapcrafter/mapcrafter/src"
sourceDir=$"/home/nicholas/minecraftRenders/world/world1"
renderingDir=$"/home/nicholas/minecraftRenders/world"
outDir=$"/home/nicholas/minecraftRenders/world/renders"
saveLoc=$"/home/nicholas/minecraftRenders/world-renders"
world=$"world"

cd $backupDir
for i in */; do
	echo "	Starting $i"
	rm -r "$sourceDir/world"
	cp -r "$backupDir/$i$world" $sourceDir
	cd $mapperDir
	touch "$renderingDir/timeCreated.txt"
	# render
	./mapcrafter -c ~/minecraftRenders/world/config.txt -j 2
	# move to output of render
	cd $outDir
	# create new directory for render
	mkdir "$saveLoc/$i"

	# get changed file list
	cd "$outDir/map_myworld/tl"
	find "/home/nicholas/minecraftRenders/world/renders" -type f -newer "/home/nicholas/minecraftRenders/world/timeCreated.txt" > "/home/nicholas/minecraftRenders/world/fileList.txt"
	
	# loop through files and copy changes
	while read line; do
		cp --parents $line "$saveLoc/$i"
	done < "/home/nicholas/minecraftRenders/world/fileList.txt"
	# fix directory structure
	cd "$saveLoc/$i"
	cd "home/nicholas/minecraftRenders/world"
	cp -r renders/ "$saveLoc/$i"
	rm -r renders/
	# return to backups and clean up
	cd $backupDir
	# copy out backup files so renders with different views can be done later
	cp -r $i /home/nicholas/backupsTemp/oldStuff/
	rm -r $i
	echo "	Finishing $i"
done
