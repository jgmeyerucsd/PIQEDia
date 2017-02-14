import java.io.File;
import java.lang.String;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.util.Scanner;
import java.lang.Integer;
import java.lang.
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;



public class CreateBatFiles {

	private static StringBuffer inputParametersStrBuf = new StringBuffer();

	private static String keepThis;
	private static String inputDirStr;
	private static String outputDirStr;
	private static String numOfThreadsStr;
	private static String amountOfRamStr;
	private static String ab_Sciex_Ms_ConverterDirStr;
	private static String msconvertDirStr;
	private static String indexmzXMLDirStr;
	private static String diaUmpireSEJarDirStr;
	private static String mzxmlToMgfParamsStr;
	private static String msgfplusJarDirStr;
	private static String fastaDirStr;
	private static String ppmStr;
	private static String enzymeStr;
	private static String modsDirStr;
	private static String tandemDirStr;
	private static String tandem2xmlDirStr;
	private static String paramsXMLDirStr;
	private static String taxonomyPathStr;
	private static String cometDirStr;
	private static String cometParamsDirStr;
	private static String cometFastaDirStr;
	private static String xInteractDirStr;
	private static String interProphetParserDirStr;
	private static String skylineRunnerExePathStr;
	private static String skylineReportNameStr;
	private static String skylineFastaDirStr;
	private static String runDiaUmpireBoolStr;
	private static String runMSGFSearchBoolStr;
	private static String runXTandemBoolStr;
	private static String runCometSearchBoolStr;
	private static String runProphetBoolStr;
	private static String runSkylineBoolStr;

	private static String[] inputParametersArray = 
					{ 
					  keepThis, inputDirStr, outputDirStr, numOfThreadsStr, amountOfRamStr,
					  ab_Sciex_Ms_ConverterDirStr, msconvertDirStr, indexmzXMLDirStr,
					  diaUmpireSEJarDirStr, mzxmlToMgfParamsStr, msgfplusJarDirStr, fastaDirStr,
					  ppmStr, enzymeStr, modsDirStr, tandemDirStr, tandem2xmlDirStr,
					  paramsXMLDirStr, taxonomyPathStr, cometDirStr, cometParamsDirStr,
					  cometFastaDirStr, xInteractDirStr, interProphetParserDirStr,
					  skylineRunnerExePathStr, skylineReportNameStr, skylineFastaDirStr,
					  runDiaUmpireBoolStr, runMSGFSearchBoolStr, runXTandemBoolStr,
					  runCometSearchBoolStr, runProphetBoolStr, runSkylineBoolStr
					};

	private static boolean runDiaUmpireBool;
	private static boolean runMSGFSearchBool;
	private static boolean runXTandemBool;
	private static boolean runCometSearchBool;
	private static boolean runProphetBool;
	private static boolean runSkylineBool;




	/*
	 *
	 *
	 */
	public static void main(String[] args) {

		String inputParametersString = Paths.get(".").toAbsolutePath().normalize().toString();
		inputParametersString += "\\input.parameters";
		Path inputParametersPath = Paths.get(inputParametersString);
		readFile(inputParametersPath, inputParametersStrBuf);
		String[] inputParametersArray = inputParametersStrBuf.toString().split("\r\n");

		runDiaUmpireBool = Boolean.parseBoolean(runDiaUmpireBoolStr);
		runMSGFSearchBool = Boolean.parseBoolean(runMSGFSearchBoolStr);
		runXTandemBool = Boolean.parseBoolean(runXTandemBoolStr);
		runCometSearchBool = Boolean.parseBoolean(runCometSearchBoolStr);
		runProphetBool = Boolean.parseBoolean(runProphetBoolStr);
		runSkylineBool = Boolean.parseBoolean(runSkylineBoolStr);

		if(runDiaUmpireBool) {

		}

		if(runMSGFSearchBool) {
			
		}

		if(runXTandemBool) {
			
		}

		if(runCometSearchBool) {
			
		}

		if(runProphetBool) {
			
		}

		if(runSkylineBool) {
			
		}
		
	}



	public static boolean readFile( Path readFilePath, StringBuffer whichStrBuffer ) {
		whichStrBuffer.delete(0, whichStrBuffer.length());
		Scanner fileToRead = null;
		try {
			fileToRead = new Scanner( readFilePath );
			String line;
			while( fileToRead.hasNextLine() && (line = fileToRead.nextLine()) != null ) {
				whichStrBuffer.append(line);
				whichStrBuffer.append("\r\n");
			}
		} catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            fileToRead.close();
            return true;
        }
	}
}







/*








	static String outputDirStr;
	static String cometExePath;
	static String cometSearchBat;
	static String cometFastaPath;
	static String cometParamsPath;
	static StringBuffer cometBatFile = new StringBuffer();
	static int numOfFiles = 0;
	
	public static void main( String [] args ) {
		outputDirStr = args[0];
		cometExePath = args[1].replace(".exe", "");
		cometSearchBat = outputDirStr + "\\cometSearch.bat";
		cometFastaPath = args[2];
		cometParamsPath = args[3];
		
		File outputDir = new File(outputDirStr);
		File[] files = outputDir.listFiles();

		for( File file : files ) {
			if( !file.isDirectory() && (file.getAbsolutePath().endsWith("Q1.mzXML") || file.getAbsolutePath().endsWith("Q2.mzXML") || file.getAbsolutePath().endsWith("Q3.mzXML")) ) {
				numOfFiles++;
				
				cometBatFile.append(cometExePath);
				cometBatFile.append(" ");
				cometBatFile.append("-P");
				cometBatFile.append(cometParamsPath);
				cometBatFile.append(" ");
				cometBatFile.append("-N");
				cometBatFile.append(file.getAbsolutePath().replace(".mzXML", ""));
				cometBatFile.append(" ");
				cometBatFile.append("-D");
				cometBatFile.append(cometFastaPath);
				cometBatFile.append(" ");
				cometBatFile.append(file.getAbsolutePath());
				cometBatFile.append("\r\n");
			}
		}
		
		writeToFile(cometSearchBat);
		
	}
	
	
	public static void writeToFile( String cometSearchBat ) {
		try {
			BufferedWriter bufwriter = new BufferedWriter( new FileWriter(cometSearchBat) );
			bufwriter.write(cometBatFile.toString());
			bufwriter.close();
		} catch( Exception e ) {
			e.printStackTrace();
		}
	}
}
*/