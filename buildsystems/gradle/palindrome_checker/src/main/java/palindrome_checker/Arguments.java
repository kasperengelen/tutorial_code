package palindrome_checker;

import com.beust.jcommander.Parameter;

/**
 * Class that specifies the arguments of the program.
 */
public class Arguments {
    // allows the user to ask for help
    @Parameter(names = {"-h", "--help"}, help=true)
    public boolean help;

    // allows the user to specify the word that might be a palindrome
    @Parameter(names = { "-w", "--word" },
            description = "The word that might be a palindrome.",
            required=true)
    public String word;
}
