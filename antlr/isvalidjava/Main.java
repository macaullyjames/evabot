import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;

public class Main {
  public static void main(String[] args) {
    Java8Lexer lexer = new Java8Lexer(new ANTLRFileStream(args[0]));
    CommonTokenStream tokens = new CommonTokenStream(lexer);
    Java8Parser parser = new Java8Parser(tokens);
    parser.setErrorHandler(new BailErrorStrategy());
    ParseTree tree = parser.compilationUnit();
    ParseTreeWalker walker = new ParseTreeWalker();
    walker.walk(new Java8BaseListener(), tree);
  }
}
