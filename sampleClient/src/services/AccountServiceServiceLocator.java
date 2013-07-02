/**
 * AccountServiceServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package services;

public class AccountServiceServiceLocator extends org.apache.axis.client.Service implements services.AccountServiceService {

    public AccountServiceServiceLocator() {
    }


    public AccountServiceServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public AccountServiceServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for accountService
    private java.lang.String accountService_address = "http://localhost:8080/services/services/accountService";

    public java.lang.String getaccountServiceAddress() {
        return accountService_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String accountServiceWSDDServiceName = "accountService";

    public java.lang.String getaccountServiceWSDDServiceName() {
        return accountServiceWSDDServiceName;
    }

    public void setaccountServiceWSDDServiceName(java.lang.String name) {
        accountServiceWSDDServiceName = name;
    }

    public services.AccountService_PortType getaccountService() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(accountService_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getaccountService(endpoint);
    }

    public services.AccountService_PortType getaccountService(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            services.AccountServiceSoapBindingStub _stub = new services.AccountServiceSoapBindingStub(portAddress, this);
            _stub.setPortName(getaccountServiceWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setaccountServiceEndpointAddress(java.lang.String address) {
        accountService_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (services.AccountService_PortType.class.isAssignableFrom(serviceEndpointInterface)) {
                services.AccountServiceSoapBindingStub _stub = new services.AccountServiceSoapBindingStub(new java.net.URL(accountService_address), this);
                _stub.setPortName(getaccountServiceWSDDServiceName());
                return _stub;
            }
        }
        catch (java.lang.Throwable t) {
            throw new javax.xml.rpc.ServiceException(t);
        }
        throw new javax.xml.rpc.ServiceException("There is no stub implementation for the interface:  " + (serviceEndpointInterface == null ? "null" : serviceEndpointInterface.getName()));
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(javax.xml.namespace.QName portName, Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        if (portName == null) {
            return getPort(serviceEndpointInterface);
        }
        java.lang.String inputPortName = portName.getLocalPart();
        if ("accountService".equals(inputPortName)) {
            return getaccountService();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://services", "accountServiceService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://services", "accountService"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("accountService".equals(portName)) {
            setaccountServiceEndpointAddress(address);
        }
        else 
{ // Unknown Port Name
            throw new javax.xml.rpc.ServiceException(" Cannot set Endpoint Address for Unknown Port" + portName);
        }
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(javax.xml.namespace.QName portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        setEndpointAddress(portName.getLocalPart(), address);
    }

}
