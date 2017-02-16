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



public class CreatePeptideProphetBatmP {
	static String outputDirStr;
	static String peptideProphetBatPath;
	static String xinteractPath;
	static String mParallelPath;
	static StringBuffer peptideProphetMSGF = new StringBuffer();
	static StringBuffer peptideProphetTandem = new StringBuffer();
	static StringBuffer peptideProphetComet = new StringBuffer();
	static StringBuffer peptideProphetMain = new StringBuffer();
	static String cores;
	static int numOfFiles;
	
	public static void main( String [] args ) {
		outputDirStr = args[0];
		xinteractPath = args[1].replace(".exe", "");
		cores = args[2];
		//cores = cores-2;
		String mParallelPath = args[3]+"\\mParallel\\MParallel.exe";
		
		peptideProphetBatPath = outputDirStr + "\\peptideProphet.bat";
		
		File outputDir = new File(outputDirStr);
		File[] files = outputDir.listFiles();
		
		for( File file : files ) {
			if( !file.isDirectory() && (file.getAbsolutePath().endsWith("_MSGF.pep.xml")) && !(file.getAbsolutePath().contains("interact-")) ) {
				peptideProphetMSGF.append(xinteractPath);
				peptideProphetMSGF.append(" ");
				peptideProphetMSGF.append("-Ninteract-" + file.getName());
				peptideProphetMSGF.append(" ");
				peptideProphetMSGF.append(" -p0.01 -l7 -c2.5 -eT -PPM -I1 -PPM -OAPd -dXXX_");
				peptideProphetMSGF.append(" ");
				peptideProphetMSGF.append(file.getName());
				peptideProphetMSGF.append(" : ");
				numOfFiles++;
				if(peptideProphetMSGF.length() >7000 && numOfFiles !=0){
					peptideProphetMain.append(mParallelPath).append(" ");
					peptideProphetMain.append("--count=" + cores + " ");
					peptideProphetMain.append("--shell ");
					peptideProphetMain.append("--logfile=mparallel.log ");
					peptideProphetMain.append(peptideProphetMSGF);
					peptideProphetMain.delete(peptideProphetMain.length()-3, peptideProphetMain.length());
					peptideProphetMain.append("\r\n");
					peptideProphetMSGF.delete(0,peptideProphetMSGF.length());
					numOfFiles = 0;
				}	
			}
		}
		//insert part1 building main
		//
		if(numOfFiles != 0) {
			peptideProphetMain.append(mParallelPath).append(" ");
			peptideProphetMain.append("--count=" + cores + " ");
			peptideProphetMain.append("--shell ");
			peptideProphetMain.append("--logfile=mparallel.log ");
			peptideProphetMain.append(peptideProphetMSGF);
			peptideProphetMain.delete(peptideProphetMain.length()-3, peptideProphetMain.length());
			peptideProphetMain.append("\r\n");

		}
		numOfFiles=0;
		
		peptideProphetMain.append("\r\n");
		peptideProphetMain.append("\r\n");
		
		for( File file : files ) {
			if( !file.isDirectory() && (file.getAbsolutePath().endsWith(".tandem.pep.xml")) && !(file.getAbsolutePath().contains("interact-")) ) {
				peptideProphetTandem.append(xinteractPath);
				peptideProphetTandem.append(" ");
				peptideProphetTandem.append("-Ninteract-" + file.getName());
				peptideProphetTandem.append(" ");
				peptideProphetTandem.append("-p0.05 -l7 -eT -PPM -OAPEd -dDECOY -I1");
				peptideProphetTandem.append(" ");
				peptideProphetTandem.append(file.getName());
				peptideProphetTandem.append(" : ");
				numOfFiles++;
				if(peptideProphetTandem.length() >7000 && numOfFiles !=0){
					peptideProphetMain.append(mParallelPath).append(" ");
					peptideProphetMain.append("--count=" + cores + " ");
					peptideProphetMain.append("--shell ");
					peptideProphetMain.append("--logfile=mparallel.log ");
					peptideProphetMain.append(peptideProphetTandem);
					peptideProphetMain.delete(peptideProphetMain.length()-3, peptideProphetMain.length());
					peptideProphetMain.append("\r\n");
					peptideProphetTandem.delete(0,peptideProphetTandem.length());
					numOfFiles = 0;
				}	
			}
		}
		if(numOfFiles != 0) {
			peptideProphetMain.append(mParallelPath).append(" ");
			peptideProphetMain.append("--count=" + cores + " ");
			peptideProphetMain.append("--shell ");
			peptideProphetMain.append("--logfile=mparallel.log ");
			peptideProphetMain.append(peptideProphetTandem);
			//peptideProphetMain.delete(peptideProphetMain.length()-3, peptideProphetMain.length());
			peptideProphetMain.append("\r\n");

		}
		peptideProphetMain.append("\r\n");
		peptideProphetMain.append("\r\n");
		numOfFiles=0;
		for( File file : files ) {
			if( !file.isDirectory() && (file.getAbsolutePath().endsWith("_C.pep.xml")) && !(file.getAbsolutePath().contains("interact-")) ) {
				peptideProphetComet.append(xinteractPath);
				peptideProphetComet.append(" ");
				peptideProphetComet.append("-Ninteract-" + file.getName());
				peptideProphetComet.append(" ");
				peptideProphetComet.append("-p0.05 -l7 -eT -PPM -OAPEd -dDECOY -I1");
				peptideProphetComet.append(" ");
				peptideProphetComet.append(file.getName());
				peptideProphetComet.append(" : ");
				numOfFiles++;
				if(peptideProphetComet.length() >7000 && numOfFiles !=0){
					peptideProphetMain.append(mParallelPath).append(" ");
					peptideProphetMain.append("--count=" + cores + " ");
					peptideProphetMain.append("--shell ");
					peptideProphetMain.append("--logfile=mparallel.log ");
					peptideProphetMain.append(peptideProphetComet);
					peptideProphetMain.delete(peptideProphetMain.length()-3, peptideProphetMain.length());
					peptideProphetMain.append("\r\n");
					peptideProphetComet.delete(0,peptideProphetComet.length());
					numOfFiles = 0;
				}	
			}
		}
		if(numOfFiles != 0) {
			peptideProphetMain.append(mParallelPath).append(" ");
			peptideProphetMain.append("--count=" + cores + " ");
			peptideProphetMain.append("--shell ");
			peptideProphetMain.append("--logfile=mparallel.log ");
			peptideProphetMain.append(peptideProphetComet);
			//peptideProphetMain.delete(peptideProphetMain.length()-3, peptideProphetMain.length());
			peptideProphetMain.append("\r\n");

		}
		
		
		
		writeToFile(peptideProphetBatPath);
		
	}
	
	
	public static void writeToFile( String peptideProphetBatPath ) {
		try {
			BufferedWriter bufwriter = new BufferedWriter( new FileWriter(peptideProphetBatPath) );
			bufwriter.write(peptideProphetMain.toString());
			bufwriter.close();
		} catch( Exception e ) {
			e.printStackTrace();
		}
	}
}