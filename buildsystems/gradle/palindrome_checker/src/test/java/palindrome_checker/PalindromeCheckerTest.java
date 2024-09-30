package palindrome_checker;

import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Tests for the PalindromeChecker class.
 */
public class PalindromeCheckerTest {
    /**
     * Test to verify that single characters are always palindromes.
     */
    @Test
    public void testSingleCharacter() {
        PalindromeChecker checker = new PalindromeChecker();
        assertTrue(checker.isPalindrome("a"));
        assertTrue(checker.isPalindrome("b"));
        assertTrue(checker.isPalindrome("c"));
        assertTrue(checker.isPalindrome("x"));
        assertTrue(checker.isPalindrome("0"));
        assertTrue(checker.isPalindrome("9"));
    }

    /**
     * Test for some bigger words.
     */
    @Test
    public void testBig() {
        PalindromeChecker checker = new PalindromeChecker();
        assertTrue(checker.isPalindrome("abccba"));
        assertFalse(checker.isPalindrome("abcdef"));
    }

    /**
     * Test for binary numbers.
     */
    @Test
    public void testBinary() {
        PalindromeChecker checker = new PalindromeChecker();
        assertTrue(checker.isPalindrome("010010"));
        assertFalse(checker.isPalindrome("110110001"));
    }
}


