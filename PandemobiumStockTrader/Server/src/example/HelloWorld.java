package example;

import javax.jws.WebMethod;
import javax.jws.WebService;

/**
 * Created with IntelliJ IDEA.
 * User: denimgroup
 * Date: 7/1/13
 * Time: 12:57 PM
 * To change this template use File | Settings | File Templates.
 */
@WebService

public class HelloWorld {
  @WebMethod
  public String sayHelloWorldFrom(String from) {
    String result = "Hello, world, from " + from;
    System.out.println(result);
    return result;
  }
}
