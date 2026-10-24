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
    public void Otobrazit()
    {
        string connSting = @"dsn=AsutpDB";
        string strSQL = @"select * from IPaddress5 ORDER BY Oc,Uchastok";
        string strSaveUchstok = "0";
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

                if (reader["Uchastok"].ToString() != strSaveUchstok)
                {
                    strSaveUchstok = reader["Uchastok"].ToString();
                    cell = new TableCell();
                    cell.Text = reader["Uchastok"].ToString();
                    cell.HorizontalAlign = HorizontalAlign.Center;
                    cell.Style["border"] = "1px Solid Black";
                    cell.ToolTip = "Название Участка";
                    cell.ColumnSpan = 11;
                    row.Style[HtmlTextWriterStyle.BackgroundColor] = "#ABC0E9";//"#48B6FF"
                    row.Cells.Add(cell);
                    Table1.Rows.Add(row);
                }
                i++;
                row = new TableRow();
                
                cell = new TableCell();
                string Oc = reader["Oc"].ToString();
                cell.Text = Oc;
                cell.HorizontalAlign = HorizontalAlign.Center;
                cell.Style["border"] = "1px Solid Black";
                cell.ToolTip = "ОСЬ";
                row.Cells.Add(cell);

                cell = new TableCell();
                cell.Text = reader["IPaddress"].ToString();
                cell.HorizontalAlign = HorizontalAlign.Center;
                cell.Style["border"] = "1px Solid Black";
                cell.ToolTip = "IP адрес";
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
                cell.Text = reader["ConfigLogin"].ToString();
                cell.HorizontalAlign = HorizontalAlign.Center;
                cell.Style["border"] = "1px Solid Black";
                cell.ToolTip = "Логин TS";
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

                cell = new TableCell();
                cell.Text = "<a class=tooltip href=#>" + reader["CISCO"].ToString() + "<span>" + reader["Opisanie"].ToString() + "<small></small></span></a>";
                cell.HorizontalAlign = HorizontalAlign.Center;
                cell.Style["border"] = "1px Solid Black";
                //cell.ToolTip = reader["Opisanie"].ToString();
                row.Cells.Add(cell);

                if (Session.Contents["admin"] == "admin")
                {
                    cell = new TableCell();
                    string id = reader["IDPC"].ToString();
                    cell.Text = "<a title=Редактировать target=_self href=Editipt5.aspx?id=" + id + ">" + "<img border=0 src=\"img/buttonedit.png\"/>" + "</a>";
                    cell.HorizontalAlign = HorizontalAlign.Center;
                    row.Cells.Add(cell);
                }
                //row.Style[HtmlTextWriterStyle.BackgroundColor] = "#FF22FF";
                if (i % 2 != 0)
                {
                    row.Style[HtmlTextWriterStyle.BackgroundColor] = "WhiteSmoke";
                }
                else
                {
                    row.Style[HtmlTextWriterStyle.BackgroundColor] = "White";
                }
                Table1.Rows.Add(row);

            }



        }
        catch (Exception)
        {
            Label1.Text = "Ебана в рот, сучарская ошибко!!!";
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
        Response.Redirect("./Addipt5.aspx");
    }
}
