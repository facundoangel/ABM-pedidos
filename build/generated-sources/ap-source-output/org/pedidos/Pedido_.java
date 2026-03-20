package org.pedidos;

import java.time.LocalDateTime;
import javax.annotation.processing.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="org.eclipse.persistence.internal.jpa.modelgen.CanonicalModelProcessor", date="2026-03-18T01:39:15", comments="EclipseLink-2.7.12.v20230209-rNA")
@StaticMetamodel(Pedido.class)
public class Pedido_ { 

    public static volatile SingularAttribute<Pedido, Float> precio;
    public static volatile SingularAttribute<Pedido, String> estado;
    public static volatile SingularAttribute<Pedido, String> mesa;
    public static volatile SingularAttribute<Pedido, String> tipo_entrega;
    public static volatile SingularAttribute<Pedido, LocalDateTime> hora;
    public static volatile SingularAttribute<Pedido, String> direccion;
    public static volatile SingularAttribute<Pedido, Integer> id;
    public static volatile SingularAttribute<Pedido, String> items;
    public static volatile SingularAttribute<Pedido, String> nombre_cliente;

}