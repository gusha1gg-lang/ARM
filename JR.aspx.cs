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
        string strSQL = @"select * from Jarlik";
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
                cell = new TableCell();
                cell.Text = reader["NameJarlik"].ToString();
                cell.HorizontalAlign = HorizontalAlign.Left;
                cell.Style["border"] = "1px Solid Black";
                row.Cells.Add(cell);

                
                cell = new TableCell();
                string id1 = reader["LnkNameJarlik"].ToString();
                cell.Text = "<a title=Скачать href=\"Slegenie/" + id1 + "\">" + "<img border=0 src=\"img/load.png\"/>" + "</a>";
                cell.HorizontalAlign = HorizontalAlign.Center;
                row.Cells.Add(cell);
                if (Session.Contents["admin"] == "admin")
                {
                    cell = new TableCell();
                    string id = reader["IDJarlik"].ToString();
                    cell.Text = "<a title=Редактировать target=_self href=EditJR.aspx?id=" + id + ">" + "<img border=0 src=\"img/buttonedit.png\"/>" + "</a>";
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
        Response.Redirect("./AddJR.aspx");
    }
}
