package palindrome_checker;

import org.apache.commons.lang3.StringUtils;

/**
 * Class to check whether a word is a palindrome.
 */
public class PalindromeChecker {
    public PalindromeChecker() {}

    /**
     * Check for palindromes.
     *
     * @param word A string that might be a palindrome.
     * @return True if the string is a palindrome, false otherwise.
     */
    public boolean isPalindrome(String word) {
        return StringUtils.reverse(word).equals(word);
    }
}
