import java.io.File;
import java.util.ArrayList;
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
import java.util.*;
import java.lang.Integer;

public class CreateMsgfBat {
	
	static StringBuffer MSGFBatFile = new StringBuffer();
	
	public static void main( String [] args ) {

		//msgfParameters = args[0]

		File paramsFile = new File(args[0]);
		readFile(paramsFile);

		String [] parameters = MSGFBatFile.toString().replaceAll("\"", "").split(" \r\n");

   
		//outputDir = parameters[0]
		//fastaFile = parameters[1]
		//ppm = parameters[2]
		//enzyme = parameters[3]
		//modsFileLocation = parameters[4]
		//MsgfplusJarDir = parameters[5]
		//threadsToUse = parameters[6]
		//ntt = parameters[7]
		//ti = parameters[8]
	
		File outputDir = new File(parameters[0]);
		File[] files = outputDir.listFiles();
		int threadsToUse = Integer.parseInt(parameters[6]);
		String msgfplusJarDir = parameters[5];

		MSGFBatFile.delete(0, MSGFBatFile.length());
		
		for( File file : files ) {

			if( !file.isDirectory() && ( file.getAbsolutePath().endsWith("Q1.mzXML") || file.getAbsolutePath().endsWith("Q2.mzXML") || file.getAbsolutePath().endsWith("Q3.mzXML") ) ) {
				//tandemBatFile.append( "java -d64 -Xmx10000M -jar C:\\MSGFplus.20140716\\msgfplus.jar" );
				MSGFBatFile.append( "java -d64 -Xmx60000M -jar " );
				MSGFBatFile.append(msgfplusJarDir);
				MSGFBatFile.append( " -s " + file.getAbsolutePath() );
				MSGFBatFile.append( " -d " + parameters[1] );
				MSGFBatFile.append( " -o " + parameters[0] + "\\" + file.getName().replace(".mzXML", "_MSGF.mzid") );
				MSGFBatFile.append( " -thread " + 1 );
				MSGFBatFile.append( " -t " + parameters[2] );
				MSGFBatFile.append( " -tda 1 -ti "+ parameters[8]+ " -inst 2 -m 3");
				MSGFBatFile.append( " -e " + parameters[3] );
				MSGFBatFile.append( " -ntt " + parameters[7] );
				MSGFBatFile.append( " -mod " + parameters[4] );		
				MSGFBatFile.append( "\r\n" );
			}			
		}
		
		writeToFile(outputDir);

	}
	



	private static void writeToFile( File outputDir ) {
		String MSGFBatFilePath = outputDir.toString() + "\\MSGFSearch.bat";
		try {
			BufferedWriter bufwriter = new BufferedWriter( new FileWriter(MSGFBatFilePath) );
			bufwriter.write(MSGFBatFile.toString());
			bufwriter.close();
		} catch( Exception e ) {
			e.printStackTrace();
		}
	}




	public static boolean readFile( File inputFile ) {
		Scanner fileToRead = null;
		try {
			fileToRead = new Scanner( inputFile );
			String line;
			while( fileToRead.hasNextLine() && (line = fileToRead.nextLine()) != null ) {
				MSGFBatFile.append(line);
				MSGFBatFile.append("\r\n");
			}
		} catch (FileNotFoundException e) {
            e.printStackTrace();
            return false;
        } finally {
            fileToRead.close();
            return true;
        }
	}
}