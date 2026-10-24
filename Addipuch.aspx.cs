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
    protected void Button1_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            AddDate();
            Response.Redirect("./IPaddrUch.aspx");
        }
        else
        {
            Button2.Visible = true;
            Button1.Visible = false;
        }
    }

    public void AddDate()
    {

        string connSting = @"dsn=AsutpDB";

        string AddSQL = "INSERT INTO IPAddressUch ([IDUchastok],[Kabinet],[Level],[ConfigLogin],[IPaddress],[MAC],[KE],[Telephon],[Monitor],[Printer],[UPS],[Modem],[CISCO],[Opisanie]) VALUES (" + DDL1.SelectedValue.ToString() + ",'" + TextBox1.Text + "','" + TextBox10.Text + "','" + TextBox2.Text + "','" + TextBox4.Text + "','" + TextBox6.Text + "','" + TextBox7.Text + "','" + TextBox8.Text + "','" + TextBox11.Text + "','" + TextBox12.Text + "','" + TextBox13.Text + "','" + TextBox14.Text + "','" + TextBox5.Text + "','" + TextBox3.Text + "')";

        //string AddSQL = "INSERT INTO temp ([t]) VALUES (:t)";
        OdbcConnection conn = null;
        try
        {
            conn = new OdbcConnection(connSting);
            conn.Open();

            OdbcCommand cmd = conn.CreateCommand();
            //cmd.Parameters.Add(":t", OdbcType.Int, 3, "t");
            //cmd.Parameters[":t"].Direction = ParameterDirection.Input;
            //cmd.Parameters[":t"].Value = "100";
            //cmd.Parameters.AddWithValue(":t", "200"); 
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

    protected void CustomValidKE_ServerValidate(object source, ServerValidateEventArgs args)
    {
        string connSting = @"dsn=AsutpDB";
//        string strSQL = @"select IPaddress4.KE,IPAddressUch.KE,IPaddress5.KE 
//                        from IPaddress4,IPAddressUch,IPaddress5 
//                        where IPaddress4.KE='" + args.Value + "' OR IPAddressUch.KE='" + args.Value + "' OR IPaddress5.KE='" + args.Value + "'";
        string strSQL = @"select IPaddress4.KE from IPaddress4 where IPaddress4.KE='" + args.Value + "'";
        string strSQL2 = @"select IPAddressUch.KE from IPAddressUch where IPAddressUch.KE='" + args.Value + "'";
        string strSQL3 = @"select IPaddress5.KE from IPaddress5 where IPaddress5.KE='" + args.Value + "'";
        string strSQL4 = @"select IPaddressALL.KE from IPaddressALL where IPaddressALL.KE='" + args.Value + "'";
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
        string strSQL = @"select IPaddress4.KE from IPaddress4 where IPaddress4.Monitor LIKE '%" + args.Value + "%'";
        string strSQL2 = @"select IPAddressUch.KE from IPAddressUch where IPAddressUch.Monitor LIKE '%" + args.Value + "%'";
        string strSQL3 = @"select IPaddress5.KE from IPaddress5 where IPaddress5.Monitor LIKE '%" + args.Value + "%'";
        string strSQL4 = @"select IPaddressALL.KE from IPaddressALL where IPaddressALL.Monitor LIKE '%" + args.Value + "%' AND IPaddressALL.Monitor IS NOT NULL";
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
        string strSQL = @"select IPaddress4.KE from IPaddress4 where IPaddress4.Printer LIKE '%" + args.Value + "%'";
        string strSQL2 = @"select IPAddressUch.KE from IPAddressUch where IPAddressUch.Printer LIKE '%" + args.Value + "%'";
        string strSQL3 = @"select IPaddress5.KE from IPaddress5 where IPaddress5.Printer LIKE '%" + args.Value + "%'";
        string strSQL4 = @"select IPaddressALL.KE from IPaddressALL where IPaddressALL.Printer LIKE '%" + args.Value + "%'";
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
    protected void Button2_Click(object sender, EventArgs e)
    {
        AddDate();
        Response.Redirect("./IPaddrUch.aspx");
    }
}
