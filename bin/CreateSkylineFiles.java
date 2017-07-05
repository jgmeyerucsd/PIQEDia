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


/*
 * outputDir = args[0]
 * skylineRunnerExe = args[1]
 * reportName = args[2]
 * skylineFastaPath = args[3]
 */


public class CreateSkylineFiles {
	static String outputDirStr;
	static String skylineRunnerExe;
	static String reportName;
	static String reportFile;
	static String skylineFastaPath;
	static String skylineTemplateDoc;
	static String skylineSaveFilePath;
	static String skylineBatFilePath;
	static String skylineCommandsTxtFilePath;
	static String skylineXMLFile;
	static StringBuffer skylineBatFile = new StringBuffer();
	static StringBuffer skylineCommandsTxtFile = new StringBuffer();
	static int numOfFiles = 0;
	
	public static void main( String [] args ) {
		outputDirStr = args[0];
		skylineRunnerExe = args[1];
		reportName = args[2];
		reportFile = outputDirStr + "\\" + reportName + ".csv";
		skylineFastaPath = args[3];
		skylineTemplateDoc = args[4];
		skylineXMLFile = args[5];
		skylineSaveFilePath = skylineTemplateDoc;
		skylineBatFilePath = outputDirStr + "\\skyline.bat";
		skylineCommandsTxtFilePath = outputDirStr + "\\skylinerunnercmds.txt";
		

		File outputDir = new File(outputDirStr);
		File[] files = outputDir.listFiles();

		if(skylineXMLFile.equals("default")) {
			for( File file : files ) {
				if( !file.isDirectory() && file.getAbsolutePath().contains("ptmProphet-output-file.ptm.pep.xml") ) {
					skylineCommandsTxtFile.append("--in=");
					skylineCommandsTxtFile.append(skylineTemplateDoc).append(" ");
					skylineCommandsTxtFile.append("--dir=").append(outputDirStr).append(" ");
					skylineCommandsTxtFile.append("--import-search-add-mods").append(" ");
					skylineCommandsTxtFile.append("--import-search-file=");
					skylineCommandsTxtFile.append(file.getAbsolutePath()).append(" ");
					skylineCommandsTxtFile.append("--import-search-cutoff-score=").append("0.99").append(" ");
					skylineCommandsTxtFile.append("--import-fasta=");
					skylineCommandsTxtFile.append(skylineFastaPath).append("\r\n");
					/*
					 * --import-file=D:\skyline\20160611\160611_0001_fullDIA_1.wiff
					 */
					skylineCommandsTxtFile.append("--out=");
					skylineCommandsTxtFile.append(skylineSaveFilePath).append(" ");
					skylineCommandsTxtFile.append("\r\n");
					skylineCommandsTxtFile.append("--report-name=");
					skylineCommandsTxtFile.append(reportName).append(" ");
					skylineCommandsTxtFile.append("--report-file=");
					skylineCommandsTxtFile.append(reportFile);
					skylineCommandsTxtFile.append("\r\n");

					numOfFiles++;
				}
			}
		}
		else {
			skylineCommandsTxtFile.append("--in=");
			skylineCommandsTxtFile.append(skylineTemplateDoc).append(" ");
			skylineCommandsTxtFile.append("--import-search-file=");
			skylineCommandsTxtFile.append(skylineXMLFile).append(" ");
			skylineCommandsTxtFile.append("--import-search-cutoff-score=").append("0.99").append(" ");
			skylineCommandsTxtFile.append("--import-fasta=");
			skylineCommandsTxtFile.append(skylineFastaPath).append("\r\n");
			/*
			 * --import-file=D:\skyline\20160611\160611_0001_fullDIA_1.wiff
			 */
			skylineCommandsTxtFile.append("--out=");
			skylineCommandsTxtFile.append(skylineSaveFilePath).append(" ");
			skylineCommandsTxtFile.append("\r\n");
			skylineCommandsTxtFile.append("--report-name=");
			skylineCommandsTxtFile.append(reportName).append(" ");
			skylineCommandsTxtFile.append("--report-file=");
			skylineCommandsTxtFile.append(reportFile);
			skylineCommandsTxtFile.append("\r\n");

			numOfFiles++;
		}
		
		if( numOfFiles > 0 ) {
			skylineBatFile.append(skylineRunnerExe).append(" ");
			skylineBatFile.append("--batch-commands="+skylineCommandsTxtFilePath);
			skylineBatFile.append("\r\n");
		}
		
		writeToFile(skylineBatFilePath, skylineBatFile);
		writeToFile(skylineCommandsTxtFilePath, skylineCommandsTxtFile);
		
	}
	
	
	public static void writeToFile( String filePath, StringBuffer bufferToWrite ) {
		try {
			BufferedWriter bufwriter = new BufferedWriter( new FileWriter(filePath) );
			bufwriter.write(bufferToWrite.toString());
			bufwriter.close();
		} catch( Exception e ) {
			e.printStackTrace();
		}
	}
}