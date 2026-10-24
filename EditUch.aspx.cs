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
            //ZapolnitDDList();
            Zapolnit();

        }

    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            UpdateDate();
            Response.Redirect("./IPaddrUch.aspx");
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
        Response.Redirect("./IPaddrUch.aspx");
    }

    public void Zapolnit()
    {
        string id = Request.QueryString["id"];
        string connSting = @"dsn=AsutpDB";
        string strSQL = @"select IPA.Level,IPA.Kabinet,IPA.ConfigLogin,IPA.IPaddress,IPA.MAC,IPA.KE,IPA.Telephon,IPA.Monitor,IPA.Printer,IPA.UPS,IPA.Modem,IPA.CISCO,IPA.Opisanie,IPA.IDUchastok,NU.IDUchastok,NU.Nameuchastka from IPAddressUch AS IPA,NameUchastok AS NU where NU.IDUchastok=IPA.IDUchastok AND IDPC=" + id;
        OdbcConnection conn = null;
        OdbcDataReader reader = null;
        int aa;
        try
        {
            conn = new OdbcConnection(connSting);
            conn.Open();

            OdbcCommand cmd = new OdbcCommand(strSQL, conn);
            reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                
                aa = Convert.ToInt32(reader["IDUchastok"].ToString());
                //DDL1.SelectedIndex = aa-1;// reader["IDUchastok"].ToString(); 
                DDL1.SelectedValue = aa.ToString(); 
                TextBox10.Text = reader["Level"].ToString();
                TextBox1.Text = reader["Kabinet"].ToString();
                TextBox2.Text = reader["ConfigLogin"].ToString();
                TextBox4.Text = reader["IPaddress"].ToString();
                TextBox5.Text = reader["CISCO"].ToString();
                TextBox6.Text = reader["MAC"].ToString();
                TextBox7.Text = reader["KE"].ToString();
                TextBox8.Text = reader["Telephon"].ToString();
                TextBox11.Text = reader["Monitor"].ToString();
                TextBox12.Text = reader["Printer"].ToString();
                TextBox13.Text = reader["UPS"].ToString();
                TextBox14.Text = reader["Modem"].ToString();
                TextBox3.Text = reader["Opisanie"].ToString();
                
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

        public void ZapolnitDDList()
    {
        //string id = Request.QueryString["id"];
        string connSting = @"dsn=AsutpDB";
        string strSQL = @"select IDUchastok,Nameuchastka from NameUchastok";
        OdbcConnection conn = null;
        OdbcDataReader reader = null;
        DataTable  myDT=new DataTable();  
        try
        {
            conn = new OdbcConnection(connSting);
            conn.Open();

            OdbcCommand cmd = new OdbcCommand(strSQL, conn);
            reader = cmd.ExecuteReader();
            
            DDL1.DataSource = reader;
            DDL1.DataBind();
            //DDL1.Items(IDUch).Selected = true; 
            
            
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
            int Level1 = Convert.ToInt32(TextBox10.Text);
            string updateSQL = "UPDATE IPAddressUch SET IDUchastok=" + DDL1.SelectedValue.ToString() + ",Kabinet='" + TextBox1.Text + "',[Level]=" + TextBox10.Text + ",ConfigLogin='" + TextBox2.Text + "',IPaddress='" + TextBox4.Text + "',MAC='" + TextBox6.Text + "',KE='" + TextBox7.Text + "',Telephon='" + TextBox8.Text + "',Monitor='" + TextBox11.Text + "',Printer='" + TextBox12.Text + "',UPS='" + TextBox13.Text + "',Modem='" + TextBox14.Text + "',CISCO='" + TextBox5.Text + "',Opisanie='" + TextBox3.Text + "'where IDPC=" + id;
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

        public void DeleteDate()
        {
            string id = Request.QueryString["id"];
            string connSting = @"dsn=AsutpDB";
            string DeleteSQL = "DELETE FROM IPAddressUch WHERE IDPC=" + id;

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
        protected void Button3_Click(object sender, EventArgs e)
        {
            UpdateDate();
            Response.Redirect("./IPaddrUch.aspx");
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
            //string strSQL = @"select IPaddress4.KE from IPaddress4 where IDPC<>" + id + " AND IPaddress4.Printer LIKE '%" + args.Value + "%'";
            //string strSQL2 = @"select IPAddressUch.KE from IPAddressUch where IDPC<>" + id + " AND IPAddressUch.Printer LIKE '%" + args.Value + "%'";
            //string strSQL3 = @"select IPaddress5.KE from IPaddress5 where IDPC<>" + id + " AND IPaddress5.Printer LIKE '%" + args.Value + "%'";


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
}
