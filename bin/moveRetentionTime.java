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
import java.util.*;
import java.lang.Integer;

//make args[0] = OutputDir
//make args[1] = *_params.xml
//make args[2] = location of taxonomy file
//make args[3] = numOfThreads

public class moveRetentionTime {
	static String inputFilePath;
	static String outputFilePath;
	static File inputFile;
	static File outputFile;
	static StringBuffer dataInFile = new StringBuffer();

	public static void main( String [] args ) {
		inputFilePath = args[0];
		outputFilePath = args[0];
		inputFile = new File(inputFilePath);
		outputFile = new File(outputFilePath);

		readFile(inputFile);
		String [] dataArray = dataInFile.toString().split("\r\n");

		int endPosition = dataArray[0].indexOf("Average Measured Retention Time");
		int numOfCommas = 0;

		for(int x = 0; x < endPosition; x++) {
			if(dataArray[0].charAt(x) == ',') {
				numOfCommas++;
			}
		}

		//System.out.println(numOfCommas);


		int startPosition = 0;
		endPosition = 0;
		int lastIndex = 0;
		//for( String line : dataArray ) {
		for(int y=0; y < dataArray.length; y++) {
			lastIndex = 0;
			for(int x=0; x < numOfCommas; x++) {
				lastIndex = dataArray[y].indexOf(",", ++lastIndex);
			}

			startPosition = lastIndex;
			endPosition = dataArray[y].indexOf(",", ++startPosition);

			String save = dataArray[y].substring(startPosition-1, endPosition);

			dataArray[y] = dataArray[y].replace(save, "");
			dataArray[y] = dataArray[y] + save;
		}


		dataInFile.delete(0, dataInFile.length());
		for(int y=0; y < dataArray.length; y++) {
			dataInFile.append(dataArray[y]).append("\r\n");
		}
		


		writeToFile(outputFile);

	}

	
	public static boolean readFile( File inputFile ) {
		Scanner fileToRead = null;
		try {
			fileToRead = new Scanner( inputFile );
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
	
	public static void writeToFile( File outputFile ) {
		try {
			BufferedWriter bufwriter = new BufferedWriter( new FileWriter(outputFile.getAbsolutePath()) );
			bufwriter.write(dataInFile.toString());
			bufwriter.close();
		} catch( Exception e ) {
			e.printStackTrace();
		}
	}

	
	public static void clearDataInFile() {
		int numOfChars = dataInFile.length();
		dataInFile = dataInFile.delete( 0, numOfChars );
	}
	
}