using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Data.Odbc;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            Zapolnit();

        }
    }

    public void Zapolnit()
    {
        string id = Request.QueryString["id"];
        string connSting = @"dsn=AsutpDB";
        string strSQL = @"select * from Jarlik where IDJarlik=" + id;
        OdbcConnection conn = null;
        OdbcDataReader reader = null;
        try
        {
            conn = new OdbcConnection(connSting);
            conn.Open();

            OdbcCommand cmd = new OdbcCommand(strSQL, conn);
            reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                TextBox10.Text = reader["NameJarlik"].ToString();
                TextBox1.Text = reader["LnkNameJarlik"].ToString();

            }
        }
        catch (Exception)
        {

            throw;
        }
        finally
        {
            reader.Close();
            reader.Dispose();
            conn.Close();
            conn.Dispose();
        }
    }

    public void UpdateDate()
    {
        string id = Request.QueryString["id"];
        string connSting = @"dsn=AsutpDB";
        string updateSQL = "UPDATE Jarlik SET NameJarlik='" + TextBox10.Text + "',LnkNameJarlik='" + TextBox1.Text + "' where IDJarlik=" + id;

        OdbcConnection conn = null;
        //OdbcDataReader reader = null;
        try
        {
            conn = new OdbcConnection(connSting);
            conn.Open();

            OdbcCommand cmd = conn.CreateCommand();
            cmd.CommandText = updateSQL;
            cmd.ExecuteNonQuery();

        }
        catch (Exception)
        {

            throw;
        }
        finally
        {

            conn.Close();
            conn.Dispose();
        }
    }
    public void DeleteDate()
    {
        string id = Request.QueryString["id"];
        string connSting = @"dsn=AsutpDB";
        string DeleteSQL = "DELETE FROM Jarlik WHERE IDJarlik=" + id;

        OdbcConnection conn = null;

        try
        {
            conn = new OdbcConnection(connSting);
            conn.Open();

            OdbcCommand cmd = conn.CreateCommand();
            cmd.CommandText = DeleteSQL;
            cmd.ExecuteScalar();

        }
        catch (Exception)
        {

            throw;
        }
        finally
        {

            conn.Close();
            conn.Dispose();
        }

    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        UpdateDate();
        Response.Redirect("./JR.aspx");
    }
    protected void Button2_Click(object sender, EventArgs e)
    {
        DeleteDate();
        Response.Redirect("./JR.aspx");
    }
}
