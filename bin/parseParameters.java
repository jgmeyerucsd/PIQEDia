import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.util.Scanner;

public class parseParameters {
  	
	static StringBuffer dataInFile = new StringBuffer();
	static String filename = null;
	
	public static void main( String [] args ) {
		filename = args[0];
		boolean readStatus = readFile();
		int numOfChars = dataInFile.length();
		String contents = dataInFile.toString();
		dataInFile = dataInFile.delete( 0, numOfChars );
		
		contents = "n\r\n" + contents;
		contents = contents.replace( "scratch dir: ","" );
		contents = contents.replace( "output dir: ","" );
		contents = contents.replace( "fasta file: ","" );
		contents = contents.replace( "ppm: ","" );
		contents = contents.replace( "enzyme: ","" );
		contents = contents.replace( "mods file: ","" );
		contents = contents.replace( "email: ","" );

	
		dataInFile.append(contents);		
		writeToFile();
	}
	
	
	private static boolean readFile() {
        Scanner fileToRead = null;
        try {
            fileToRead = new Scanner(new File(filename));
			String line;
			while( fileToRead.hasNextLine() && (line = fileToRead.nextLine()) != null ) {
				dataInFile.append(line);
				dataInFile.append("\r\n");
			}
			fileToRead.close();
			return true;
        } catch (FileNotFoundException ex) {
            System.out.println("The file " + filename + " could not be found! ");
            return false;
        } finally {
            fileToRead.close();
            return true;
        }
	}
  

	private static void writeToFile() {
		try {
			BufferedWriter bufwriter = new BufferedWriter( new FileWriter("parsed.parameters"));
			bufwriter.write(dataInFile.toString());
			bufwriter.close();
		} catch ( Exception e ) {
			System.out.println( "error occured!" );
		}
	}
  
  
}