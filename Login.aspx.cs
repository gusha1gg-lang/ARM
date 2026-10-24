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

    }

    protected bool SiteAuth(string UserName, string Password)
    { 
        string connSting = @"dsn=AsutpDB";
        string strSQL = @"select UserID from UserPass where Login='" + UserName + "' and Pass='" + Password+"'";
        OdbcConnection conn = null;
        OdbcDataReader reader = null;
        try
        {
            conn = new OdbcConnection(connSting);
            conn.Open();

            OdbcCommand cmd = new OdbcCommand(strSQL, conn);
            reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                return true;
                
            }
            else
            {
                return false;
                 
            }
        }
        catch (Exception)
        {
            return false;
        }
        finally
        {
            reader.Close();
            reader.Dispose();
            conn.Close();
            conn.Dispose();
        }
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        bool Authenticated = false;
        
        Authenticated = SiteAuth(Login.Text,Pass.Text);
        if (Authenticated)
        {
            Session.Contents["admin"] = "admin";  
            Server.Transfer("~/main.aspx");
        }
        else
        {
            Session.Contents["admin"] = null;
            Server.Transfer("~/main.aspx");
        }
    }
    protected void Button2_Click(object sender, EventArgs e)
    {
        if (Session.Contents["admin"] == "admin")
        {
            Response.Redirect("./spr_shop.aspx");
        }
        else
        {
            msg_label.Visible = true;
        }

    }
    protected void Button3_Click(object sender, EventArgs e)
    {
        if (Session.Contents["admin"] == "admin")
        {
            Response.Redirect("./SPR_CISCO.aspx?SPRType=1");
        }
        else
        {
            msg_label.Visible = true;
        }
    }
    protected void Button4_Click(object sender, EventArgs e)
    {
        if (Session.Contents["admin"] == "admin")
        {
            Response.Redirect("./SPR_CISCO.aspx?SPRType=2");
        }
        else
        {
            msg_label.Visible = true;
        }

    }
}
