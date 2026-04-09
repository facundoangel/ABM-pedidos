
<%@page import="org.pedidos.persistance.PedidoJpaController"%>
<%@page import="java.util.Arrays"%>
<%@page import="org.pedidos.Pedido"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.Month" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FUOCO — Gestión de Pedidos</title>
    <link
            href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=DM+Sans:ital,wght@0,300;0,400;0,500;0,700;1,300&display=swap"
            rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
 
</head>

<body>

<%



    List<Pedido> pedidos = new ArrayList<>();
    List<String> items = new ArrayList<>();
    String query = request.getParameter("status");
    String query_type_order = request.getParameter("type");
    if(query!=null)
        query.replaceAll("-", " ");
    String query_search = request.getParameter("search");
    
    
    
    
    PedidoJpaController controllerPedidos = new PedidoJpaController();
    
    
    List<Pedido> pedidos_from_db = controllerPedidos.findAll();
    
    pedidos.addAll(pedidos_from_db);

    if(pedidos.size()==0){
        items.add("Pizza de muzzarella");
        items.add("Cocacola");
        items.add("Faina");
        pedidos.add(new Pedido(1212,"Facundo","delivery","Almafuerte 123",null,12.35f,"preparacion",
                LocalDateTime.of(2026, Month.MARCH, 10, 14, 30),items.toString()));
        items = new ArrayList<>();


        items.add("Hamburguesa completa");
        items.add("Papas fritas");
        items.add("Sprite");
        pedidos.add(new Pedido(1213,"Mariana","salon",null,"5",18.50f,"nuevo",
                LocalDateTime.of(2026, Month.MARCH, 10, 14, 45),items.toString()));
        items = new ArrayList<>();


        items.add("Empanada de carne");
        items.add("Empanada de pollo");
        items.add("Cerveza");
        pedidos.add(new Pedido(1214,"Carlos","delivery","Av. San Martin 456",null,9.75f,"en camino",
                LocalDateTime.of(2026, Month.MARCH, 10, 15, 10),items.toString()));
        items = new ArrayList<>();


        items.add("Milanesa con papas");
        items.add("Agua mineral");
        pedidos.add(new Pedido(1215,"Lucia","salon",null,"2",15.20f,"listo",
                LocalDateTime.of(2026, Month.MARCH, 10, 15, 20),items.toString()));
        items = new ArrayList<>();


        items.add("Pizza napolitana");
        items.add("Pepsi");
        pedidos.add(new Pedido(1216,"Jorge","delivery","Belgrano 789",null,14.60f,"nuevo",
                LocalDateTime.of(2026, Month.MARCH, 10, 15, 40),items.toString()));
        items = new ArrayList<>();
    }
       

    
    int qunatity_sales = pedidos.size();
    int earnings, new_sales, preparation_sales, complete_sales, on_way_sales, cancelled_sales, completed_sales;
    earnings = new_sales = preparation_sales = complete_sales = on_way_sales = cancelled_sales = completed_sales = 0;
    
    
    float average_sales = 0f;
    

    for(Pedido ped : pedidos){
        earnings += (int) ped.getPrecio();
        switch(ped.getEstado()){
            case "nuevo":
                new_sales++;
                break;
            case "preparacion":
                preparation_sales++;
                break;
            case "en camino":
                on_way_sales++;
                break;
            case "cancelled":
                cancelled_sales++;
                break;
            case "listo":
                completed_sales++;
                break;
        }
    }
        
    
    average_sales = earnings / qunatity_sales;
    
    

%>
<div class="app">

    <!-- TOPBAR -->
    <header class="topbar">
        <div style="display:flex;align-items:center;gap:12px;">
            <button class="hamburger" id="hamburgerBtn" onclick="toggleSidebar()" aria-label="Menú">
                <span></span><span></span><span></span>
            </button>
            <div class="logo">🔥 <span>FUOCO</span>
                <div class="logo-dot"></div>
            </div>
        </div>
        <!--<div class="topbar-center">
            <button class="tab-btn active" onclick="switchTab(this)">Pedidos</button>
            <button class="tab-btn" onclick="switchTab(this)">Cocina</button>
            <button class="tab-btn" onclick="switchTab(this)">Menú</button>
            <button class="tab-btn" onclick="switchTab(this)">Reportes</button>
        </div>-->
       
    </header>

    <!-- SIDEBAR OVERLAY -->
    <div class="sidebar-overlay" id="sidebarOverlay" onclick="closeSidebar()"></div>

    <!-- SIDEBAR -->
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-section">General</div>
        <div class="nav-item <%= query == null ? "active" : "" %>" onclick="setNav(this)">
            <span class="nav-icon">📋</span> Todos los pedidos
            <span class="badge"><%= qunatity_sales %></span>
        </div>
            <div class="nav-item <%= query != null && query.equals("nuevo") ? "active" : "" %>" onclick="setNav(this)" data-value="nuevo">
            <span class="nav-icon">🔵</span> Nuevos
            <% if(new_sales>0){%>
            <span class="badge"><%= new_sales %></span>
            <%}%>
        </div>
        <div class="nav-item <%= query != null && query.equals("preparacion") ? "active" : "" %>" onclick="setNav(this)" data-value="preparacion">
            <span class="nav-icon">🍕</span> En preparación
            <% if(preparation_sales>0){%>
            <span class="badge yellow"><%= preparation_sales %></span>
            <%}%>
        </div>
        <div class="nav-item <%= query != null && query.equals("listo") ? "active" : "" %>" onclick="setNav(this)" data-value="listo">
            <span class="nav-icon">✅</span> Listos
            <% if(completed_sales>0){%>
            <span class="badge green"><%= completed_sales %></span>
            <%}%>
        </div>
        <div class="nav-item <%= query != null && query.equals("en camino") ? "active" : "" %>" onclick="setNav(this)" data-value="en-camino">
            <span class="nav-icon">🛵</span> En camino
            <% if(on_way_sales>0){%>
            <span class="badge"><%= on_way_sales %></span>
            <%}%>
        </div>
        <div class="nav-item <%= query != null && query.equals("cancelados") ? "active" : "" %>" onclick="setNav(this)" data-value="cancelados">
            <span class="nav-icon">✗</span> Cancelados
            <% if(cancelled_sales>0){%>
            <span class="badge"><%= cancelled_sales %></span>
            <%}%>
        </div>
        
    </aside>

    <!-- MAIN -->
    <main class="main">
        <div class="page-header">
            <div>
                <% if(request.getAttribute("success") != null && request.getAttribute("success").equals("false")){

                    String errors_string = String.valueOf(request.getAttribute("error"));
                    List<String> errors_in_process = Arrays.asList(errors_string.split(",")); 

                    List<String> errors_to_show = new ArrayList<>(errors_in_process);
                     
                    %><div class="page-subtitle">Errores al crear pedido:</div><%
                    for(String error : errors_to_show){
                %><div><span class="status-badge s-error"><%= error%></span></div><%
                    }
                request.setAttribute("error", null);
                }%>
                <div class="page-title">PEDIDOS HOY</div>
            </div>
            <button class="btn-primary" onclick="openModal()">
                <span>＋</span> Nuevo Pedido
            </button>
        </div>

        <div class="stats-grid">
            <div class="stat-card fire">
                <div class="stat-label">Pedidos Totales</div>
                <div class="stat-value"><%= qunatity_sales %></div>
            </div>
            <div class="stat-card gold">
                <div class="stat-label">Ingresos del Día</div>
                <div class="stat-value">$<%= earnings %></div>
            </div>
            <div class="stat-card blue">
                <div class="stat-label">Ticket Promedio</div>
                <div class="stat-value">$<%= average_sales %></div>
            </div>

        </div>
            <div class="page-subtitle">Filtrar por tipo de pedido:</div>
        <div class="filters">
            
            <button data-value="delivery" class="filter-btn <%= query_type_order!=null && query_type_order.equals("delivery") ? "active": "" %>" onclick="setFilter(this)">Delivery</button>
            <button data-value="salon" class="filter-btn <%= query_type_order!=null && query_type_order.equals("salon") ? "active": "" %>" onclick="setFilter(this)">Salón</button>
            <div class="search-bar">
                <span style="color:var(--mist)">🔍</span>
                <input id="nro-order" type="text" placeholder="Numero de pedido..." value="<%= query_search!=null ? query_search : ""%>">
                <button type="button"class="btn-primary" id="btn-find">
                    Buscar
                </button>
            </div>
        </div>

        <div class="orders-table">
            <div class="table-head">
                <div>N° Pedido</div>
                <div>Cliente</div>
                <div>Items</div>
                <div>Total</div>
                <div>Estado</div>
                <div>Hora</div>
                <div>Acciones</div>
            </div>



            <%
                int contador = 1;
                
                
                    
                      
                for(Pedido ped : pedidos){
                    
                    
                    if(query_search != null && !query_search.isEmpty() && ped.getId()!=Integer.parseInt(query_search))
                            continue;
                    
                    if(query != null && !query.isEmpty() && !ped.getEstado().equalsIgnoreCase(query.replaceAll("-", " ")))
                            continue;
                    
                    if(query_type_order != null && !query_type_order.isEmpty() && !ped.getTipo_entrega().equalsIgnoreCase(query_type_order))
                            continue;
                %>

                <div class="order-row" id="row<%=contador%>" style="animation-delay:0s"
                        data-order="<%=ped.getId()%>" data-nombre-cliente="<%=ped.getNombre_cliente()%>" data-items="<%=ped.getItems()%>"
                        data-total="<%=ped.getPrecio()%>" data-direccion="<%=ped.getDireccion()%>" data-estado="<%=ped.getEstado()%>"
                     >
                    <div class="order-id">#<%=ped.getId()%></div>
                    <div class="customer-info">
                        <span class="customer-name"><%=ped.getNombre_cliente()%></span>
                        <%if(ped.getTipo_entrega().equalsIgnoreCase("Delivery")){%>
                            <span class="customer-detail">🛵 Delivery · <%=ped.getDireccion()%></span>
                        <%}%>
                        <%if(ped.getTipo_entrega().equalsIgnoreCase("Salon")){%>
                        <span class="customer-detail">🪑 Salón · Mesa <%=ped.getMesa()%></span>
                        <%}%>
                    </div>
                    <div class="items-chips">   
                        <%
                            String items_data_raw = ped.getItems();
                            items_data_raw = items_data_raw.replace("[", "").replace("]", "");
                            String[] items_data = items_data_raw.split(",");
                            List<String> items_array = new ArrayList<>(Arrays.asList(items_data));
                            
                            for(String item : items_array){%>
                        <span class="chip"><%= item%></span>
                        <% }%>
                    </div>
                    <div class="order-total">$<%=ped.getPrecio()%></div>
                    <%
                        String estado_pedido = "";
                        if(ped.getEstado().equalsIgnoreCase("nuevo"))
                            estado_pedido = "s-nuevo";
                        if(ped.getEstado().equalsIgnoreCase("preparacion"))
                            estado_pedido = "s-preparando";
                        if(ped.getEstado().equalsIgnoreCase("listo"))
                            estado_pedido = "s-listo";
                        if(ped.getEstado().equalsIgnoreCase("en camino"))
                            estado_pedido = "s-entregando";
                    %>
                    <div><span class="status-badge <%=estado_pedido%>"><%=ped.getEstado()%></span></div>
                    <%
                        DateTimeFormatter formato = DateTimeFormatter.ofPattern("H:m");
                        String fechaFormateada = ped.getHora().format(formato);
                    %>
                    <div class="order-time"><%=fechaFormateada%></div>
                    <form id="form-change-status-<%=ped.getId()%>" class="action-btns" action="<%= request.getContextPath()%>/ControladorPedServlet" method="POST">
                        <select id="select-state-<%=ped.getId()%>" class="form-input" name="estado-nuevo" onclick="event.stopPropagation()">
                            <option value="nuevo"       <%=ped.getEstado().equalsIgnoreCase("nuevo")       ? "selected" : ""%>>Nuevo</option>
                            <option value="preparacion" <%=ped.getEstado().equalsIgnoreCase("preparacion") ? "selected" : ""%>>Preparación</option>
                            <option value="listo"       <%=ped.getEstado().equalsIgnoreCase("listo")       ? "selected" : ""%>>Listo</option>
                            <option value="en camino"   <%=ped.getEstado().equalsIgnoreCase("en camino")   ? "selected" : ""%>>En camino/Por servir</option>
                            <option value="cancelado"   <%=ped.getEstado().equalsIgnoreCase("cancelado")   ? "selected" : ""%>>Cancelado</option>
                        </select>
                        <input name="id-pedido" type="hidden" value="<%=ped.getId()%>"/>
                    </form>
                </div>
                <script>
                    document.getElementById("row<%=contador%>").addEventListener("click",function(e){
                        selectOrder(this);
                    });
                    document.getElementById("select-state-<%=ped.getId()%>").addEventListener("change",()=>{
                        document.getElementById("form-change-status-<%=ped.getId()%>").submit();
                    });
                    
                    
                </script>
            <%
                       contador++;
                    if(query_search != null && !query_search.isEmpty() && ped.getId()==Integer.parseInt(query_search))
                        break;
                    
                }


                if(contador==1){
            %>
                    
                    <div class="" id="row2" style="text-align: center; padding: 20px">
                        ❌ No se encontraron pedidos
                    </div>
            
                
               <% }%>

        </div>
    </main>

    <!-- PANEL OVERLAY (mobile) -->
    <div class="panel-overlay" id="panelOverlay" onclick="closePanel()"></div>

    <!-- RIGHT PANEL -->
    <aside class="panel" id="detailPanel">
        <div class="panel-header">
            <div class="panel-title">DETALLE</div>
            <div style="display:flex;align-items:center;gap:10px;">
                <span style="font-size:11px; color:var(--mist)" id="panelSubtitle">Pedido activo</span>
                <button class="panel-close-btn" onclick="closePanel()">✕</button>
            </div>
        </div>
        <div class="panel-body" id="panelBody">

            <div class="detail-header">
                <div class="detail-order-id">#1042</div>
                <div class="detail-meta">Martina López · 🛵 Delivery · hace 12 min</div>
            </div>

            <div class="detail-section">
                <div class="detail-section-title">Items del pedido</div>
                <div class="detail-section-order"></div>

                <div class="total-row">
                    <span class="total-label">Total</span>
                    <span class="total-amount">$38.00</span>
                </div>
            </div>

            <div class="detail-section">
                <div class="detail-section-title">Dirección de entrega</div>
                <div class="address-card">
                    <div class="street">Av. Corrientes 1240, Piso 3 "B"</div>
                    <div style="font-size:12px;color:var(--mist)">CABA, Buenos Aires</div>
                </div>
            </div>

            <div class="detail-section">
                <div class="detail-section-title">Estado del pedido</div>
                <div class="timeline">
                    <div class="tl-item">
                        <div class="tl-dot done"></div>
                        <div class="tl-label">Nuevo</div>
                        <div class="tl-time">En progreso...</div>
                    </div>
                    <div class="tl-item">
                        <div class="tl-dot done"></div>
                        <div class="tl-label">En Preparación</div>
                        <div class="tl-time">En progreso...</div>
                    </div>
                    <div class="tl-item">
                        <div class="tl-dot current"></div>
                        <div class="tl-label">En camino / Por servir a mesa</div>
                        <div class="tl-time">En progreso...</div>
                    </div>
                    <div class="tl-item">
                        <div class="tl-dot future"></div>
                        <div class="tl-label" style="color:var(--mist)">Listo</div>
                    </div>
                </div>
            </div>
        </div>
    </aside>

</div>

<!-- MODAL -->
<div class="modal-overlay" id="modal" onclick="closeModal(event)">
    <form name="new-order" method="GET" action="<%= request.getContextPath()%>/ControladorPedServlet">
    	<div class="modal">
	        <div class="modal-title">NUEVO PEDIDO</div>
	        <div class="form-grid">
	            <div class="form-group">
	                <label class="form-label">Nombre cliente</label>
	                <input required class="form-input" type="text" placeholder="Ej: Juan García" name="name-customer">
	            </div>
	            <div class="form-group">
	                <label class="form-label">Teléfono</label>
	                <input required class="form-input" type="text" placeholder="+54 11 0000-0000" name="phone-customer">
	            </div>
	            <div class="form-group">
	                <label class="form-label">Tipo</label>
	                <select class="form-input" name="tipo-entrega">
	                    <option value="delivery">🛵 Delivery</option>
	                    <option value="salon">🪑 Salón</option>
	                    <option value="retiro">🏃 Retiro</option>
	                </select>
	            </div>
	            <div class="form-group">
	                <label class="form-label">Mesa / Repartidor</label>
	                <input required class="form-input" type="text" placeholder="Mesa 3 / Juan" name="mesa-repartidor">
	            </div>
	            <div class="form-group full">
	                <label class="form-label">Dirección</label>
	                <input required class="form-input" type="text" placeholder="Calle, número, piso, dpto..." name="direccion-entrega">
	            </div>
	            <div class="form-group full">
	                <label class="form-label">Items del pedido</label>
	                <input required class="form-input" type="text" placeholder="x2 Margherita, x1 Coca-Cola..." name="items-pedido">
	            </div>
	            <div class="form-group">
	                <label class="form-label">Total</label>
	                <input required class="form-input" type="text" placeholder="$0.00" name="total-pedido">
	            </div>
	            <div class="form-group">
	                <label class="form-label">Pago</label>
	                <select class="form-input" name="tipo-pago">
	                    <option>Efectivo</option>
	                    <option>Tarjeta</option>
	                    <option>Transferencia</option>
	                </select>
	            </div>
	            <div class="form-group full">
	                <label class="form-label">Notas adicionales</label>
	                <input required class="form-input" type="text" placeholder="Sin cebolla, extra queso..." name="notas-pedido">
	            </div>
	        </div>
	        <div class="modal-footer">
	            <button type="button" class="btn-cancel" onclick="closeModal()">Cancelar</button>
	            <button class="btn-confirm" onclick="submitOrder()">Crear Pedido →</button>
	        </div>
	    </div>
    </form>
</div>

<!-- TOAST -->
<div class="toast" id="toast">
    <span class="toast-icon">✓</span>
    <span id="toastText">Acción completada</span>
</div>

<script>
    /* ─── helpers ─── */
    const isMobile = () => window.innerWidth <= 768;
    
   

    /* ─── TABS ─── */
    function switchTab(el) {
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        el.classList.add('active');
    }
    

    /* ─── NAV ─── */
    function setNav(el) {
        document.querySelectorAll('.nav-item').forEach(n => n.classList.remove('active'));
        el.classList.add('active');
        if (isMobile()) closeSidebar();
        if(el.dataset.value)
            location.search="status="+el.dataset.value;
        else
            location.search="";
    }

    /* ─── FILTER ─── */
    function setFilter(el) {
        document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
        const search = new URLSearchParams(location.search);
        const term_search = search.get("type");
        if(!term_search || term_search != el.dataset.value){
            el.classList.add('active');
            search.set("type",el.dataset.value);
            location.search="?"+search.toString();
            return;
        }
        
        if(term_search == el.dataset.value){
            el.classList.remove('active');
            search.delete("type");
            location.search="?"+search.toString();
        }
    }
    
    document.getElementById("btn-find").addEventListener("click",()=>{
        const search = new URLSearchParams(location.search);
        const search_term = document.getElementById("nro-order").value;
        search.set("search",search_term);
        location.search="?"+search.toString();
    });

    /* ─── SIDEBAR (mobile/tablet drawer) ─── */
    function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const overlay = document.getElementById('sidebarOverlay');
        const btn = document.getElementById('hamburgerBtn');
        const isOpen = sidebar.classList.contains('open');
        if (isOpen) {
            closeSidebar();
        } else {
            sidebar.classList.add('open');
            overlay.classList.add('show');
            btn.classList.add('open');
            document.body.style.overflow = 'hidden';
        }
    }

    function closeSidebar() {
        document.getElementById('sidebar').classList.remove('open');
        document.getElementById('sidebarOverlay').classList.remove('show');
        document.getElementById('hamburgerBtn').classList.remove('open');
        document.body.style.overflow = '';
    }

    /* ─── PANEL (detail) ─── */
    function openPanel(data) {
        const panel = document.getElementById('detailPanel');
        const overlay = document.getElementById('panelOverlay');
        panel.classList.add('open');
        overlay.classList.add('show');
        document.body.style.overflow = 'hidden';
        
        
        
        
        panel.querySelector(".detail-order-id").innerText="#"+data.order;
        panel.querySelector(".detail-meta").innerText=data.nombreCliente+" · 🛵 Delivery";
        const items = data.items.replace("[","").replace("]","").split(",");
        const items_panel = panel.querySelector(".detail-section-order");
        items_panel.innerHTML="";

        items.forEach(item => {
            let new_elem = `
                <div class="item-line">
                    <span class="item-qty">x1</span>
                    <span class="item-name">`;
             new_elem += item + "</span></div>";
            items_panel.innerHTML += new_elem;
        });
        
        
        panel.querySelector(".total-amount").innerText="$"+data.total;
        panel.querySelector(".street").innerText=data.direccion;
        
        const states = panel.querySelectorAll(".timeline .tl-item");
        debugger;
        switch(data.estado){
            case "nuevo":
                states[0].children[0].setAttribute("class","tl-dot current");
                states[1].children[0].setAttribute("class","tl-dot future");
                states[2].children[0].setAttribute("class","tl-dot future");
                states[3].children[0].setAttribute("class","tl-dot future");
                break;

            case "preparacion":
                states[0].children[0].setAttribute("class","tl-dot done");
                states[1].children[0].setAttribute("class","tl-dot current");
                states[2].children[0].setAttribute("class","tl-dot future");
                states[3].children[0].setAttribute("class","tl-dot future");
                break;

            case "en camino":
                states[0].children[0].setAttribute("class","tl-dot done");
                states[1].children[0].setAttribute("class","tl-dot done");
                states[2].children[0].setAttribute("class","tl-dot current");
                states[3].children[0].setAttribute("class","tl-dot future");
                break;

            case "listo":
                states[0].children[0].setAttribute("class","tl-dot done");
                states[1].children[0].setAttribute("class","tl-dot done");
                states[2].children[0].setAttribute("class","tl-dot done");
                states[3].children[0].setAttribute("class","tl-dot current");
                break;
        }
        
    }

    function closePanel() {
        const panel = document.getElementById('detailPanel');
        const overlay = document.getElementById('panelOverlay');
        panel.classList.remove('open');
        overlay.classList.remove('show');
        document.body.style.overflow = '';
        // deselect rows
        document.querySelectorAll('.order-row').forEach(r => r.classList.remove('selected'));
    }

    /* ─── SELECT ORDER ─── */
    function selectOrder(e) {
        if(!e)
            return;
 
        openPanel(e.dataset);
    }

    /* ─── MODAL ─── */
    function openModal() {
        document.getElementById('modal').classList.add('open');
        document.body.style.overflow = 'hidden';
    }

    function closeModal(e) {
        if (!e || e.target === document.getElementById('modal')) {
            document.getElementById('modal').classList.remove('open');
            document.body.style.overflow = '';
        }
    }

    function submitOrder() {
        
        let empty_field = false;
        document.querySelectorAll("#modal form input[type='text'], #modal form input[type='number']").forEach(field => {
            if(field.value=="")
                empty_field=true;
        })

        if(empty_field)
            return;
        
        
        closeModal();
        toastMsg('✅ Nuevo pedido creado y enviado a cocina');
    }

    /* ─── TOAST ─── */
    let toastTimer;
    function toastMsg(msg) {
        const toast = document.getElementById('toast');
        document.getElementById('toastText').textContent = msg;
        toast.classList.add('show');
        clearTimeout(toastTimer);
        toastTimer = setTimeout(() => toast.classList.remove('show'), 3000);
    }

    
    <% if(request.getAttribute("success") != null && request.getAttribute("success").equals("true")){
    	%>alert("exito en creación");<%
        request.setAttribute("success","");
    }%>
        
        
    

</script>
</body>

</html>
