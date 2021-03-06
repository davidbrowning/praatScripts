# Praat script to compute mean pitch of audio files in a specific directory
# Outcome is stored in a csv file
#
# Yoeri Nijs
# Master Thesis Human Aspects of Information Technology
# Tilburg University
#
# Based on the work of Jonas Lindh, 2005-2006
# http://www.ling.gu.se/~jonas/sounds/
# GNU General Public License

# Script form
form Compute pitch of audio files
	comment Directory of sound files
	text sound_directory C:\Users\sarai\Box Sync\Manuscripts\Prosody Project\ASD Analysis Project\Audio\001\Retell\Baseline\Clipped Audio Files\
	sentence Sound_extension .mp3
	comment Full path of text file with results
	text resultfile C:\Users\sarai\Box Sync\Manuscripts\Prosody Project\ASD Analysis Project\Audio\001\Retell\Baseline\results.csv
	comment Pitch analysis parameters
	positive Time_step 0.01
	positive Minimum_pitch_(Hz) 100
	positive Maximum_pitch_(Hz) 700
endform

# Create listing of all sound files
Create Strings as file list... list 'sound_directory$'*'sound_extension$'
numberFiles = Get number of strings

# Check if the result file already exists
if fileReadable (resultfile$)
	pause The resultfile 'resultfile$' already exists! Overwrite?
	filedelete 'resultfile$'
endif


# Create row with column titles to the result file
titleline$ = "Filename','Min','Max','Mean','Median','Std','Dur''newline$'"
fileappend "'resultfile$'" 'titleline$'

# Compute all the sound files
for ifile to numberFiles

	# Open audio file
	filename$ = Get string... ifile

	# Read file and retrieve details
	Read from file... 'sound_directory$''filename$'
	soundname$ = selected$ ("Sound", 1)
	dur = Get total duration
	To Pitch... time_step minimum_pitch maximum_pitch
	max = Get maximum... 0 0 Hertz None
	min = Get minimum... 0 0 Hertz None
	mean = Get mean... 0 0 Hertz
	median = Get quantile... 0 0 0.5 Hertz
	stdev = Get standard deviation... 0 0 Hertz
	altqb = Get quantile... 0 0 0.0764 Hertz
	baseline = mean - (1.43 * stdev)
	To PointProcess
	points = Get number of points
	Remove

	# Save result to csv file
	resultline$ = "'soundname$',''min:2'',''max:2'',''mean:2'',''median:2'',''stdev:2'',''dur:2'''newline$'"
	fileappend "'resultfile$'" 'resultline$'

	# Remove temp objects from object's list
	select Sound 'soundname$'
	plus Pitch 'soundname$'
	Remove
	select Strings list

	# Next audio file
endfor
Remove