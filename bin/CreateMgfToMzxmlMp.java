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


public class CreateMgfToMzxmlMp {
	
	static StringBuffer WiffMzmlBatFile = new StringBuffer();
	static StringBuffer WiffMzmlBatFileMain = new StringBuffer();
	
	public static void main( String [] args ) {
   
		//outputDir = args[0]
		//mParallelpath = args[1]
		//MSconvertExePath = args[2]
	
		File outputDir = new File(args[0]);
		File[] files = outputDir.listFiles();
		String mParallelPath = args[1]+"\\mParallel\\MParallel.exe";
		String MSConvertExePath = args[2];
		String threads = args[3];
		int numOfFiles = 0;
		
		for( File file : files ) {
			if( !file.isDirectory() && ( file.getAbsolutePath().endsWith(".mgf") ) ) {
				WiffMzmlBatFile.append("\"").append(MSConvertExePath).append("\"").append(" ");
				WiffMzmlBatFile.append(file).append(" ");
				WiffMzmlBatFile.append("--mzXML").append(" ");
				WiffMzmlBatFile.append("--32").append(" ");
				WiffMzmlBatFile.append("--outfile").append(" ");
				WiffMzmlBatFile.append(file.getAbsolutePath().replace(".mgf", ".mzXML"));
				WiffMzmlBatFile.append("\r\n");
				numOfFiles++;
			}
		}
		
		
		if(numOfFiles != 0) {
			WiffMzmlBatFileMain.append(mParallelPath).append(" ");
			WiffMzmlBatFileMain.append("--count=" + threads + " ");
			WiffMzmlBatFileMain.append("--logfile=mparallel.log ");
			WiffMzmlBatFileMain.append("--shell ");
			WiffMzmlBatFileMain.append("--input=").append(outputDir).append("\\MgfToMzxmlcmds.txt");
			WiffMzmlBatFileMain.append("\r\n");
		}
		
		writeBatFile(outputDir);
		writeTxtFile(outputDir);
		
	}

	private static void writeBatFile( File outputDir ) {
		String MSGFBatFilePath = outputDir.toString() + "\\CreateMgfToMzxml.bat";
		try {
			BufferedWriter bufwriter = new BufferedWriter( new FileWriter(MSGFBatFilePath) );
			bufwriter.write(WiffMzmlBatFileMain.toString());
			bufwriter.close();
		} catch( Exception e ) {
			e.printStackTrace();
		}
	}
	private static void writeTxtFile( File outputDir ) {
		String MSGFBatFilePath = outputDir.toString() + "\\MgfToMzxmlcmds.txt";
		try {
			BufferedWriter bufwriter = new BufferedWriter( new FileWriter(MSGFBatFilePath) );
			bufwriter.write(WiffMzmlBatFile.toString());
			bufwriter.close();
		} catch( Exception e ) {
			e.printStackTrace();
		}
	}
}