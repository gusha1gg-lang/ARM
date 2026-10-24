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
        string strSQL = @"select * from IPaddress5 where IDPC=" + id;
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
                TextBox10.Text = reader["Uchastok"].ToString();
                TextBox2.Text = reader["Oc"].ToString();
                TextBox4.Text = reader["IPaddress"].ToString();
                TextBox6.Text = reader["MAC"].ToString();
                TextBox7.Text = reader["KE"].ToString();
                TextBox11.Text = reader["ConfigLogin"].ToString();
                TextBox8.Text = reader["Telephon"].ToString();
                TextBox1.Text = reader["Monitor"].ToString();
                TextBox3.Text = reader["Printer"].ToString();
                TextBox5.Text = reader["UPS"].ToString();
                TextBox9.Text = reader["Modem"].ToString();
                TextBox12.Text = reader["CISCO"].ToString();
                TextBox13.Text = reader["Opisanie"].ToString();
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
        string updateSQL = "UPDATE IPaddress5 SET Uchastok='" + TextBox10.Text + "',Oc='" + TextBox2.Text + "',IPaddress='" + TextBox4.Text + "',MAC='" + TextBox6.Text + "',KE='" + TextBox7.Text + "',ConfigLogin='" + TextBox11.Text + "',Telephon='" + TextBox8.Text + "',Monitor='" + TextBox1.Text + "',Printer='" + TextBox3.Text + "',UPS='" + TextBox5.Text + "',Modem='" + TextBox9.Text + "',CISCO='" + TextBox12.Text + "',Opisanie='" + TextBox13.Text + "' where IDPC=" + id;

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
        string DeleteSQL = "DELETE FROM IPaddress5 WHERE IDPC=" + id;

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
    protected void CustomValidKE_ServerValidate(object source, ServerValidateEventArgs args)
    {
        string connSting = @"dsn=AsutpDB";
        string id = Request.QueryString["id"];
        //        string strSQL = @"select IPaddress4.KE,IPAddressUch.KE,IPaddress5.KE 
        //                        from IPaddress4,IPAddressUch,IPaddress5 
        //                        where IPaddress4.KE='" + args.Value + "' OR IPAddressUch.KE='" + args.Value + "' OR IPaddress5.KE='" + args.Value + "'";
        string strSQL = @"select IPaddress4.KE from IPaddress4 where IDPC<>" + id + " AND IPaddress4.KE='" + args.Value + "'";
        string strSQL2 = @"select IPAddressUch.KE from IPAddressUch where IDPC<>" + id + " AND IPAddressUch.KE='" + args.Value + "'";
        string strSQL3 = @"select IPaddress5.KE from IPaddress5 where IDPC<>" + id + " AND IPaddress5.KE='" + args.Value + "'";
        string strSQL4 = @"select IPaddressALL.KE from IPaddressALL where IDPC<>" + id + " AND IPaddressALL.KE='" + args.Value + "'";
        OdbcConnection conn = null;
        OdbcDataReader reader = null;
        args.IsValid = true;
        try
        {
            conn = new OdbcConnection(connSting);
            conn.Open();

            OdbcCommand cmd = new OdbcCommand(strSQL, conn);
            reader = cmd.ExecuteReader();
            bool FindKE = reader.HasRows;
            reader.Close();
            cmd.CommandText = strSQL2;
            reader = cmd.ExecuteReader();
            bool FindKE2 = reader.HasRows;
            reader.Close();
            cmd.CommandText = strSQL3;
            reader = cmd.ExecuteReader();
            bool FindKE3 = reader.HasRows;
            reader.Close();
            cmd.CommandText = strSQL4;
            reader = cmd.ExecuteReader();
            bool FindKE4 = reader.HasRows;
            if (FindKE == true || FindKE2 == true || FindKE3 == true || FindKE4 == true)
            {
                args.IsValid = false;
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
    protected void CustomValidMonitor_ServerValidate(object source, ServerValidateEventArgs args)
    {
        string connSting = @"dsn=AsutpDB";
        string id = Request.QueryString["id"];
        //        string strSQL = @"select IPaddress4.KE,IPAddressUch.KE,IPaddress5.KE 
        //                        from IPaddress4,IPAddressUch,IPaddress5 
        //                        where IPaddress4.KE='" + args.Value + "' OR IPAddressUch.KE='" + args.Value + "' OR IPaddress5.KE='" + args.Value + "'";
        string strSQL = @"select IPaddress4.KE from IPaddress4 where IDPC<>" + id + " AND IPaddress4.Monitor LIKE '%" + args.Value + "%'";
        string strSQL2 = @"select IPAddressUch.KE from IPAddressUch where IDPC<>" + id + " AND IPAddressUch.Monitor LIKE '%" + args.Value + "%'";
        string strSQL3 = @"select IPaddress5.KE from IPaddress5 where IDPC<>" + id + " AND IPaddress5.Monitor LIKE '%" + args.Value + "%'";
        string strSQL4 = @"select IPaddressALL.KE from IPaddressALL where IDPC<>" + id + " AND IPaddressALL.Monitor LIKE '%" + args.Value + "%'";
        OdbcConnection conn = null;
        OdbcDataReader reader = null;
        args.IsValid = true;
        try
        {
            conn = new OdbcConnection(connSting);
            conn.Open();

            OdbcCommand cmd = new OdbcCommand(strSQL, conn);
            reader = cmd.ExecuteReader();
            bool FindKE = reader.HasRows;
            reader.Close();
            cmd.CommandText = strSQL2;
            reader = cmd.ExecuteReader();
            bool FindKE2 = reader.HasRows;
            reader.Close();
            cmd.CommandText = strSQL3;
            reader = cmd.ExecuteReader();
            bool FindKE3 = reader.HasRows;
            reader.Close();
            cmd.CommandText = strSQL4;
            reader = cmd.ExecuteReader();
            bool FindKE4 = reader.HasRows;
            if (FindKE == true || FindKE2 == true || FindKE3 == true || FindKE4 == true)
            {
                args.IsValid = false;
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
    protected void CustomValidPrint_ServerValidate(object source, ServerValidateEventArgs args)
    {
        string connSting = @"dsn=AsutpDB";
        string id = Request.QueryString["id"];
        //        string strSQL = @"select IPaddress4.KE,IPAddressUch.KE,IPaddress5.KE 
        //                        from IPaddress4,IPAddressUch,IPaddress5 
        //                        where IPaddress4.KE='" + args.Value + "' OR IPAddressUch.KE='" + args.Value + "' OR IPaddress5.KE='" + args.Value + "'";
        string strSQL = @"select IPaddress4.KE from IPaddress4 where IDPC<>" + id + " AND IPaddress4.Printer LIKE '%" + args.Value + "%'";
        string strSQL2 = @"select IPAddressUch.KE from IPAddressUch where IDPC<>" + id + " AND IPAddressUch.Printer LIKE '%" + args.Value + "%'";
        string strSQL3 = @"select IPaddress5.KE from IPaddress5 where IDPC<>" + id + " AND IPaddress5.Printer LIKE '%" + args.Value + "%'";
        string strSQL4 = @"select IPaddressALL.KE from IPaddressALL where IDPC<>" + id + " AND IPaddressALL.Printer LIKE '%" + args.Value + "%'";
        OdbcConnection conn = null;
        OdbcDataReader reader = null;
        args.IsValid = true;
        try
        {
            conn = new OdbcConnection(connSting);
            conn.Open();

            OdbcCommand cmd = new OdbcCommand(strSQL, conn);
            reader = cmd.ExecuteReader();
            bool FindKE = reader.HasRows;
            reader.Close();
            cmd.CommandText = strSQL2;
            reader = cmd.ExecuteReader();
            bool FindKE2 = reader.HasRows;
            reader.Close();
            cmd.CommandText = strSQL3;
            reader = cmd.ExecuteReader();
            bool FindKE3 = reader.HasRows;
            reader.Close();
            cmd.CommandText = strSQL4;
            reader = cmd.ExecuteReader();
            bool FindKE4 = reader.HasRows;
            if (FindKE == true || FindKE2 == true || FindKE3 == true || FindKE4 == true)
            {
                args.IsValid = false;
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
    protected void Button1_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            UpdateDate();
            Response.Redirect("./IpaddrT5.aspx");
        }
        else
        {
            Button3.Visible = true;
            Button1.Visible = false;
        }
    }
    protected void Button2_Click(object sender, EventArgs e)
    {
        DeleteDate();
        Response.Redirect("./IpaddrT5.aspx");
    }
    protected void Button3_Click(object sender, EventArgs e)
    {
        UpdateDate();
        Response.Redirect("./IpaddrT5.aspx");
    }
}
