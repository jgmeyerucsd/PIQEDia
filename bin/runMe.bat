@echo off


set CurrentDir=%CD%

:: starting to modify for orbidata
:: set this to yes to compile the files as the program executes
set CompileJava=yes

:check_which_input
set /p checkInput= Do you have a parameters file for the runMe (ex: ***.parameters) [y/n]: 
IF "%checkInput%"=="y" goto enter_param_file
IF "%checkInput%"=="Y" goto enter_param_file
IF "%checkInput%"=="yes" goto enter_param_file
IF "%checkInput%"=="Yes" goto enter_param_file
IF "%checkInput%"=="n" goto get_info
IF "%checkInput%"=="N" goto get_info
IF "%checkInput%"=="no" goto get_info
IF "%checkInput%"=="No" goto get_info
goto scratch_dir


:get_info
echo:
echo Fill in all the fields.
echo:
IF "%CompileJava%"=="yes" javac GetInput.java
	java GetInput
	::GetInput.jar
IF "%CompileJava%"=="yes" rm *.class
	echo running again with the parameters entered.
	runMe.bat < input.parameters


:scratch_dir
echo:
echo:
echo:
echo:
echo:
echo General Information...
set /p ScratchDir= Enter scratch dir (contains only wiff files): 
echo:



:output_dir
set /p OutputDir= Enter output directory (contains all other files): 
echo:



:number_threads
set /p NumOfThreads= Enter the number of threads on this machine: 
echo:



:amount_ram
set /p AmountOfRam= Enter the amount of ram on this machine: 
echo:



:absciex_ms_convert_exe
echo:
echo:
echo For DiaUmpire Pipeline...
set /p ABSCIEXMSConvertExe= Enter the full path to AB_SCIEX_MS_Convert.exe: 
echo:


:ms_convert_exe
set /p MSConvertExe= Enter the full path to msconvert.exe: 
echo:



:indexmxXML_exe
set /p IndexMZXMLExe= Enter the full path to indexmzXML.exe: 
echo:



:DIA_Umpire_SE_jar
set /p DIAUmpireSEJar= Enter the full path to DIA_Umpire_SE.jar: 
echo:


:MzxmlToMgf_Params
set /p MzxmlToMgfParams= Enter the full path to the .params file use in the .mzxml to .mgf conversion: 
echo:



:msgfplusJar_dir
echo:
echo:
echo For MSGF search...
set /p MsgfplusJarDir= Enter the location of the msgfplus.jar file: 
echo:



:fasta_dir
set /p FastaDir= Enter the location of the .fasta file (ex: C:\...\2015_mouse_sprot.cc.fasta): 
echo:



:enter_ppm
set /p Ppm= Enter ppm (ex: 25ppm): 
echo:



:enter_e
set /p Enzyme= Enter -e "enzyme" (ex: 5): 
echo:



:enter_mods_file
set /p ModsFileLocation= Enter the location of the mods .txt file (ex: C:\...\Mods_acetyl.txt): 
echo:



:enter_ntt
set /p Ntt= Enter the ntt (-ntt): 
echo:



:enter_ti
set /p Ti= Enter the ti (-ti): 
echo:



:tandem_exe
echo:
echo:
echo For X!Tandem search...
set /p TandemExe= Enter the full path to tandem.exe: 
echo:



:tandem2XML_exe
set /p Tandem2XMLExe= Enter the full path to tandem2xml.exe: 
echo:



:enter_params.xml
set /p ParamsXml= Enter the path of the _params.xml file (ex: C:\...\tandem_Ksuc_params.xml): 
echo:


:enter_taxonomy.txt
set /p TaxonomyTxt= Enter the path of the _taxonomy.xml file (ex: C:\...\taxonomy.txt): 
echo:



:comet_exe
echo:
echo:
echo For comet search...
set /p CometSearchExe= Enter the full path to comet.exe: 
echo:



:comet_params
set /p CometParamsFile= Enter the full path to comet .params file: 
echo:



:comet_fasta
set /p CometFastaFile= Enter the full path to comet .fasta file: 
echo:



:peptide_prophet_info
echo:
echo:
echo For Peptide Prophet and iProphet...
set /p XinteractExe= Enter the full path to xinteract.exe: 
echo:



:iProphet_info
set /p InterProphetParserExe= Enter the full path to InterProphetParser.exe: 
echo:



:SkylineRunner_Exe
echo:
echo:
echo For Skyline
set /p SkylineRunnerExe= Enter the full path to SkylineRunner.exe: 
echo:



:Report_Name
set /p ReportName= Enter a report name for the skyline output: 
echo:



:Skyline_Fasta
set /p SkylineFasta= Enter the full path to the Skyline .fasta file: 
echo:



:SkylineTemplateDoc_Text
set /p SkylineTemplateDoc= Enter the full path to the Skyline template doc file: 
echo:



:SkylineXMLFile_Text
set /p SkylineXMLFile= Enter the full path to the Skyline .xml file: 
echo:



:ptmProphetParser_Exe
echo:
echo:
echo For PTMProphetParser
set /p ptmProphetParserExe= Enter the full path to PTMProphetParser.exe: 
echo:



:PTMProphetParser_Masses
set /p PTMProphetParserMasses= Enter the masses in this format- K,#,M,#,nQ,#: 
echo:



:PTMProphetParser_MZTOL
set /p PTMProphetParserMZTOL= Enter the MZTOL: 
echo:



:PTMProphetParser_MINPROB
set /p PTMProphetParserMINPROB= Enter the MINPROB: 
echo:



:MapDIA_Labels
echo:
echo:
echo For Map DIA...
set /p MapDIALabels= Enter the LABELS for mapDIA: 
echo:



:MapDIA_input_Text
set /p MapDIA_inputText= Enter the INPUT for mapDIA: 
echo:



:MapDIA_wiffFiles_Dir
set /p MapDIA_wiffFilesDir= Enter the wiff files directory for mapDIA: 
echo:



:MapDIA_masses
set /p MapDIAmasses= Enter the masses for mapDIA: 
echo:



:MapDIA_min_PtmProphet
set /p MapDIA_minPtmProphet= Enter the min ptm prophet score for mapDIA: 
echo:



:MapDIA_Skyline_Report
set /p MapDIA_SkylineReport= Enter the Skyline Report for mapDIA: 
echo:


:MapDIA_PTM_Prophet_Report
set /p MapDIA_PTM_ProphetReport= Enter the PTM Prophet Report for mapDIA: 
echo:



:find_what_to_run
echo:
echo:
set /p RunDiaUmpirePipe= Do you want to run diaUmpire_pipe.py [true/false] : 
echo:
set /p RunMSGFSearch= Do you want to run the MSGF search [true/false] : 
echo:
set /p RunXTandemSearch= Do you want to run the XTandem search [true/false] : 
echo:
set /p RunCometSearch= Do you want to run the Comet search [true/false] : 
echo:
set /p RunProphet= Do you want to run Peptide Prophet and IProphet [true/false] : 
echo:
set /p RunSkyline= Do you want to run Skyline [true/false] : 
echo:
set /p RunPTMProphetParser= Do you want to run PTMProphetParser [true/false] : 
echo:
set /p RunMapDia= Do you want to run map DIA [true/false] : 
echo:
echo:
echo:
echo:
echo:



:default
cp -f input.parameters %OutputDir%



:run_DiaUmipre_Pipe
IF "%RunDiaUmpirePipe%"=="true" (
	cd %ScratchDir%
	IF exist *.wiff (
		echo|set /p=Copying .wiff files.  -  
		time /T
		echo --------------------
		echo:
		cp -rf *.wiff %OutputDir%
		cp -rf *.wiff.scan %OutputDir%
	) ELSE (
		echo:
	)
	IF exist *.raw (
		echo|set /p=Copying .raw files.  -  
		time /T
		echo --------------------
		echo:
		cp -rf *.raw %OutputDir%
	) ELSE (
		echo:
	)
		

	cd %OutputDir%
	IF exist *.mzml (
		cd %CurrentDir%
		echo|set /p=Delete all mzml files and run again  -  
		time /T
		echo -----------------------------------
		echo:
		echo:
		echo:
		goto end_process
	) ELSE (
		echo:
	)

	cd %CurrentDir%
	cd %OutputDir%
	echo|set /p=Running the DiaUmpire pipeline.  -  
	time /T
	echo|set /p=looking for .wiff files
	IF exist *.wiff (
		echo -------------------------------
		echo:
		echo|set /p=Converting .wiff files to .mzml  -  
		time /T
		echo -------------------------------
		echo:
		cd %CurrentDir%
		IF "%CompileJava%"=="yes" javac CreateWiffToMzml.java
		java CreateWiffToMzml %OutputDir% %CurrentDir% "%ABSCIEXMSConvertExe%"
		IF "%CompileJava%"=="yes" rm CreateWiffToMzml.class
		cd %OutputDir%
		call WiffToMzml.bat
		cd %CurrentDir%

		echo|set /p=Converting .mzml files to .mzXML  -  
		time /T
		echo --------------------------------
		echo:
		IF "%CompileJava%"=="yes" javac CreateMzmlToMzxml.java
		java CreateMzmlToMzxml %OutputDir% %CurrentDir% "%MSConvertExe%"
		IF "%CompileJava%"=="yes" rm CreateMzmlToMzxml.class
		cd %OutputDir%
		call MzmlToMzxml.bat
		cd %CurrentDir%

		echo|set /p=.wiff file conversions completed.  -  
		time /T
		echo ----------------------------------
		echo:
	) ELSE (
		echo:
		echo|set /p=no .wiff files found
		echo:
	)
	echo|set /p=looking for .raw files
	echo:
	echo ---------------------------------------
	echo:
	echo %CurrentDir%
	echo:
	IF exist *.raw (
		IF exist *.mzXML (
			echo|set /p=using .mzXML files present in dir
			echo:
			echo ----------------------------------
			echo:
			echo|set /p= to re-convert delete .mzXML files
			echo:
			echo ----------------------------------
			echo:
		) ELSE (
			echo|set /p=Converting .raw files to .mzXML  -  
			echo ----------------------------------
			echo:
			cd %CurrentDir%
			IF "%CompileJava%"=="yes" javac CreateRawToMzxml.java
			java CreateRawToMzxml %OutputDir% %CurrentDir% "%MSConvertExe%"
			IF "%CompileJava%"=="yes" rm CreateRawToMzxml.class
			cd %OutputDir%
			call RawToMzxml.bat
			cd %CurrentDir%
			echo|set /p=.RAW file conversions completed.  -  
			time /T
			echo ----------------------------------
			echo:
		)
	) ELSE (
		echo:
		echo|set /p=no .raw files found
		echo ----------------------------------
		echo:
	)

	IF exist *Q1.mgf (
		pause
		echo|set /p=DIA-umpire results found
		echo:
		echo ----------------------------------
		echo:
		echo|set /p= to re-run DIA-umpire delete results
		echo:
		echo ----------------------------------
		echo:
	) ELSE (
		cd %CurrentDir%
		echo|set /p= Running DIA-Umpire SE
		echo:
		echo ----------------------------------
		C:\python27\python.exe diaUmpire_pipe.py %OutputDir% "%MSConvertExe%" "%IndexMZXMLExe%" "%DIAUmpireSEJar%" "%MzxmlToMgfParams%"
		echo:
		echo|set /p=DIA-Umpire SE complete, converting .mgf to .mzXML
		echo:
		echo ----------------------------------
	)
	cd %CurrentDir%
	IF "%CompileJava%"=="yes" javac CreateMgfToMzxml.java
	java CreateMgfToMzxml %OutputDir% %CurrentDir% "%MSConvertExe%"
	IF "%CompileJava%"=="yes" rm CreateMgfToMzxml.class
	cd %OutputDir%
	call CreateMgfToMzxml.bat
	cd %CurrentDir%
	echo|set /p=completed file conversions  -  
	time /T
	echo -----------------------------
	echo:
	echo:
	pause
) ELSE (
	echo|set /p=The DiaUmpire pipeline did not run.  -  
	time /T
	echo -----------------------------------
	echo:
)

goto run_MSGFSearch



:run_MSGFSearch
IF "%RunMSGFSearch%"=="true" (
	echo|set /p=Running the MSGF search.  -  
	time /T
	echo ------------------------
	echo:

	echo|set /p=Creating MSGF.parameters file.  -  
	time /T
	echo ------------------------------
	echo:
	echo "%OutputDir%" > MSGF.parameters
	echo "%FastaDir%" >> MSGF.parameters
	echo "%ppm%" >> MSGF.parameters
	echo "%enzyme%" >> MSGF.parameters
	echo "%modsFileLocation%" >> MSGF.parameters
	echo "%MsgfplusJarDir%" >> MSGF.parameters
	echo "%NumOfThreads%" >> MSGF.parameters
	echo "%Ntt%" >> MSGF.parameters
	echo "%Ti%" >> MSGF.parameters
	echo "%AmountOfRam%" >> MSGF.parameters
	
	echo|set /p=Creating MSGF .bat file.  -  
	time /T
	echo ------------------------
	echo:
	IF "%CompileJava%"=="yes" javac CreateMsgfBatmParallel.java
	java CreateMsgfBatmParallel MSGF.parameters %CD%
	IF "%CompileJava%"=="yes" rm CreateMsgfBatmParallel.class

	echo|set /p=Running MSGFsearch.bat  -  
	time /T
	echo ----------------------
	echo:
	cd %OutputDir%
	call MSGFsearch.bat
	cd %CurrentDir%
	echo:

	echo|set /p=Converting MSGF search results (.mzid^) into .pepxml  -  
	time /T
	echo ----------------------------------------------------
	echo:
	C:\python27\python.exe MzidToPepxml.py %OutputDir%
	echo:

	echo|set /p=MSGF search completed.  -  
	time /T
	echo ----------------------
	echo:
	echo:
) ELSE (
	echo|set /p=The MSGF search did not run.  -  
	time /T
	echo ----------------------------
	echo:
)
goto run_XTandemSearch



:run_XTandemSearch
IF "%RunXTandemSearch%"=="true" (
	echo|set /p=Running the XTandem search.  -  
	time /T
	echo ---------------------------
	echo:

	echo|set /p=Creating .tandem.params files for X!Tandem search  -  
	time /T
	echo -------------------------------------------------
	IF "%CompileJava%"=="yes" javac CreateTandemParams.java
	java CreateTandemParams %OutputDir% %ParamsXml% %TaxonomyTxt% %NumOfThreads%
	IF "%CompileJava%"=="yes" rm CreateTandemParams.class

	echo|set /p=Creating tandem .bat file  -  
	time /T
	echo -------------------------
	IF "%CompileJava%"=="yes" javac CreateTandemBat.java
	java CreateTandemBat %OutputDir% %TandemExe% %Tandem2XMLExe% %CurrentDir%
	IF "%CompileJava%"=="yes" rm CreateTandemBat.class

	echo|set /p=Running tandemSearch.bat file.  -  
	time /T
	echo -------------------------------
	echo:
	cd %OutputDir%
	call tandemSearch.bat
	cd %CurrentDir%
	echo:

	echo|set /p=XTandem search completed.  -  
	time /T
	echo -------------------------
	echo:
	echo:
) ELSE (
	echo|set /p=The XTandem search did not run.  -  
	time /T
	echo -------------------------------
	echo:
)
goto run_CometSearch



:run_CometSearch
IF "%RunCometSearch%"=="true" (
	echo|set /p=Running the Comet search.  -  
	time /T
	echo -------------------------
	echo:

	echo|set /p=Creating cometSearch.bat  -  
	time /T
	echo -----------------------
	echo:
	IF "%CompileJava%"=="yes" javac CreateCometBat.java
	java CreateCometBat %OutputDir% %CometSearchExe% %CometFastaFile% %CometParamsFile%
	IF "%CompileJava%"=="yes" rm CreateCometBat.class

	echo|set /p=Running cometSearch.bat  -  
	time /T
	echo -----------------------
	echo:
	cd %OutputDir%
	call cometSearch.bat
	cd %CurrentDir%

	echo|set /p=Comet search completed  -  
	time /T
	echo ----------------------
	echo:
	echo:
) ELSE (
	echo|set /p=The Comet search did not run.  -  
	time /T
	echo -----------------------------
	echo:
)
goto run_Prophet



:run_Prophet
IF "%RunProphet%"=="true" (
	echo|set /p=Running Peptide Prophet and iProphet.  -  
	time /T
	echo -------------------------------------
	echo:

	echo|set /p=Creating Peptide Prophet .bat file.  -  
	time /T
	echo -----------------------------------
	IF "%CompileJava%"=="yes" javac CreatePeptideProphetBatmP.java
	java CreatePeptideProphetBatmP %OutputDir% %XinteractExe% %NumOfThreads% %CurrentDir%
	IF "%CompileJava%"=="yes" rm CreatePeptideProphetBatmP.class

	echo|set /p=Running Peptide Prophet .bat file.  -  
	time /T
	echo -----------------------------------
	cd %OutputDir%
	call peptideProphet.bat
	cd %CurrentDir%

	echo|set /p=Creating iProphet.bat file.  -  
	time /T
	echo ----------------------------
	IF "%CompileJava%"=="yes" javac CreateiProphetBat.java
	java CreateiProphetBat %OutputDir% %InterProphetParserExe%
	IF "%CompileJava%"=="yes" rm CreateiProphetBat.class

	echo|set /p=Running iProphet.bat file.  -  
	time /T
	echo -----------------------------------
	cd %OutputDir%
	call iProphet.bat
	cd %CurrentDir%
	echo:

	echo|set /p=Peptide Prophet and iProphet completed.  -  
	time /T
	echo ---------------------------------------
	echo:
	echo:
) ELSE (
	echo|set /p=Peptide Prophet and iProphet did not run.  -  
	time /T
	echo -----------------------------------------
	echo:
)
goto run_PTMProphetParser



:run_PTMProphetParser
IF "%RunPTMProphetParser%"=="true" (
	echo|set /p=Running PTMProphetParser.  -  
	time /T
	echo -------------------------
	echo:

	echo|set /p=Creating PTMProphetParser.bat file.  -  
	time /T
	echo -----------------------------------
	echo:
	IF "%CompileJava%"=="yes" javac CreatePTMProphetBat.java
	java CreatePTMProphetBat %OutputDir% %PTMProphetParserMasses% %PTMProphetParserMZTOL% %PTMProphetParserMINPROB% %ptmProphetParserExe%
	IF "%CompileJava%"=="yes" rm CreatePTMProphetBat.class

	echo|set /p=Running PTMProphetParser.bat file.  -  
	time /T
	echo ----------------------------------
	cd %OutputDir%
	call PTMProphetParserSearch.bat
	cd %CurrentDir%
	echo:

	echo|set /p=PTMProphetParser completed.  -  
	time /T
	echo ---------------------------
	echo:
	echo:
) ELSE (
	echo|set /p=PTMProphetParser did not run.  -  
	time /T
	echo -----------------------------
	echo:
)
goto run_Skyline



:run_Skyline
IF "%RunSkyline%"=="true" (
	echo|set /p=Running Skyline.  -  
	time /T
	echo ----------------
	echo:
	cp %SkylineTemplateDoc% %OutputDir%
	echo|set /p=Creating Skyline files.  -  
	time /T
	echo -----------------------
	echo:
	IF "%CompileJava%"=="yes" javac CreateSkylineFiles.java
	java CreateSkylineFiles %OutputDir% %SkylineRunnerExe% %ReportName% %SkylineFasta% %SkylineTemplateDoc% %SkylineXMLFile%
	IF "%CompileJava%"=="yes" rm CreateSkylineFiles.class

	echo|set /p=Running skyline.bat file.  -  
	time /T
	echo -------------------------
	cd %OutputDir%
	call skyline.bat
	cd %CurrentDir%
	echo:
) ELSE (
	echo|set /p=Skyline did not run.  -  
	time /T
	echo --------------------
	echo:
)
goto run_MapDIA



:run_MapDia
IF "%RunMapDia%"=="true" (
	echo|set /p=Creating the mapDIA.parameters file.  -  
	time /T
	echo ------------------------------------
	echo:
	cd %CurrentDir%
	cp mapDIA.parameters %OutputDir%

	echo|set /p=Converting the Skyline report.  -  
	time /T
	echo ------------------------------
	echo:
	cd %CurrentDir%
	cp PrepMapDIAin.R %OutputDir%
	cd %OutputDir%

	IF "%MapDIA_SkylineReport%"=="empty" (
		%CurrentDir%\mapDia.exe mapDIA.parameters
	) ELSE (
		echo|set /p=Running mapDIA.py  -  
		time /T
		echo -----------------
		Rscript PrepMapDIAin.R %MapDIA_PTM_ProphetReport% %MapDIA_SkylineReport% %MapDIA_minPtmProphet% %MapDIAmasses% %OutputDir%
		echo:
		echo|set /p=Running mapDIA.exe  -  
		time /T
		echo ------------------
		%CurrentDir%\mapDia.exe mapDIA.parameters
	)
) ELSE (
	echo|set /p=mapDIA did not run.  -  
	time /T
	echo -------------------
	echo:
)
goto end_process



:enter_param_file
set /p parametersFile= Enter the location of the parameters file (ex: C:\...\input.parameters): 
IF EXIST %parametersFile% (
	echo|set /p=File exists.  -  
	time /T
	echo ------------
	echo:

	echo|set /p=Running again with the parameters entered.  -  
	time /T
	echo ------------------------------------------
	echo:
	runMe.bat < input.parameters
) ELSE (
	echo|set /p=File does not exist.  -  
	time /T
	echo --------------------
	echo:
	goto check_which_input
)



:end_process
echo:
cd %CurrentDir%
echo|set /p=Successfully completed!!!  -  
time /T
echo -------------------------
