/*
 * Clase controladora JPA para la entidad Pedido
 * Proveedor de persistencia: EclipseLink
 */
package org.pedidos.persistance;

import java.time.LocalDateTime;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.TypedQuery;
import org.pedidos.Pedido;

public class PedidoJpaController {

    private EntityManagerFactory emf;

    // El nombre debe coincidir con el persistence-unit en persistence.xml
    public PedidoJpaController() {
        this.emf = Persistence.createEntityManagerFactory("WebApplication1PU");
    }

    public PedidoJpaController(EntityManagerFactory emf) {
        this.emf = emf;
    }

    private EntityManager getEntityManager() {
        return emf.createEntityManager();
    }

    // ── CREATE ──────────────────────────────────────────────────────────────
    public void create(Pedido pedido) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(pedido);
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw ex;
        } finally {
            em.close();
        }
    }

    // ── UPDATE ──────────────────────────────────────────────────────────────
    public void update(Pedido pedido) throws Exception {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            pedido = em.merge(pedido);
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw ex;
        } finally {
            em.close();
        }
    }

    // ── DELETE ──────────────────────────────────────────────────────────────
    public void delete(int id) throws Exception {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            Pedido pedido = em.find(Pedido.class, id);
            if (pedido == null) {
                throw new Exception("El pedido con id " + id + " no existe.");
            }
            em.remove(pedido);
            em.getTransaction().commit();
        } catch (Exception ex) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw ex;
        } finally {
            em.close();
        }
    }

    // ── FIND BY ID ──────────────────────────────────────────────────────────
    public Pedido findById(int id) {
        EntityManager em = getEntityManager();
        try {
            return em.find(Pedido.class, id);
        } finally {
            em.close();
        }
    }

    // ── FIND ALL ────────────────────────────────────────────────────────────
    public List<Pedido> findAll() {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Pedido> query = em.createQuery(
                "SELECT p FROM Pedido p", Pedido.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    // ── FIND BY ESTADO ──────────────────────────────────────────────────────
    public List<Pedido> findByEstado(String estado) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Pedido> query = em.createQuery(
                "SELECT p FROM Pedido p WHERE p.estado = :estado", Pedido.class);
            query.setParameter("estado", estado);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    // ── FIND BY CLIENTE ─────────────────────────────────────────────────────
    public List<Pedido> findByCliente(String nombreCliente) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Pedido> query = em.createQuery(
                "SELECT p FROM Pedido p WHERE p.nombre_cliente = :nombre", Pedido.class);
            query.setParameter("nombre", nombreCliente);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    // ── FIND BY TIPO ENTREGA ────────────────────────────────────────────────
    public List<Pedido> findByTipoEntrega(String tipoEntrega) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Pedido> query = em.createQuery(
                "SELECT p FROM Pedido p WHERE p.tipo_entrega = :tipo", Pedido.class);
            query.setParameter("tipo", tipoEntrega);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    // ── FIND BY RANGO DE HORA ───────────────────────────────────────────────
    public List<Pedido> findByRangoHora(LocalDateTime desde, LocalDateTime hasta) {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Pedido> query = em.createQuery(
                "SELECT p FROM Pedido p WHERE p.hora BETWEEN :desde AND :hasta", Pedido.class);
            query.setParameter("desde", desde);
            query.setParameter("hasta", hasta);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    // ── COUNT ───────────────────────────────────────────────────────────────
    public int count() {
        EntityManager em = getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(p) FROM Pedido p", Long.class);
            return query.getSingleResult().intValue();
        } finally {
            em.close();
        }
    }

    // ── CERRAR FACTORY ──────────────────────────────────────────────────────
    public void close() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}