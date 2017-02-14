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



public class CreateCometBat {
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
		
/*		
cd c:/Inetpub/wwwroot/ISB/data/DIAonly/20160625_DIA& c:\Inetpub\tpp-bin\comet 
-Pc:/Inetpub/wwwroot/ISB/data/DIAonly/20160625_DIA/comet.Kac.params 
-Nc:/Inetpub/wwwroot/ISB/data/DIAonly/20160625_DIA/160611_0001_fullDIA_1_Q1 
-Dc:/Inetpub/wwwroot/ISB/data/DIAonly/20160625_DIA/20150810.mouse.cc.iRT_DECOY.fasta 
160611_0001_fullDIA_1_Q1.mzXML 
*/
		
		
		
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