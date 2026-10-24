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
        SetFocus(TextBox10);
    }

    public void AddDate()
    {

        string connSting = @"dsn=AsutpDB";

        string AddSQL = "INSERT INTO Jarlik ([NameJarlik],[LnkNameJarlik]) VALUES ('" + TextBox10.Text + "','" + TextBox1.Text + "')";

        OdbcConnection conn = null;

        try
        {
            conn = new OdbcConnection(connSting);
            conn.Open();

            OdbcCommand cmd = conn.CreateCommand();
            cmd.CommandText = AddSQL;
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

    protected void Button1_Click(object sender, EventArgs e)
    {
        AddDate();
        Response.Redirect("./JR.aspx");
    }
}
