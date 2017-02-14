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



public class CreatePTMProphetBat {
	static String outputDirStr;
	static String masses;
	static String mztol;
	static String minprob;
	static String ptmProphetExe;
	static String ptmProphetBat;
	static StringBuffer ptmProphetFile = new StringBuffer();
	static int numOfFiles = 0;
	
	public static void main( String [] args ) {
		outputDirStr = args[0];
		masses = args[1];
		mztol = args[2];
		minprob = args[3];
		ptmProphetExe = args[4];
		ptmProphetBat = outputDirStr + "\\PTMProphetParserSearch.bat";
		
/*		
EXECUTING: cd c:/Inetpub/wwwroot/ISB/data/allDIAv3& 
c:\Inetpub\tpp-bin\PTMProphetParser 
K,42.010565,M,15.9949,nQ,-17.026549 
MZTOL=0.055 
MINPROB=0.5 
c:/Inetpub/wwwroot/ISB/data/allDIAv3/interact-160611_0001_halfdia_1_q1.pep.xml 
halfDIA.interact.ptm.pep.xml  
*/
		
		
		
		File outputDir = new File(outputDirStr);
		File[] files = outputDir.listFiles();

		for( File file : files ) {
			if( !file.isDirectory() && (file.getAbsolutePath().contains("ipro-output-file.pep.xml")) ) {				
				ptmProphetFile.append(ptmProphetExe).append(" ");
				ptmProphetFile.append(masses).append(" ");
				ptmProphetFile.append("MZTOL=");
				ptmProphetFile.append(mztol).append(" ");
				ptmProphetFile.append("MINPROB=");
				ptmProphetFile.append(minprob).append(" ");
				ptmProphetFile.append(file.getAbsolutePath()).append(" ");
				ptmProphetFile.append(file.getAbsolutePath().replace(".pep.xml", ".ptm.pep.xml").replace("ipro", "ptmProphet"));
				ptmProphetFile.append("\r\n");
				numOfFiles++;
			}
		}

		if( numOfFiles != 0 ) {
			writeToFile(ptmProphetBat);
		}
		
	}
	
	
	public static void writeToFile( String ptmProphetBat ) {
		try {
			BufferedWriter bufwriter = new BufferedWriter( new FileWriter(ptmProphetBat) );
			bufwriter.write(ptmProphetFile.toString());
			bufwriter.close();
		} catch( Exception e ) {
			e.printStackTrace();
		}
	}
}