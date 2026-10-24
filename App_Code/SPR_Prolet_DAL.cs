using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.Odbc;

public class SPR_Prolet
{
    public int ProletID { get; set; }
    public int ShopID { get; set; }
    public int Prolet { get; set; }
    public string Prolet_name { get; set; }
}
/// <summary>
/// Сводное описание для SPR_Prolet_DAL
/// </summary>
public class SPR_Prolet_DAL
{
    public static List<SPR_Prolet> GetAllProlet(string ShopID)
    {
        List<SPR_Prolet> listSPRProlets = new List<SPR_Prolet>();
        string connSting = @"dsn=AsutpDB";
        string strSQL;
        strSQL = "SELECT ShopID, Prolet, Prolet_name FROM NameProlet WHERE ShopID = ? ORDER BY Prolet";
        using (OdbcConnection conn = new OdbcConnection(connSting))
        {
            conn.Open();
            OdbcCommand cmd = new OdbcCommand(strSQL, conn);
            // OdbcParameter param = new OdbcParameter("@ShopID", ShopID);

            cmd.Parameters.Add("@ShopID", ShopID);
            OdbcDataReader reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                SPR_Prolet sprProlet = new SPR_Prolet();

                sprProlet.ProletID = Convert.ToInt32(reader["ProletID"]);
                sprProlet.ShopID = Convert.ToInt32(reader["ShopID"]);
                sprProlet.Prolet = Convert.ToInt32(reader["Prolet"]);
                sprProlet.Prolet_name = reader["Prolet_name"].ToString();
                listSPRProlets.Add(sprProlet);
            }
        }

        return listSPRProlets;
    }
	public SPR_Prolet_DAL()
	{
		//
		// TODO: добавьте логику конструктора
		//
	}
}