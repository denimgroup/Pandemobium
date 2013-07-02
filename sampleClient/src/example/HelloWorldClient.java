package example;

import mypackage.HelloWorldServiceLocator;
import mypackage.HelloWorld_PortType;

/**
 * Created with IntelliJ IDEA.
 * User: denimgroup
 * Date: 7/1/13
 * Time: 1:15 PM
 * To change this template use File | Settings | File Templates.
 */
public class HelloWorldClient {
  public static void main(String[] argv) {
      try {
          HelloWorldServiceLocator locator = new HelloWorldServiceLocator();
          HelloWorld_PortType service = locator.getHelloWorld();
          // If authorization is required
          //((HelloWorldSoapBindingStub)service).setUsername("user3");
          //((HelloWorldSoapBindingStub)service).setPassword("pass3");
          // invoke business method
          String response = service.sayHelloWorldFrom("John");
          System.out.println(response);
      } catch (javax.xml.rpc.ServiceException ex) {
          ex.printStackTrace();
      } catch (java.rmi.RemoteException ex) {
          ex.printStackTrace();
      }
  }
}