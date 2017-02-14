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

//make args[0] = OutputDir
//make args[1] = *_params.xml
//make args[2] = location of taxonomy file
//make args[3] = numOfThreads

public class CreateTandemParams {
	static String outputDirStr;
	static String paramsXmlFile;
	static String taxonomyFilePath;
	static int numOfThreads;
	static int numOfFiles;
	static int beginning = 0;
	static int end = 0;
	static StringBuffer dataInFile = new StringBuffer();

	public static void main( String [] args ) {
		outputDirStr = args[0];
		paramsXmlFile = args[1];
		taxonomyFilePath = args[2];
		numOfThreads = Integer.parseInt(args[3]);
		numOfFiles = 0;
		
		File outputDir = new File(outputDirStr);
		File[] files = outputDir.listFiles();
		File paramsXMLFileToCopy = new File(paramsXmlFile);
		String tandemParamsLoc = null;
		
		for( File file : files ) {
			if( !file.isDirectory() && ( file.getAbsolutePath().endsWith("Q1.mzXML") || file.getAbsolutePath().endsWith("Q2.mzXML") || file.getAbsolutePath().endsWith("Q3.mzXML") ) ) {
				numOfFiles++;
			}
		}
		
		if((numOfFiles*2) >= numOfThreads) {
			numOfThreads = 16;
		}
		else {
			numOfThreads = 16;
		}
		
		for( File file : files ) {
			if( !file.isDirectory() && ( file.getAbsolutePath().endsWith("Q1.mzXML") || file.getAbsolutePath().endsWith("Q2.mzXML") || file.getAbsolutePath().endsWith("Q3.mzXML") ) ) {				
				tandemParamsLoc = file.getAbsolutePath().replace(".mzXML", ".tandem.params");
				try {
					File tandemParamsFile = new File( tandemParamsLoc );
					tandemParamsFile.createNewFile();
					copyXmlFile( paramsXMLFileToCopy, tandemParamsFile );
					editPathsToBioml( tandemParamsFile, file );
				} catch( Exception e ) {
					e.printStackTrace();
				}
			}
		}
		
	}
	
	public static void copyXmlFile(File source, File dest) throws IOException {
		InputStream input = null;
		OutputStream output = null;
		
		try {
			input = new FileInputStream(source);
			output = new FileOutputStream(dest);
			byte[] buf = new byte[1024];
			int bytesRead;
			while ((bytesRead = input.read(buf)) > 0) {
				output.write(buf, 0, bytesRead);
			}
		} finally {
			input.close();
			output.close();
		}
	}
	
	public static void editPathsToBioml( File tandemParamsFile, File mzxmlFile ) {
		readFile( tandemParamsFile );
		
		findBeginningAndEnd("<note type=\"input\" label=\"list path, taxonomy information\">");
		dataInFile.delete(beginning, end);
		dataInFile.insert(beginning, taxonomyFilePath);
		
		findBeginningAndEnd("<note type=\"input\" label=\"output, path\">");
		dataInFile.delete(beginning, end);
		dataInFile.insert(beginning, createTandemFilePath(mzxmlFile));
		
		findBeginningAndEnd("<note type=\"input\" label=\"spectrum, path\">");
		dataInFile.delete(beginning, end);
		dataInFile.insert(beginning, mzxmlFile.getAbsolutePath());
		
		findBeginningAndEnd("<note type=\"input\" label=\"spectrum, threads\">");
		dataInFile.delete(beginning, end);
		dataInFile.insert(beginning, numOfThreads);
		
		/*String contents = dataInFile.toString();
		clearDataInFile();
		
		contents = contents.replace( "<bioml>", 
			"<bioml>" +
			"\r\n\t" + "<note type=\"input\" label=\"list path, taxonomy information\">" + taxonomyFilePath + "</note>" +
			"\r\n\t" + "<note type=\"input\" label=\"protein, taxon\">mydatabase</note>" +
			"\r\n\t" + "<note type=\"input\" label=\"spectrum, path\">" + mzxmlFile.getAbsolutePath() + "</note>" +
			"\r\n\t" + "<note type=\"input\" label=\"output, path\">" + createTandemFilePath(mzxmlFile) + "</note>" +
			"\r\n\r\n"
		);

		dataInFile.append(contents);
		*/
		writeToFile( tandemParamsFile );
		dataInFile.delete(0, dataInFile.length());
	}
	
	public static void findBeginningAndEnd(String searchString) {
		beginning = dataInFile.lastIndexOf(searchString);
		
		while(dataInFile.charAt(beginning) != '>') {
			beginning++;
		}
		beginning++;
		end = beginning;
		while(dataInFile.charAt(end) != '<') {
			end++;
		}
	}
	
	public static boolean readFile( File tandemParamsFile ) {
		Scanner fileToRead = null;
		try {
			fileToRead = new Scanner( tandemParamsFile );
			String line;
			while( fileToRead.hasNextLine() && (line = fileToRead.nextLine()) != null ) {
				dataInFile.append(line);
				dataInFile.append("\r\n");
			}
		} catch (FileNotFoundException e) {
            e.printStackTrace();
            return false;
        } finally {
            fileToRead.close();
            return true;
        }
	}
	
	public static void writeToFile( File tandemParamsFile ) {
		try {
			BufferedWriter bufwriter = new BufferedWriter( new FileWriter(tandemParamsFile.getAbsolutePath()) );
			bufwriter.write(dataInFile.toString());
			bufwriter.close();
		} catch( Exception e ) {
			e.printStackTrace();
		}
	}
	
	public static String createTandemFilePath( File mzxmlFile ) {
		String mzxmlFilePath = outputDirStr + "\\" + mzxmlFile.getName().replace( ".mzXML", ".tandem" );
		return mzxmlFilePath;
	}
	
	public static void clearDataInFile() {
		int numOfChars = dataInFile.length();
		dataInFile = dataInFile.delete( 0, numOfChars );
	}
	
}