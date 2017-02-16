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



public class CreateiProphetBat {
	static String outputDirStr;
	static String iProphetBat;
	static String interProphetParser;
	static StringBuffer iProphetBatFile = new StringBuffer();
	static int numOfFiles = 0;
	
	public static void main( String [] args ) {
		outputDirStr = args[0];
		interProphetParser = args[1].replace(".exe", "");
		iProphetBat = outputDirStr + "\\iProphet.bat";
		
		File outputDir = new File(outputDirStr);
		File[] files = outputDir.listFiles();
		
		for( File file : files ) {
			if( !file.isDirectory() && (file.getAbsolutePath().contains("interact-")) && (file.getAbsolutePath().endsWith(".pep.xml")) ) {
				numOfFiles++;
				
				if( numOfFiles == 1 ) {
					iProphetBatFile.append(interProphetParser).append(" ");
				}
			}
		}
		
		if( numOfFiles == 0 ) {
			iProphetBatFile.delete(0, iProphetBatFile.length());
		}
		else {
			iProphetBatFile.append("THREADS=16 ").append("interact*.pep.xml ");
			iProphetBatFile.append("ipro-output-file.pep.xml\r\n");
		}
		
		writeToFile(iProphetBat);
		
	}
	
	
	public static void writeToFile( String iProphetBat ) {
		try {
			BufferedWriter bufwriter = new BufferedWriter( new FileWriter(iProphetBat) );
			bufwriter.write(iProphetBatFile.toString());
			bufwriter.close();
		} catch( Exception e ) {
			e.printStackTrace();
		}
	}
}