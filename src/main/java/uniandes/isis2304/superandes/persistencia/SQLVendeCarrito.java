package uniandes.isis2304.superandes.persistencia;

import java.util.List;

import javax.jdo.PersistenceManager;
import javax.jdo.Query;

import uniandes.isis2304.superandes.negocio.Item;

public class SQLVendeCarrito {

    /* ****************************************************************
     * 			Constantes
     *****************************************************************/
    /**
     * Cadena que representa el tipo de consulta que se va a realizar en las sentencias de acceso a la base de datos
     * Se renombra ac� para facilitar la escritura de las sentencias
     */
    private final static String SQL = PersistenciaSuperandes.SQL;

    /* ****************************************************************
     * 			Atributos
     *****************************************************************/
    /**
     * El manejador de persistencia general de la aplicaci�n
     */
    private PersistenciaSuperandes ps;

    /* ****************************************************************
     * 			M�todos
     *****************************************************************/
    /**
     * Constructor
     * @param ps - El Manejador de persistencia de la aplicaci�n
     */
    public SQLVendeCarrito (PersistenciaSuperandes ps)
    {
        this.ps = ps;
    }

    public long agregarVendeCarrito(PersistenceManager pm, long idCarrito, long idProducto, int cantidadCarrito)
    {
        Query q = pm.newQuery(SQL, "INSERT INTO " + ps.darTablaVendeCarrito () + "(idCarrito, idProducto, cantidadCarrito) values (?, ?, ?)");
        q.setParameters(idCarrito, idProducto, cantidadCarrito);
        return (long) q.executeUnique();
    }

	public List<Object[]> darListaItems(PersistenceManager pm,long idCarrito) {
		// TODO Auto-generated method stub

		String sql = "SELECT " + ps.darTablaVendeCarrito() + ".idProducto AS IDPRODUCTO, " + ps.darTablaProductos() + ".NOMBRE AS NOMBRE, " + ps.darTablaVendeCarrito() + ".cantidadcarrito AS CANTIDAD, " + ps.darTablaVende() + ".precio AS PRECIO, ("  + ps.darTablaVende() + ".PRECIO * " + ps.darTablaVendeCarrito() + ".CANTIDADCARRITO) AS SUBTOTAL " + 
				"FROM((" + ps.darTablaVendeCarrito() + " "+ 
				"INNER JOIN " + ps.darTablaCarritoCompras() + " ON "+ ps.darTablaCarritoCompras() + ".id = " + ps.darTablaVendeCarrito() + ".idCarrito " + 
				"INNER JOIN " + ps.darTablaVende() + " ON " + ps.darTablaCarritoCompras() + ".idSucursal = "+ ps.darTablaVende() + ".idSucursal AND " + ps.darTablaVende() + ".idProducto = " + ps.darTablaVendeCarrito() + ".idProducto) " + 
				"INNER JOIN " + ps.darTablaProductos() + " ON " + ps.darTablaVendeCarrito() + ".idProducto = " + ps.darTablaProductos() + ".id) " + 
				"WHERE " + ps.darTablaCarritoCompras() + ".id = ?";
		Query q = pm.newQuery(SQL,sql);
		q.setParameters(idCarrito);
		return q.executeList();
	}

    
}
