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
import java.lang.Runtime;
// add part that checks if the number of cores is greater than the number of files and vice versa
public class CreateMsgfBatmParallel {
	
	static StringBuffer MSGFBatFile = new StringBuffer();
	static StringBuffer msgfBatFileMain = new StringBuffer();
	static int numOfFiles;
	static int cores = Runtime.getRuntime().availableProcessors();
	static long mem = Runtime.getRuntime().freeMemory();
	//static long maxmem = Runtime.getRuntime().totalMemory();
	
	public static void main( String [] args ) {

		//msgfParameters = args[0]

		File paramsFile = new File(args[0]);
		readFile(paramsFile);
		numOfFiles = 0;
		cores = cores - 2;
		//mem = maxmem;
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
		String mParallelPath = args[1]+"\\mParallel\\MParallel.exe";
		int memToUse = Integer.parseInt(parameters[9]);
		int maxmem = (memToUse-1)/cores;
		
		MSGFBatFile.delete(0, MSGFBatFile.length());
		
		for( File file : files ) {

			if( !file.isDirectory() && ( file.getAbsolutePath().endsWith("Q1.mzXML") || file.getAbsolutePath().endsWith("Q2.mzXML") || file.getAbsolutePath().endsWith("Q3.mzXML") ) ) {
				numOfFiles++;
			}
		}
		
		if(numOfFiles <= cores){
			maxmem = (memToUse-1)/numOfFiles;
		}
		
		numOfFiles=0;
		for( File file : files ) {

			if( !file.isDirectory() && ( file.getAbsolutePath().endsWith("Q1.mzXML") || file.getAbsolutePath().endsWith("Q2.mzXML") || file.getAbsolutePath().endsWith("Q3.mzXML") ) ) {
				//tandemBatFile.append( "java -d64 -Xmx10000M -jar C:\\MSGFplus.20140716\\msgfplus.jar" );
				MSGFBatFile.append( "java -Xmx"+ maxmem + "G"+ " -jar " );
				MSGFBatFile.append(msgfplusJarDir);
				MSGFBatFile.append( " -s " + file.getAbsolutePath() );
				MSGFBatFile.append( " -d " + parameters[1] );
				MSGFBatFile.append( " -o " + parameters[0] + "\\" + file.getName().replace(".mzXML", "_MSGF.mzid") );
				MSGFBatFile.append( " -thread 1");
				MSGFBatFile.append( " -t " + parameters[2] );
				MSGFBatFile.append( " -tda 1 -ti "+ parameters[8]+ " -inst 2 -m 3");
				MSGFBatFile.append( " -e " + parameters[3] );
				MSGFBatFile.append( " -ntt " + parameters[7] );
				MSGFBatFile.append( " -mod " + parameters[4] );		
				MSGFBatFile.append( " : " );
				numOfFiles++;
			}			
		}
		
		if(numOfFiles != 0) {
			msgfBatFileMain.append("java -cp ").append(msgfplusJarDir).append(" ").append("edu.ucsd.msjava.msdbsearch.BuildSA ").append(" -d ").append(parameters[1]);
			msgfBatFileMain.append("\r\n");
			msgfBatFileMain.append(mParallelPath).append(" ");
			msgfBatFileMain.append("--count=" + cores + " ");
			msgfBatFileMain.append("--shell ");
			msgfBatFileMain.append("--logfile=mparallel.log ");
			msgfBatFileMain.append(MSGFBatFile);
			msgfBatFileMain.delete(msgfBatFileMain.length()-3, msgfBatFileMain.length());
			msgfBatFileMain.append("\r\n");

		}
		else {
		msgfBatFileMain.delete(0, msgfBatFileMain.length());
		}
		writeToFile(outputDir);

	}
	



	private static void writeToFile( File outputDir ) {
		String MSGFBatFilePath = outputDir.toString() + "\\MSGFSearch.bat";
		try {
			BufferedWriter bufwriter = new BufferedWriter( new FileWriter(MSGFBatFilePath) );
			bufwriter.write(msgfBatFileMain.toString());
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