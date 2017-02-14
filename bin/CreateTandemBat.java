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

//make args[0] = OutputDir
//make args[1] = tandemExe
//make args[2] = tandem2XMLExe
//make args[3] = mparallelexePath

public class CreateTandemBat {
	static String outputDirStr;
	static String tandemExe;
	static String tandem2XMLExe;
	static StringBuffer tandemSearchBatFile = new StringBuffer();
	static StringBuffer tandem2XMLBatFile = new StringBuffer();
	static StringBuffer tandemBatFileMain = new StringBuffer();
	static int numOfFiles;

	public static void main( String [] args ) {
		String tandemBatFilePath;
		outputDirStr = args[0];
		tandemExe = args[1].replace(".exe", "");
		tandem2XMLExe = args[2].replace(".exe", "");
		numOfFiles = 0;
		String mParallelPath = args[3]+"\\mParallel\\MParallel.exe";
		
		File outputDir = new File(outputDirStr);
		File[] files = outputDir.listFiles();
		
		for( File file : files ) {
			if( !file.isDirectory() && (file.getAbsolutePath().endsWith(".tandem.params")) ) {
				tandemSearchBatFile.append(tandemExe).append(" ");
				tandemSearchBatFile.append(file.getAbsolutePath()).append(" : ");

				tandem2XMLBatFile.append(tandem2XMLExe).append(" ");
				tandem2XMLBatFile.append(file.getAbsolutePath().replace(".tandem.params", ".tandem")).append(" ");
				tandem2XMLBatFile.append(file.getAbsolutePath().replace(".tandem.params", ".tandem.pep.xml"));
				tandem2XMLBatFile.append(" : ");
				
				numOfFiles++;
			}
		}
		
		if(numOfFiles != 0) {
			tandemBatFileMain.append(mParallelPath).append(" ");
			tandemBatFileMain.append("--count=" + 16 + " ");
			tandemBatFileMain.append("--shell ");
			tandemBatFileMain.append(tandemSearchBatFile);
			tandemBatFileMain.delete(tandemBatFileMain.length()-3, tandemBatFileMain.length());
			tandemBatFileMain.append("\r\n");
			
			tandemBatFileMain.append("\"C:\\Program Files\\mParallel\\Mparallel.exe\" ");
			tandemBatFileMain.append("--count=" + numOfFiles + " ");
			tandemBatFileMain.append("--shell ");
			tandemBatFileMain.append(tandem2XMLBatFile);
			tandemBatFileMain.delete(tandemBatFileMain.length()-3, tandemBatFileMain.length());
			tandemBatFileMain.append("\r\n");
		}
		else {
			tandemBatFileMain.delete(0, tandemBatFileMain.length());
		}
		
		tandemBatFilePath = createTandemBatPath();
		writeToFile( tandemBatFilePath );
				
	}
	
	
	public static String createTandemBatPath() {
		String tandemBatFilePath = outputDirStr + "\\" + "tandemSearch.bat";
		return tandemBatFilePath;
	}
	
	
	public static void writeToFile( String tandemBatFilePath ) {
		try {
			BufferedWriter bufwriter = new BufferedWriter( new FileWriter(tandemBatFilePath) );
			bufwriter.write(tandemBatFileMain.toString());
			bufwriter.close();
		} catch( Exception e ) {
			e.printStackTrace();
		}
	}
	
}
