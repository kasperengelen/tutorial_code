package palindrome_checker;


import com.beust.jcommander.JCommander;
import com.beust.jcommander.ParameterException;

/**
 * Main class.
 */
public class Main {

    /**
     * Entry point of the program.
     */
    public static void main(String[] args) {
        // tell JCommander what kind of arguments we need
        Arguments parsedArgs = new Arguments();
        JCommander jc = JCommander.newBuilder().addObject(parsedArgs).build();

        try {
            // parse arguments from the array of strings
            jc.parse(args);

            // print help if needed
            if (parsedArgs.help) {
                jc.usage();
                return;
            }

            // retrieve argument value
            String word = parsedArgs.word;

            PalindromeChecker checker = new PalindromeChecker();

            if(checker.isPalindrome(word)) {
                System.out.println("Input '" + word + "' is a palindrome.");
            } else {
                System.out.println("Input '" + word + "' is not a palindrome.");
            }

        } catch (ParameterException e) {
            // tell the user what went wrong
            System.err.println(e.getLocalizedMessage());
            jc.usage();
        }
    }
}
