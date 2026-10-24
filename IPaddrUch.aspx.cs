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

    protected void Page_Init(object sender, EventArgs e)
    {


        if (!IsPostBack)
        {
            Uchastok.DataSource = AccessDataSource1;
            Uchastok.DataTextField = "Nameuchastka";
            Uchastok.DataValueField = "IDUchastok";
            Uchastok.DataBind();
        } 
    }
    protected void Page_Load(object sender, EventArgs e)
    {
       
        if (Session.Contents["admin"] == "admin")
        {
            Button1.Visible = true;
        }
        else
        {
            Button1.Visible = false;
        }
        if (!IsPostBack)
        {
          
            Otobrazit();          
             
        } 
        
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        Response.Redirect("./Addipuch.aspx");
    }

    protected void Uchastok_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            Otobrazit();

        } 
    }



    protected void ButtonEdit_Click(object sender, EventArgs e)
    {
        
    }
    protected void Button3_Click(object sender, EventArgs e)
    {
        
    }
    protected void Button2_Click(object sender, EventArgs e)
    {
         
    }

    public void Otobrazit()
    {
        string connSting = @"dsn=AsutpDB";
        string strSQL;
        strSQL = @"select * from IPAddressUch WHERE IDUchastok=" + Uchastok.SelectedItem.Value + " ORDER BY 4,Kabinet";
       // strSQL = @"select IDPC,IDUchastok,Kabinet,Level,ConfigLogin,IPaddress,MAC,KE,Telephon,Opisanie,Monitor,Printer,UPS,Modem,CISCO from IPAddressUch WHERE IDUchastok=" + Uchastok.SelectedItem.Value + " ORDER BY 3,Kabinet";
        //SelectCommand="SELECT   FROM [IPAddressUch] ORDER BY [Level], [Kabinet]">
        string strSaveProlet = "-100";

        OdbcConnection conn = null;
        OdbcDataReader reader = null;
        int i = 0;
        try
        {
            conn = new OdbcConnection(connSting);
            conn.Open();

            OdbcCommand cmd = new OdbcCommand(strSQL, conn);
            reader = cmd.ExecuteReader();
            TableCell cell;
            TableRow row;
            while (reader.Read())
            {
                row = new TableRow();
                if (reader["IDUchastok"].ToString() != strSaveProlet)
                {
                    strSaveProlet = reader["IDUchastok"].ToString();
                    cell = new TableCell();
                    cell.Text = "Участок: " + Uchastok.SelectedItem.Text.ToString();
                    cell.HorizontalAlign = HorizontalAlign.Center;
                    cell.Style["border"] = "1px Solid Black";
                    cell.ToolTip = "Название участка";
                    cell.ColumnSpan = 12;
                    row.Style[HtmlTextWriterStyle.BackgroundColor] = "#20B2AA";
                    row.Style[HtmlTextWriterStyle.Color] = "e0ffff";
                    row.Cells.Add(cell);
                    Table1.Rows.Add(row);
                }

                row = new TableRow();

              
                i++;
                row = new TableRow();
                cell = new TableCell();
                cell.Text = reader["Level"].ToString();
                cell.HorizontalAlign = HorizontalAlign.Center;
                cell.Style["border"] = "1px Solid Black";
                cell.ToolTip = "Этаж";
                row.Cells.Add(cell);

                cell = new TableCell();
                string Oc = reader["Kabinet"].ToString();
                cell.Text = Oc;
                cell.HorizontalAlign = HorizontalAlign.Center;
                cell.Style["border"] = "1px Solid Black";
                cell.ToolTip = "Кабинет";
                row.Cells.Add(cell);

                cell = new TableCell();
                cell.Text = reader["ConfigLogin"].ToString();
                cell.HorizontalAlign = HorizontalAlign.Center;
                cell.Style["border"] = "1px Solid Black";
                cell.ToolTip = "Логин TS";
                row.Cells.Add(cell);

                cell = new TableCell();
                cell.Text = reader["IPaddress"].ToString();
                cell.HorizontalAlign = HorizontalAlign.Center;
                cell.Style["border"] = "1px Solid Black";
                cell.ToolTip = "IP адрес";
                row.Cells.Add(cell);

                cell = new TableCell();
                cell.Text = "<a class=tooltip href=#>"+ reader["CISCO"].ToString()+"<span>"+reader["Opisanie"].ToString()+"<small></small></span></a>";
               // "<a title=Редактировать target=_self href=EditUch.aspx?id=" + id + ">" + "<img border=0 src=\"img/buttonedit.png\"/>" + "</a>";
                cell.HorizontalAlign = HorizontalAlign.Center;
                cell.Style["border"] = "1px Solid Black";
                //cell.ToolTip =reader["Opisanie"].ToString();
                 
                row.Cells.Add(cell);

                cell = new TableCell();
                cell.Text = reader["MAC"].ToString();
                cell.HorizontalAlign = HorizontalAlign.Center;
                cell.Style["border"] = "1px Solid Black";
                cell.ToolTip = "МАС адрес";
                row.Cells.Add(cell);

                cell = new TableCell();
                cell.Text = reader["KE"].ToString();
                cell.HorizontalAlign = HorizontalAlign.Center;
                cell.Style["border"] = "1px Solid Black";
                cell.ToolTip = "PC/TS";
                row.Cells.Add(cell);

                cell = new TableCell();
                cell.Text = reader["Telephon"].ToString();
                cell.HorizontalAlign = HorizontalAlign.Center;
                cell.Style["border"] = "1px Solid Black";
                cell.ToolTip = "Телефон";
                row.Cells.Add(cell);

                cell = new TableCell();
                cell.Text = reader["Monitor"].ToString();
                cell.HorizontalAlign = HorizontalAlign.Center;
                cell.Style["border"] = "1px Solid Black";
                cell.ToolTip = "Монитор";
                row.Cells.Add(cell);

                cell = new TableCell();
                cell.Text = reader["Printer"].ToString();
                cell.HorizontalAlign = HorizontalAlign.Center;
                cell.Style["border"] = "1px Solid Black";
                cell.ToolTip = "Принтер";
                row.Cells.Add(cell);

                cell = new TableCell();
                cell.Text = reader["UPS"].ToString();
                cell.HorizontalAlign = HorizontalAlign.Center;
                cell.Style["border"] = "1px Solid Black";
                cell.ToolTip = "ИБП";
                row.Cells.Add(cell);

                cell = new TableCell();
                cell.Text = reader["Modem"].ToString();
                cell.HorizontalAlign = HorizontalAlign.Center;
                cell.Style["border"] = "1px Solid Black";
                cell.ToolTip = "Модем";
                row.Cells.Add(cell);

                

                if (Session.Contents["admin"] == "admin")
                {
                    cell = new TableCell();
                    string id = reader["IDPC"].ToString();
                    cell.Text = "<a title=Редактировать target=_self href=EditUch.aspx?id=" + id + ">" + "<img border=0 src=\"img/buttonedit.png\"/>" + "</a>";
                    cell.HorizontalAlign = HorizontalAlign.Center;
                    row.Cells.Add(cell);
                }
                //row.Style[HtmlTextWriterStyle.BackgroundColor] = "#add8e6";
                if (i % 2 != 0)
                {
                    row.Style[HtmlTextWriterStyle.BackgroundColor] = "e6e6fa";
                }
                else
                {
                    row.Style[HtmlTextWriterStyle.BackgroundColor] = "e0ffff";
                }
                Table1.Rows.Add(row);

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
