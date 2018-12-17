@ECHO OFF

SETLOCAL

ECHO.
ECHO Bioshock Infinite benchmarking utility
ECHO.

REM Change into the executable directory so we can locate the executable by
REM name regardless of whether it is launched by specifying a relative path or
REM by running the batch file from the executable directory.

SET EXEDIR="%~dp0"
ECHO Changing to directory: %EXEDIR%
CD %EXEDIR%

REM Try and find the executable. This can be named different things depending on which configuration we're testing (ISO, local build, etc)
IF EXIST BioShockInfinite.exe (

	REM if shipping executable name is present, this must be a shipping Steam depot layout
	SET EXENAME=BioShockInfinite.exe
	SET SIMULATE_SHIPPING_BUILD=

) ELSE IF EXIST XGame.exe (

	SET EXENAME=XGame.exe
	SET SIMULATE_SHIPPING_BUILD=-simulateshippingbuild
	
) ELSE IF EXIST ShippingPC-XGame.exe (

	SET EXENAME=ShippingPC-XGame.exe
	SET SIMULATE_SHIPPING_BUILD=-simulateshippingbuild

) ELSE (
    ECHO.
    ECHO ERROR: Unable to determine appropriate executable in specified batchfile directory %EXEDIR%
    ECHO Aborting.
    PAUSE
    GOTO :EXIT
)

ECHO Found executable: %EXENAME%

SET EXTRA_CMDLINE_OPTIONS=-nosound -norumble -noPauseOnLossOfFocus -fullscreen -runfrombenchmarkbat %SIMULATE_SHIPPING_BUILD%

if "%TYPE%"=="/?" GOTO USAGE
if "%TYPE%"=="-?" GOTO USAGE
if "%TYPE%"=="-help" GOTO USAGE
if "%TYPE%"=="--help" GOTO USAGE

REM First command line arg should be the configuration to benchmark (high, med, low, etc)
SET TYPE=%1%
SET UNATTENDED=
SET RESX=
SET RESY=
SET USINGPARAM=
SET BENCHMARKFILE=
SET BENCHMARKFILENAME=
SET RESOLUTION=

REM Next commands can be -unattended, -resx=, -resy=, or -benchmarkfile= in any order.  To detect this we need to string together a series of if/else if blocks checking for each possible value at each argument location

if NOT "%2"=="" (
	if /i "%2"=="-resx" (
		SET RESX=%3
		SET USINGPARAM=3
	) ELSE (
		if /i "%2"=="-resy" (
			SET RESY=%3
			SET USINGPARAM=3
		) ELSE (
			if /i "%2"=="-unattended" (
				SET UNATTENDED=-unattended
			) ELSE (
				if /i "%1"=="-benchmarkfile" (
					SET BENCHMARKFILE=%3
					SET USINGPARAM=3
				) ELSE (
					GOTO USAGE
				)
			)
		)
	)
)

if NOT "%3"=="" (
	if /i "%3"=="-resx" (
		SET RESX=%4
		SET USINGPARAM=4
	) ELSE (
		if /i "%3"=="-resy" (
			SET RESY=%4
			SET USINGPARAM=4
		) ELSE (
			if /i "%3"=="-unattended" (
				SET UNATTENDED=-unattended
			) ELSE (
				if /i "%3"=="-benchmarkfile" (
					SET BENCHMARKFILE=%4
					SET USINGPARAM=4
				) ELSE (
					if NOT "%USINGPARAM%"=="3" (
						GOTO USAGE
					)
				)
			)
		)
	)
)

if NOT "%4"=="" (
	if /i "%4"=="-resx" (
		SET RESX=%5
		SET USINGPARAM=5
	) ELSE (
		if /i "%4"=="-resy" (
			SET RESY=%5
			SET USINGPARAM=5
		) ELSE (
			if /i "%4"=="-unattended" (
				SET UNATTENDED=-unattended
			) ELSE (
				if /i "%4"=="-benchmarkfile" (
					SET BENCHMARKFILE=%5
					SET USINGPARAM=5
				) ELSE (
					if NOT "%USINGPARAM%"=="4" (
						GOTO USAGE
					)
				)
			)
		)
	)
)

if NOT "%5"=="" (
	if /i "%5"=="-resx" (
		SET RESX=%6
		SET USINGPARAM=6
	) ELSE (
		if /i "%5"=="-resy" (
			ECHO FOUND RESY AT 5 SETTING RESY TO %6
			SET RESY=%6
			SET USINGPARAM=6
		) ELSE (
			if /i "%5"=="-unattended" (
				SET UNATTENDED=-unattended
			) ELSE (
				if /i "%5"=="-benchmarkfile" (
					SET BENCHMARKFILE=%6
					SET USINGPARAM=6
				) ELSE (
					if NOT "%USINGPARAM%"=="5" (
						GOTO USAGE
					)
				)
			)
		)
	)
)

if NOT "%6"=="" (
	if /i "%6"=="-resx" (
		SET RESX=%7
		SET USINGPARAM=7
	) ELSE (
		if /i "%6"=="-resy" (
			SET RESY=%7
			SET USINGPARAM=7
		) ELSE (
			if /i "%6"=="-unattended" (
				SET UNATTENDED=-unattended
			) ELSE (
				if /i "%6"=="-benchmarkfile" (
					SET BENCHMARKFILE=%7
					SET USINGPARAM=7
				) ELSE (
					if NOT "%USINGPARAM%"=="6" (
						GOTO USAGE
					)
				)
			)
		)
	)
)

if NOT "%7"=="" (
	if /i "%7"=="-resx" (
		SET RESX=%8
		SET USINGPARAM=8
	) ELSE (
		if /i "%7"=="-resy" (
			SET RESY=%8
			SET USINGPARAM=8
		) ELSE (
			if /i "%7"=="-unattended" (
				SET UNATTENDED=-unattended
			) ELSE (
				if /i "%7"=="-benchmarkfile" (
					SET BENCHMARKFILE=%8
					SET USINGPARAM=8
				) ELSE (
					if NOT "%USINGPARAM%"=="7" (
						GOTO USAGE
					)
				)
			)
		)
	)
)

if NOT "%8"=="" (
	if /i "%8"=="-resx" (
		SET RESX=%9
		SET USINGPARAM=9
	) ELSE (
		if /i "%8"=="-resy" (
			SET RESY=%9
			SET USINGPARAM=9
		) ELSE (
			if /i "%8"=="-unattended" (
				SET UNATTENDED=-unattended
			) ELSE (
				if /i "%8"=="-benchmarkfile" (
					SET BENCHMARKFILE=%9
					SET USINGPARAM=9
				) ELSE (
					if NOT "%USINGPARAM%"=="8" (
						GOTO USAGE
					)
				)
			)
		)
	)
)

REM Can't have an 9th param unless it's a res param
if NOT "%9"=="" (
	if NOT "%USINGPARAM"=="9" (
		GOTO USAGE
	)
)

:VALIDATE_CONFIG


REM Combine our resolution parameters
if NOT "%RESX%"=="" (
SET RESOLUTION=-resx=%RESX%
)

if NOT "%RESY%"=="" (
SET RESOLUTION=%RESOLUTION% -resy=%RESY%
)

if NOT "%BENCHMARKFILE%"=="" (
SET BENCHMARKFILENAME=-benchmarkfile=%BENCHMARKFILE%
)

if "%TYPE%"=="User" (
REM We don't pass an ini override when using the user's default settings
SET COMPAT_LEVEL=
GOTO START_BENCHMARK
) 

if /i "%TYPE%"=="VeryLow" (
SET COMPAT_LEVEL=-ForceCompatLevel=1
GOTO START_BENCHMARK
) 

if /i "%TYPE%"=="Low" (
SET COMPAT_LEVEL=-ForceCompatLevel=2
GOTO START_BENCHMARK
) 

if /i "%TYPE%"=="Medium" (
SET COMPAT_LEVEL=-ForceCompatLevel=3
GOTO START_BENCHMARK
) 

if /i "%TYPE%"=="High" (
SET COMPAT_LEVEL=-ForceCompatLevel=4
GOTO START_BENCHMARK
) 

if /i "%TYPE%"=="VeryHigh" (
SET COMPAT_LEVEL=-ForceCompatLevel=5
GOTO START_BENCHMARK
) 

if /i "%TYPE%"=="UltraDX11" (
SET COMPAT_LEVEL=-ForceCompatLevel=6
GOTO START_BENCHMARK
) 

if /i "%TYPE%"=="UltraDX11_DDOF" (
SET COMPAT_LEVEL=-ForceCompatLevel=7
GOTO START_BENCHMARK
) 

: PROMPT_FOR_CONFIG 

REM --- if user didn't pass in a configuration, prompt them to choose one. If they passed in an unknown config, log out the command line params
if NOT "%TYPE%"=="" GOTO USAGE

ECHO.
ECHO Running benchmark selection in interactive mode.
ECHO Note: you can run "%0% -help" to see the supported benchmarking command-line options for automated benchmarking.
ECHO.
ECHO ----------------------------------------------
ECHO.
ECHO Please choose the graphics quality settings to benchmark:
ECHO.
ECHO 	1: User			(Current Settings)
ECHO 	2: UltraDX11_DDOF	(DX11-only, same as UltraDX11 but with Diffusion Depth of Field)
ECHO 	3: UltraDX11		(DX11-only)
ECHO 	4: VeryHigh		(Note: DX10 and DX11 hardware use different techniques on this setting, so do not compare results)
ECHO 	5: High
ECHO 	6: Medium
ECHO 	7: Low
ECHO 	8: VeryLow
ECHO.
CHOICE /N /C:12345678 /M "Desired graphics quality:"%1

IF ERRORLEVEL ==8 (
SET TYPE=VeryLow
GOTO PROMPT_FOR_CURRENT_DISPLAY_SETTINGS_OR_CUSTOM
)

IF ERRORLEVEL ==7 (
SET TYPE=Low
GOTO PROMPT_FOR_CURRENT_DISPLAY_SETTINGS_OR_CUSTOM
)

IF ERRORLEVEL ==6 (
SET TYPE=Medium
GOTO PROMPT_FOR_CURRENT_DISPLAY_SETTINGS_OR_CUSTOM
)

IF ERRORLEVEL ==5 (
SET TYPE=High
GOTO PROMPT_FOR_CURRENT_DISPLAY_SETTINGS_OR_CUSTOM
)

IF ERRORLEVEL ==4 (
SET TYPE=VeryHigh
GOTO PROMPT_FOR_CURRENT_DISPLAY_SETTINGS_OR_CUSTOM
)

IF ERRORLEVEL ==3 (
SET TYPE=UltraDX11
GOTO PROMPT_FOR_CURRENT_DISPLAY_SETTINGS_OR_CUSTOM
)

IF ERRORLEVEL ==2 (
SET TYPE=UltraDX11_DDOF
GOTO PROMPT_FOR_CURRENT_DISPLAY_SETTINGS_OR_CUSTOM
)

IF ERRORLEVEL ==1 (
SET TYPE=User
GOTO PROMPT_FOR_CURRENT_DISPLAY_SETTINGS_OR_CUSTOM
)

REM -- return code of 0 from choice command indicates user pressed control-c or control-break
IF ERRORLEVEL ==0 (
GOTO :EXIT
)

REM Keep looping around until user chooses a valid value
GOTO :PROMPT_FOR_CONFIG

: PROMPT_FOR_CURRENT_DISPLAY_SETTINGS_OR_CUSTOM

ECHO.
ECHO ----------------------------------------------
ECHO.
ECHO Would you like to choose a custom resolution, or use your current user settings?
ECHO.
ECHO 	1: User (Current Settings)
ECHO 	2: Custom

ECHO.
CHOICE /N /C:12 /M "Current or custom:"%1

IF ERRORLEVEL ==2 (
GOTO PROMPT_FOR_ASPECT_RATIO
)

IF ERRORLEVEL ==1 (
SET RESX=
SET RESY=
GOTO VALIDATE_CONFIG
)

REM -- return code of 0 from choice command indicates user pressed control-c or control-break
IF ERRORLEVEL ==0 (
GOTO :EXIT
)

REM Keep looping around until user chooses a valid value
GOTO :PROMPT_FOR_CURRENT_DISPLAY_SETTINGS_OR_CUSTOM

: PROMPT_FOR_ASPECT_RATIO

ECHO.
ECHO ----------------------------------------------
ECHO.
ECHO Please choose a display aspect ratio 
ECHO.
ECHO Aspect ratios:
ECHO.
ECHO 	1: 16:9
ECHO 	2: 16:10
ECHO 	3: 4:3

ECHO.
CHOICE /N /C:123 /M "Desired aspect ratio:"%1

IF ERRORLEVEL ==3 (
GOTO PROMPT_FOR_RESOLUTION_4_3
)

IF ERRORLEVEL ==2 (
GOTO PROMPT_FOR_RESOLUTION_16_10
)

IF ERRORLEVEL ==1 (
GOTO PROMPT_FOR_RESOLUTION_16_9
)

REM -- return code of 0 from choice command indicates user pressed control-c or control-break
IF ERRORLEVEL ==0 (
GOTO :EXIT
)

REM Keep looping around until user chooses a valid value
GOTO :PROMPT_FOR_ASPECT_RATIO

: PROMPT_FOR_RESOLUTION_16_9

ECHO.
ECHO ----------------------------------------------
ECHO.
ECHO Please choose a resolution to benchmark. 
ECHO.
ECHO Available Resolutions:
ECHO.
ECHO 	1: 1280 x 720	(16:9, 720p HD)
ECHO 	2: 1366 x 768	(16:9)
ECHO 	3: 1600 x 900	(16:9)
ECHO 	4: 1920 x 1080	(16:9, 1080p HD)
ECHO 	5: 2560 x 1440	(16:9)
ECHO.
ECHO Please note: resolutions that not supported natively by your display will prevent the benchmark from executing.
ECHO.
CHOICE /N /C:12345 /M "Desired resolution:"%1


IF ERRORLEVEL ==5 (
SET RESX=2560
SET RESY=1440
GOTO VALIDATE_CONFIG
)

IF ERRORLEVEL ==4 (
SET RESX=1920
SET RESY=1080
GOTO VALIDATE_CONFIG
)

IF ERRORLEVEL ==3 (
SET RESX=1600
SET RESY=900
GOTO VALIDATE_CONFIG
)

IF ERRORLEVEL ==2 (
SET RESX=1366
SET RESY=768
GOTO VALIDATE_CONFIG
)

IF ERRORLEVEL ==1 (
SET RESX=1280
SET RESY=720
GOTO VALIDATE_CONFIG
)

REM -- return code of 0 from choice command indicates user pressed control-c or control-break
IF ERRORLEVEL ==0 (
GOTO :EXIT
)

REM Keep looping around until user chooses a valid value
GOTO :PROMPT_FOR_RESOLUTION_16_9

: PROMPT_FOR_RESOLUTION_16_10

ECHO.
ECHO ----------------------------------------------
ECHO.
ECHO Please choose a resolution to benchmark. 
ECHO.
ECHO Available Resolutions:
ECHO.
ECHO 	1: 1280 x 800	(16:10)
ECHO 	2: 1440 x 900	(16:10)
ECHO 	3: 1680 x 1050	(16:10)
ECHO 	4: 1920 x 1200	(16:10)
ECHO 	5: 2560 x 1600	(16:10)
ECHO.
ECHO Please note: resolutions that not supported natively by your display will prevent the benchmark from executing.
ECHO.
CHOICE /N /C:12345 /M "Desired resolution:"%1


IF ERRORLEVEL ==5 (
SET RESX=2560
SET RESY=1600
GOTO VALIDATE_CONFIG
)

IF ERRORLEVEL ==4 (
SET RESX=1920
SET RESY=1200
GOTO VALIDATE_CONFIG
)

IF ERRORLEVEL ==3 (
SET RESX=1680
SET RESY=1050
GOTO VALIDATE_CONFIG
)

IF ERRORLEVEL ==2 (
SET RESX=1440
SET RESY=900
GOTO VALIDATE_CONFIG
)

IF ERRORLEVEL ==1 (
SET RESX=1280
SET RESY=800
GOTO VALIDATE_CONFIG
)

REM -- return code of 0 from choice command indicates user pressed control-c or control-break
IF ERRORLEVEL ==0 (
GOTO :EXIT
)

REM Keep looping around until user chooses a valid value
GOTO :PROMPT_FOR_RESOLUTION_16_10

: PROMPT_FOR_RESOLUTION_4_3

ECHO.
ECHO ----------------------------------------------
ECHO.
ECHO Please choose a resolution to benchmark. 
ECHO.
ECHO Available Resolutions:
ECHO.
ECHO 	1: 640 x 480	(4:3)
ECHO 	2: 800 x 600	(4:3)
ECHO 	3: 1280 x 1024	(4:3)
ECHO 	4: 1600 x 1200	(4:3)
ECHO.
ECHO Please note: resolutions that not supported natively by your display will prevent the benchmark from executing.
ECHO.
CHOICE /N /C:1234 /M "Desired resolution:"%1


IF ERRORLEVEL ==4 (
SET RESX=1600
SET RESY=1200
GOTO VALIDATE_CONFIG
)

IF ERRORLEVEL ==3 (
SET RESX=1280
SET RESY=1024
GOTO VALIDATE_CONFIG
)

IF ERRORLEVEL ==2 (
SET RESX=800
SET RESY=600
GOTO VALIDATE_CONFIG
)

IF ERRORLEVEL ==1 (
SET RESX=640
SET RESY=480
GOTO VALIDATE_CONFIG
)

REM -- return code of 0 from choice command indicates user pressed control-c or control-break
IF ERRORLEVEL ==0 (
GOTO :EXIT
)

REM Keep looping around until user chooses a valid value
GOTO :PROMPT_FOR_RESOLUTION_4_3
    
:START_BENCHMARK

SET BENCHMARK_COMMAND=%EXENAME% DefaultPCBenchmarkMap.xcmap %COMPAT_LEVEL% %UNATTENDED% %RESOLUTION% %BENCHMARKFILENAME% %EXTRA_CMDLINE_OPTIONS%

ECHO.
ECHO ----------------------------------------------
ECHO.
ECHO Benchmark will use configuration: %TYPE% 
ECHO.
ECHO Starting benchmark with command line: %BENCHMARK_COMMAND%
ECHO.

%BENCHMARK_COMMAND%

GOTO :EXIT 

:USAGE

REM print the expected form of usage
ECHO.
ECHO =========================================================================================
ECHO.
ECHO.
ECHO Normal Expected Usage:
ECHO -----------------------
ECHO.
ECHO. Either run '%0%' by itself, for choosing benchmark settings interactively, or run
ECHO.
ECHO    %0 {CONFIG} {-RESX=width -RESY=height} {-BENCHMARKFILE=filename} {-UNATTENDED}
ECHO.
ECHO "CONFIG"
ECHO    Chooses the settings to use during benchmarking. 
ECHO    Must be one of the following: User, UltraDX11_DDOF, UltraDX11, VeryHigh, High, Medium, Low, VeryLow
ECHO    'User' means "use the users current settings without modification"
ECHO.
ECHO "-UNATTENDED"
ECHO    an optional argument; if present, makes the benchmark exit when finished without requiring user interaction
ECHO.
ECHO "-RESX=value"
ECHO    an optional argument; if present, sets the X resolution to this value
ECHO.
ECHO "-RESY=value"
ECHO    an optional argument; if present, sets the Y resolution to this value
ECHO.
ECHO "-BENCHMARKFILE=filename"
ECHO    an optional argument; if present, use this as the file name for the ouput file
ECHO.
ECHO   Examples:
ECHO.
ECHO      %0% 
ECHO      %0% VeryHigh
ECHO      %0% UltraDX11 -unattended
ECHO      %0% High -unattended -resx=1920 -resy=1080
ECHO      %0% Low -resx=1024 -resy=768 -benchmarkfile=LowSettings.csv
ECHO.
ECHO.
ECHO =========================================================================================
ECHO.
ECHO.
ECHO For custom automation support:
ECHO ------------------------------
ECHO.
ECHO    %EXENAME% DefaultPCBenchmarkMap.xcmap -defengineini="RELATIVE_PATH_TO_SETTINGS_INI_FILE" -unattended %EXTRA_CMDLINE_OPTIONS%
ECHO.
ECHO RELATIVE_PATH_TO_SETTINGS_INI_FILE
ECHO    A relative path from %EXENAME% to an INI file that inherits from DefaultEngine.ini and contains  
ECHO    specific options to apply during benchmarking. For an example that includes all configurable 
ECHO    custom graphics options. An example file can be found at "..\XGame\Config\Benchmarking\ExampleBenchmarkOptions.ini" 
ECHO.
ECHO.
ECHO =========================================================================================
ECHO.

REM if user passed arguments, print them here for reference so they know why the script isn't launching and then pause so they can compare to the expected usage
if NOT "%*"=="" (

ECHO.
ECHO You launched this script using the following command line:
ECHO.
ECHO    %0 %* 
ECHO.
ECHO If it did not execute correctly, please make sure the arguments are correct. 
ECHO If you are launching from the Steam client, please make ensure that you did
ECHO not add any entries to the "Launch Options" in the Steam client properties.
ECHO.
ECHO.

PAUSE
ECHO.
)

:EXIT
