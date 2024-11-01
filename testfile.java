import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.lang.Math;
import java.lang.String;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.Scanner;
import java.util.Collections;
import java.util.StringTokenizer;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.logging.Logger;
import java.util.logging.Level;
import java.lang.reflect.*;

public class testfile{
	private static final Logger logger = Logger.getLogger(testfile.class.getName());

	public static void main(String args[]) throws java.io.IOException, InterruptedException, ExecutionException {
		List<Field> f = new ArrayList<>();
		B b = new B();
		Class<?> cl = b.getClass();
		while(cl != Object.class) {
			f.addAll(Arrays.asList(cl.getDeclaredFields()));
			cl = cl.getSuperclass();
		}
		for (Field field : f) {
			System.out.println(field.getName());
		}
	}
}

class A{
	int a = 0;
	String b = "";
	Boolean c = true;
}
class B extends A{
	int d = 1;
	Boolean c = false;
}