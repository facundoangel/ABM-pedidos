/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package org.pedidos;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.Month;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.pedidos.persistance.PedidoJpaController;

/**
 * Servlet implementation class ControladorPedServlet
 */
@WebServlet("/ControladorPedServlet")
public class ControladorPedServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public ControladorPedServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
     * response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        
        
        //request.getRequestDispatcher("index.jsp").forward(request, response);
        request.setAttribute("success", "true");
        request.setAttribute("error", null);
        List<String> errors = new ArrayList<>();

        
        
        
        String nameCustomer = request.getParameter("name-customer");
        String phoneCustomer = request.getParameter("phone-customer");
        String typeReceivedCustomer = request.getParameter("tipo-entrega");
        String TableCustomer = request.getParameter("mesa-repartidor");
        String addressCustomer = request.getParameter("direccion-entrega");
        String itemsCustomer = request.getParameter("items-pedido");
        String amountCustomerStr = request.getParameter("total-pedido");
        float amountCustomer = 0.0f;
        String typePaymentCustomer = request.getParameter("tipo-pago");
        
        
        
        

        if (nameCustomer == null || nameCustomer.isEmpty()) {
            request.setAttribute("success", "false");
            errors.add("Es necesario un nombre para el cliente");
        }

        if (phoneCustomer == null || phoneCustomer.isEmpty() || phoneCustomer.matches("/^[+ 0-9]{1,}$/")) {
            request.setAttribute("success", "false");
            errors.add("Se debe proveer un numero de telefono valido");
        }

        if (typeReceivedCustomer == null || typeReceivedCustomer.isEmpty()) {
            request.setAttribute("success", "false");
            errors.add("Es necesario especificar tipo de entrega");
        }

        if ((TableCustomer == null || TableCustomer.isEmpty()) && ( typeReceivedCustomer != null && typeReceivedCustomer.equalsIgnoreCase("salon"))) {
            request.setAttribute("success", "false");
            errors.add("Si el pedido es para el salon, es necesario especificar la mesa");
        }

        if ((addressCustomer == null || addressCustomer.isEmpty()) && (typeReceivedCustomer != null && typeReceivedCustomer.equalsIgnoreCase("delivery"))) {
            request.setAttribute("success", "false");
            errors.add("Si el pedido es para enviar, la direccion no puede estar vacia");
        }

        if (itemsCustomer == null || itemsCustomer.isEmpty()) {
            request.setAttribute("success", "false");
            errors.add("Es especificar los itemas que estan pedidos");
        }
        
        if(amountCustomerStr == null || amountCustomerStr.isEmpty()){
            request.setAttribute("success", "false");
            errors.add("Es necesario especificar un precio valido para el pedido");
        }else{
            amountCustomer = Float.parseFloat(amountCustomerStr);
        }

        if (typePaymentCustomer == null || typePaymentCustomer.isEmpty()) {
            request.setAttribute("success", "false");
            errors.add("Es necesario especificar tipo de pago");
        }

        if (request.getAttribute("success").equals("false")) {
            
            request.setAttribute("error", errors.toString());
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
        

        PedidoJpaController contr = new PedidoJpaController();


        Pedido new_pedido = new Pedido(1313, nameCustomer,typeReceivedCustomer, addressCustomer, TableCustomer, amountCustomer, "nuevo", LocalDateTime.of(2026, Month.MARCH, 10, 14, 30), itemsCustomer);

        contr.create(new_pedido);
        
        
        //request.getRequestDispatcher("index.jsp").forward(request, response);
        response.sendRedirect(request.getContextPath());
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
     * response)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub
        
        
        String new_state_order = request.getParameter("estado-nuevo");
        int id_order = Integer.parseInt(request.getParameter("id-pedido"));
                
        
        
        PedidoJpaController controllerPedido = new PedidoJpaController();
        
        Pedido ped = controllerPedido.findById(id_order);
        ped.setEstado(new_state_order);
        
        try {
            controllerPedido.update(ped);
            controllerPedido.close();
            response.sendRedirect(request.getContextPath());
        } catch (Exception ex) {
            System.getLogger(ControladorPedServlet.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
        }
        
        
        
    }
    
    
 
}
