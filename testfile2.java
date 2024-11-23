import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.lang.Math;
import java.lang.String;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;
import java.util.Collections;
import java.util.StringTokenizer;
import java.util.regex.Pattern;

class A{

}

class B extends A{
	public String argument = "argument";
}

public class testfile2
{
	private static final String PATH_REGEX = "^[^/]+://([^/]+/)+([^/])*$";
    private static final Pattern PATH_PATTERN = Pattern.compile(PATH_REGEX);

	public String argument = "okay";
	public static void main(String args[]) throws java.io.IOException
	{
		System.out.println(PATH_PATTERN.matcher("gcs://user").matches());

	}
}