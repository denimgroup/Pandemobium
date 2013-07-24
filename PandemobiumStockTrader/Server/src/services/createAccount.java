package services;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * Created with IntelliJ IDEA.
 * User: denimgroup
 * Date: 7/23/13
 * Time: 11:16 AM
 * To change this template use File | Settings | File Templates.
 */
public class createAccount {
    private JTextField firstNameField;
    private JTextField lastNameField;
    private JTextField eMailField;
    private JTextField phoneField;
    private JTextField usernameField;
    private JPasswordField passwordField;
    private JButton clearButton;
    private JButton submitButton;
    private JPasswordField reEnterPasswordPasswordField;
    private JPanel mainPanel;




    public createAccount() {
        submitButton.addActionListener(new ActionListener() {

            @Override
            public void actionPerformed(ActionEvent e) {
                //To change body of implemented methods use File | Settings | File Templates.
            }
        });
        clearButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {

                //To change body of implemented methods use File | Settings | File Templates.
                firstNameField.setText("");
                lastNameField.setText("") ;
                eMailField.setText("");
                phoneField.setText("");
                usernameField.setText("");
                passwordField.setText("");
                reEnterPasswordPasswordField.setText("");


            }
        });
    }
}
