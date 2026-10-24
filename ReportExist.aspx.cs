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
            string KE = Request.QueryString["KE"];
            if (txtBoxFind.Text != "")
            {
                FindKE(txtBoxFind.Text);
            }
            else
            {
                if (KE != null)
                {
                    FindKE(KE);
                }
            }
        }
    }
    public void FindKE(string KE)
    {
        string connSting = @"dsn=AsutpDB";
        //string strSQL = @"select * from IPaddress4 where KE IN (select DISTINCT KE FROM IPaddress4)";
        string strSQL = @"select Prolet AS Пролет,Uchastok AS Участок,AgeregatName AS Номер_площадки,Oc AS Ось,ConfigLogin AS Логин_TS,IPaddress,Shluz AS Шлюз,MAC,IPaddress4.KE,Telephon AS Телефон,Monitor AS Монитор,Printer AS Принтер,UPS,Modem,CISCO,Opisanie from IPaddress4 where IPaddress4.KE LIKE '%" + KE + "%'";
        //string strSQL3 = @"select IDUchastok,Kabinet,IPAddressUch.Level,IPAddressUch.KE from IPAddressUch where IPAddressUch.KE LIKE '%" + KE + "%'";
        string strSQL2 = @"select NU.Nameuchastka AS Участок,IPA.Level AS Этаж,IPA.Kabinet AS Кабинет,IPA.ConfigLogin AS Логин_TS,IPA.IPaddress,IPA.MAC,IPA.KE AS KE_PC,IPA.Telephon AS Телефон,IPA.Monitor AS Монитор,IPA.Printer AS Принтер,IPA.UPS,IPA.Modem,IPA.CISCO,IPA.Opisanie AS Описание from IPAddressUch AS IPA,NameUchastok AS NU where NU.IDUchastok=IPA.IDUchastok AND IPA.KE LIKE '%" + KE + "%'";
       // string strSQL3 = @"select Uchastok AS Участок,Oc AS Ось,IPaddress5.KE,ConfigLogin,IPaddress,MAC,Telephon AS Телефон,Monitor AS Монитор,Printer AS Принтер,UPS,Modem,CISCO,Opisanie from IPaddress5 where IPaddress5.KE LIKE '%" + KE + "%'";
        string strSQL3 = @"select Uchastok AS Участок,Oc AS Ось,IPaddress5.KE,ConfigLogin AS Логин_TS,IPaddress,MAC,Telephon AS Телефон,Monitor AS Монитор,Printer AS Принтер,UPS,Modem,CISCO from IPaddress5 where IPaddress5.KE LIKE '%" + KE + "%'";

        OdbcConnection conn = null;
        OdbcDataReader reader = null;
        try
        {
            conn = new OdbcConnection(connSting);
            conn.Open();

            OdbcCommand cmd = new OdbcCommand(strSQL, conn);
            reader = cmd.ExecuteReader();
            bool FindKE = reader.HasRows;
            if (FindKE)
            {
                GridView1.Visible = true;
                GridView1.DataSource = reader;
                GridView1.DataBind();
            }
            reader.Close();
            cmd.CommandText = strSQL2;
            reader = cmd.ExecuteReader();
            bool FindKE2 = reader.HasRows;
            if (FindKE2)
            {
                GridView2.Visible = true;
                GridView2.DataSource = reader;
                GridView2.DataBind();
            }
            reader.Close();
            cmd.CommandText = strSQL3;
            reader = cmd.ExecuteReader();
            bool FindKE3 = reader.HasRows;
            if (FindKE3)
            {
                GridView3.Visible = true;
                GridView3.DataSource = reader;
                GridView3.DataBind();
            }
            //while (reader.Read())
            //{
            //    //TextBox9.Text = reader["Prolet"].ToString();
            //    //TextBox10.Text = reader["Uchastok"].ToString();
            //    //TextBox1.Text = reader["AgeregatName"].ToString();
            //    //TextBox2.Text = reader["Oc"].ToString();
            //    //TextBox3.Text = reader["ConfigLogin"].ToString();
            //    //TextBox4.Text = reader["IPaddress"].ToString();
            //    //TextBox5.Text = reader["Shluz"].ToString();
            //    //TextBox6.Text = reader["MAC"].ToString();
            //    //TextBox7.Text = reader["KE"].ToString();
            //    //TextBox8.Text = reader["Telephon"].ToString();
            //    //TextBox11.Text = reader["Monitor"].ToString();
            //    //TextBox12.Text = reader["Printer"].ToString();
            //    //TextBox13.Text = reader["UPS"].ToString();
            //    //TextBox14.Text = reader["Modem"].ToString();
            //    //TextBox15.Text = reader["CISCO"].ToString();
            //    //TextBox16.Text = reader["Opisanie"].ToString();
            //}
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

    protected void btnFind_Click(object sender, EventArgs e)
    {
        GridView3.Visible=false;
        GridView1.Visible = false;
        GridView2.Visible = false;
        if (txtBoxFind.Text != "")
        {
            FindKE(txtBoxFind.Text);
        }

    }
}