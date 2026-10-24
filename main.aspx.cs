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

public partial class main : System.Web.UI.Page
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
    // }

    public void Otobrazit()
    {
        string connSting = @"dsn=AsutpDB";
        string strSQL;
        if (Prolet.SelectedItem.Value != "-100")
        {
            strSQL = @"select * from IPaddress4 WHERE Prolet=" + Prolet.SelectedItem.Value + " ORDER BY Prolet,Oc,Uchastok,AgeregatName";
        }
        else
        {
            strSQL = @"select * from IPaddress4 ORDER BY Prolet,Oc,Uchastok,AgeregatName";
        }
        string strSaveProlet = "-100";
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

                if (reader["Prolet"].ToString() != strSaveProlet)
                {
                    strSaveProlet = reader["Prolet"].ToString();
                    cell = new TableCell();
                    cell.Text = "Пролет №: " + reader["Prolet"].ToString();
                    //cell.BackColor =
                    cell.HorizontalAlign = HorizontalAlign.Center;
                    cell.Style["border"] = "1px Solid Black";
                    cell.ToolTip = "Номер пролета"; 
                    cell.ColumnSpan = 13;
                    row.Style[HtmlTextWriterStyle.BackgroundColor] = "#20B2AA";
                    row.Style[HtmlTextWriterStyle.Color] = "e0ffff";
                    row.Cells.Add(cell);
                    Table1.Rows.Add(row);
                }

                row = new TableRow();

                if (reader["Uchastok"].ToString() != strSaveUchstok)
                {
                    strSaveUchstok = reader["Uchastok"].ToString();
                    cell = new TableCell();
                    cell.Text = reader["Uchastok"].ToString();
                    cell.HorizontalAlign = HorizontalAlign.Center;
                    cell.Style["border"] = "1px Solid Black";
                    cell.ColumnSpan = 13;
                    row.Style[HtmlTextWriterStyle.BackgroundColor] = "#C1CDC1";//"#87CEEB"
                    row.Cells.Add(cell);
                    Table1.Rows.Add(row);
                }
                i++;
                row = new TableRow();
                cell = new TableCell();
                cell.Text = reader["AgeregatName"].ToString();
                cell.HorizontalAlign = HorizontalAlign.Center;
                cell.Style["border"] = "1px Solid Black";
                cell.ToolTip = "№ площадки";
                row.Cells.Add(cell);

                cell = new TableCell();
                string Oc = reader["Oc"].ToString();
                cell.Text = Oc;
                cell.HorizontalAlign = HorizontalAlign.Center;
                cell.Style["border"] = "1px Solid Black";
                cell.ToolTip = "Ось";
                row.Cells.Add(cell);

                cell = new TableCell();
                cell.Text = reader["ConfigLogin"].ToString();
                cell.HorizontalAlign = HorizontalAlign.Center;
                cell.Style["border"] = "1px Solid Black";
                cell.ToolTip = "№ площадки или логин TS";
                row.Cells.Add(cell);

                cell = new TableCell();
                cell.Text = reader["IPaddress"].ToString();
                cell.HorizontalAlign = HorizontalAlign.Center;
                cell.Style["border"] = "1px Solid Black";
                cell.ToolTip = "IP адрес";
                row.Cells.Add(cell);

                cell = new TableCell();
                cell.Text = reader["Shluz"].ToString();
                cell.HorizontalAlign = HorizontalAlign.Center;
                cell.Style["border"] = "1px Solid Black";
                cell.ToolTip = "Основной шлюз";
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
                    cell.Text = "<a title=Редактировать target=_self href=Edit.aspx?id=" + id + ">" + "<img border=0 src=\"img/buttonedit.png\"/>" + "</a>";
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
            //Label1.Text = "Ебана в рот, сучарская ошибко!!!";
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
        Response.Redirect("./Addipt4.aspx");
    }
    protected void Prolet_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            Otobrazit();
        }
    }
    protected void Button2_Click(object sender, EventArgs e)
    {
        if (txtBoxFind.Text != "")
        {
            Response.Redirect("./ReportExist.aspx?KE=" + txtBoxFind.Text);
        }
        {
            Otobrazit(); 
        }
    }
}
