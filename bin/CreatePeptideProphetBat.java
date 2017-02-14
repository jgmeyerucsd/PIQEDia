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



public class CreatePeptideProphetBat {
	static String outputDirStr;
	static String peptideProphetBatPath;
	static String xinteractPath;
	static StringBuffer peptideProphetBatFile = new StringBuffer();
	
	public static void main( String [] args ) {
		outputDirStr = args[0];
		xinteractPath = args[1].replace(".exe", "");
		peptideProphetBatPath = outputDirStr + "\\peptideProphet.bat";
		
		File outputDir = new File(outputDirStr);
		File[] files = outputDir.listFiles();
		
		for( File file : files ) {
			if( !file.isDirectory() && (file.getAbsolutePath().endsWith("_MSGF.pep.xml")) && !(file.getAbsolutePath().contains("interact-")) ) {
				peptideProphetBatFile.append(xinteractPath);
				peptideProphetBatFile.append(" ");
				peptideProphetBatFile.append("-Ninteract-" + file.getName());
				peptideProphetBatFile.append(" ");
				peptideProphetBatFile.append("-p0.01 -l7 -c2.5 -eT -PPM -I1 -PPM -OAPd -dXXX_");
				peptideProphetBatFile.append(" ");
				peptideProphetBatFile.append(file.getName());
				peptideProphetBatFile.append("\r\n");
			}
		}
		
		peptideProphetBatFile.append("\r\n");
		peptideProphetBatFile.append("\r\n");
		
		for( File file : files ) {
			if( !file.isDirectory() && (file.getAbsolutePath().endsWith(".tandem.pep.xml")) && !(file.getAbsolutePath().contains("interact-")) ) {
				peptideProphetBatFile.append(xinteractPath);
				peptideProphetBatFile.append(" ");
				peptideProphetBatFile.append("-Ninteract-" + file.getName());
				peptideProphetBatFile.append(" ");
				peptideProphetBatFile.append("-p0.05 -l7 -eT -PPM -OAPEd -dDECOY -I1");
				peptideProphetBatFile.append(" ");
				peptideProphetBatFile.append(file.getName());
				peptideProphetBatFile.append("\r\n");
			}
		}

		peptideProphetBatFile.append("\r\n");
		peptideProphetBatFile.append("\r\n");
		
		for( File file : files ) {
			if( !file.isDirectory() && (file.getAbsolutePath().endsWith("_C.pep.xml")) && !(file.getAbsolutePath().contains("interact-")) ) {
				peptideProphetBatFile.append(xinteractPath);
				peptideProphetBatFile.append(" ");
				peptideProphetBatFile.append("-Ninteract-" + file.getName());
				peptideProphetBatFile.append(" ");
				peptideProphetBatFile.append("-p0.05 -l7 -eT -PPM -OAPEd -dDECOY -I1");
				peptideProphetBatFile.append(" ");
				peptideProphetBatFile.append(file.getName());
				peptideProphetBatFile.append("\r\n");
			}
		}
		
		writeToFile(peptideProphetBatPath);
		
	}
	
	
	public static void writeToFile( String peptideProphetBatPath ) {
		try {
			BufferedWriter bufwriter = new BufferedWriter( new FileWriter(peptideProphetBatPath) );
			bufwriter.write(peptideProphetBatFile.toString());
			bufwriter.close();
		} catch( Exception e ) {
			e.printStackTrace();
		}
	}
}