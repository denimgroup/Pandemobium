package services;/**
 * Created with IntelliJ IDEA.
 * User: denimgroup
 * Date: 7/1/13
 * Time: 2:39 PM
 * To change this template use File | Settings | File Templates.
 */

public class accountServiceClient {
  public static void main(String[] argv) {
      try {
          AccountServiceServiceLocator locator = new AccountServiceServiceLocator();
          AccountService_PortType service = locator.getaccountService();
          // If authorization is required
          //((AccountServiceSoapBindingStub)service).setUsername("user3");
          //((AccountServiceSoapBindingStub)service).setPassword("pass3");
          // invoke business method
          String response = service.sayHelloWorldFrom("john");
          System.out.println("derp");
          System.out.println(response);

      } catch (javax.xml.rpc.ServiceException ex) {
          ex.printStackTrace();
      } catch (java.rmi.RemoteException ex) {
          ex.printStackTrace();
      }
  }
}