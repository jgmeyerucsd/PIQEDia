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

public class CreateWiffToMzxml {
	
	static StringBuffer WiffMzmlBatFile = new StringBuffer();
	static StringBuffer WiffMzmlBatFileMain = new StringBuffer();
	
	
	public static void main( String [] args ) {
   
		//outputDir = args[0]
		//fastaFile = args[1]
		//ppm = args[2]
		//enzyme = args[3]
		//modsFileLocation = args[4]
		//MsgfplusJarDir = args[5]
	
		File outputDir = new File(args[0]);
		File[] files = outputDir.listFiles();
		String mParallelPath = args[1]+"\\mParallel\\MParallel.exe";
		String MSConvertExePath = args[2];
		int numOfFiles = 0;
		String cores = args[3];
		
		for( File file : files ) {
			if( !file.isDirectory() && ( file.getAbsolutePath().endsWith(".wiff") ) && ( !file.getAbsolutePath().endsWith(".wiff.scan") ) ) {
				WiffMzmlBatFile.append("\"").append(MSConvertExePath).append("\"").append(" ");
				WiffMzmlBatFile.append(file).append(" ");
				WiffMzmlBatFile.append("--mzXML").append(" ");
				WiffMzmlBatFile.append("--filter \"peakPicking vendor msLevel=1-\"").append(" ");
				WiffMzmlBatFile.append("--32").append(" ");
				WiffMzmlBatFile.append("--outfile").append(" ");
				WiffMzmlBatFile.append(file.getAbsolutePath().replace(".wiff", ".mzXML"));
				WiffMzmlBatFile.append(" : ");
				numOfFiles++;
			}
		}
		
		
		if(numOfFiles != 0) {
			WiffMzmlBatFileMain.append(mParallelPath).append(" ");
			WiffMzmlBatFileMain.append("--count=" + cores + " ");
			WiffMzmlBatFileMain.append("--logfile=mparallel.log ");
			WiffMzmlBatFileMain.append("--priority=4 ");
			WiffMzmlBatFileMain.append("--shell ");
			WiffMzmlBatFileMain.append(WiffMzmlBatFile);
			WiffMzmlBatFileMain.delete(WiffMzmlBatFileMain.length()-3, WiffMzmlBatFileMain.length());
			WiffMzmlBatFileMain.append("\r\n");
		}
		
		writeToFile(outputDir);
		
	}
	
	private static void writeToFile( File outputDir ) {
		String MSGFBatFilePath = outputDir.toString() + "\\WiffToMzxml.bat";
		try {
			BufferedWriter bufwriter = new BufferedWriter( new FileWriter(MSGFBatFilePath) );
			bufwriter.write(WiffMzmlBatFileMain.toString());
			bufwriter.close();
		} catch( Exception e ) {
			e.printStackTrace();
		}
	}
}