file://<WORKSPACE>/testfile.java
### java.util.NoSuchElementException: next on empty iterator

occurred in the presentation compiler.

presentation compiler configuration:


action parameters:
uri: file://<WORKSPACE>/testfile.java
text:
```scala
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
		String s = "​​spark-streaming-kafka-0-10_2.11-2.4.0.jar:kafka-clients-2.5.0.jar:metrics.properties:etl-gson-2.2.5.jar:guava-16.0.1.jar:hbase-common-2.1.0-cdh6.3.1.jar:hbase-hadoop2-compat-2.1.0-cdh6.3.1.jar:hbase-protocol-shaded-2.1.0-cdh6.3.1.jar:hbase-hadoop-compat-2.1.0-cdh6.3.1.jar:hbase-metrics-api-2.1.0-cdh6.3.1.jar:hamcrest-core-1.3.jar:hbase-shaded-protobuf-2.2.1.jar:hbase-protocol-2.1.0-cdh6.3.1.jar:hbase-shaded-netty-2.2.1.jar:hbase-metrics-2.1.0-cdh6.3.1.jar:joni-2.1.11.jar:error_prone_annotations-2.3.3.jar:junit-4.12.jar:hbase-client-2.1.0-cdh6.3.1.jar:jcodings-1.0.18.jar:hbase-shaded-miscellaneous-2.2.1.jar:spark-sql-patch-3.0.jar:spark-sql-kafka-0-10_2.11-2.4.0.jar";

		String t = "spark-streaming-kafka-0-10_2.11-2.4.0.jar:kafka-clients-2.5.0.jar:metrics.properties:etl-gson-2.2.5.jar:guava-16.0.1.jar:hbase-common-2.1.0-cdh6.3.1.jar:hbase-hadoop2-compat-2.1.0-cdh6.3.1.jar:hbase-protocol-shaded-2.1.0-cdh6.3.1.jar:hbase-hadoop-compat-2.1.0-cdh6.3.1.jar:hbase-metrics-api-2.1.0-cdh6.3.1.jar:hamcrest-core-1.3.jar:hbase-shaded-protobuf-2.2.1.jar:hbase-protocol-2.1.0-cdh6.3.1.jar:hbase-shaded-netty-2.2.1.jar:hbase-metrics-2.1.0-cdh6.3.1.jar:joni-2.1.11.jar:error_prone_annotations-2.3.3.jar:junit-4.12.jar:hbase-client-2.1.0-cdh6.3.1.jar:jcodings-1.0.18.jar:hbase-shaded-miscellaneous-2.2.1.jar:spark-sql-patch-3.0.jar:spark-sql-kafka-0-10_2.11-2.4.0.jar";
		

		System.out.println(s);
		System.out.println("");
		System.out.println(t);
		System.out.println("");
		System.out.println(s.trim());
		System.out.println("");
		System.out.println(t.trim());

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
```



#### Error stacktrace:

```
scala.collection.Iterator$$anon$19.next(Iterator.scala:973)
	scala.collection.Iterator$$anon$19.next(Iterator.scala:971)
	scala.collection.mutable.MutationTracker$CheckedIterator.next(MutationTracker.scala:76)
	scala.collection.IterableOps.head(Iterable.scala:222)
	scala.collection.IterableOps.head$(Iterable.scala:222)
	scala.collection.AbstractIterable.head(Iterable.scala:935)
	dotty.tools.dotc.interactive.InteractiveDriver.run(InteractiveDriver.scala:164)
	dotty.tools.pc.MetalsDriver.run(MetalsDriver.scala:45)
	dotty.tools.pc.WithCompilationUnit.<init>(WithCompilationUnit.scala:31)
	dotty.tools.pc.SimpleCollector.<init>(PcCollector.scala:345)
	dotty.tools.pc.PcSemanticTokensProvider$Collector$.<init>(PcSemanticTokensProvider.scala:63)
	dotty.tools.pc.PcSemanticTokensProvider.Collector$lzyINIT1(PcSemanticTokensProvider.scala:63)
	dotty.tools.pc.PcSemanticTokensProvider.Collector(PcSemanticTokensProvider.scala:63)
	dotty.tools.pc.PcSemanticTokensProvider.provide(PcSemanticTokensProvider.scala:88)
	dotty.tools.pc.ScalaPresentationCompiler.semanticTokens$$anonfun$1(ScalaPresentationCompiler.scala:109)
```
#### Short summary: 

java.util.NoSuchElementException: next on empty iterator