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
            Shop.DataSource = AccessDataSource1;
            Shop.DataTextField = "ShopName";
            Shop.DataValueField = "ShopID";
            Shop.DataBind();
            Shop.SelectedValue = "8";
            Prolet.DataSource = AccessDataSource2;
            Prolet.DataTextField = "Prolet_Name";
            Prolet.DataValueField = "Prolet";
            Prolet.DataBind();
            Prolet.SelectedIndex = 1;  

        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        string VideoType = Request.QueryString["VideoType"];
        if (VideoType == "IP")
        {
            lbVideoType.Text = "IP видеонаблюдение";
            PanelVideoIP.Visible = true;
            PanelVideoAnalog.Visible = false;
        }
        if (VideoType == "Analog")
        {
            lbVideoType.Text = "Аналоговое видеонаблюдение";
            PanelVideoIP.Visible = false;
            PanelVideoAnalog.Visible = true;
        }
        if (VideoType == null)
        {
            lbVideoType.Text = "";
            PanelVideoIP.Visible = false;
            PanelVideoAnalog.Visible = false; 
        }
        
        if (Session.Contents["admin"] == "admin")
        {
            CB_Edit.Enabled = true;
        }
        else
        {
            CB_Edit.Enabled = false;
        }
      
        if (!IsPostBack)
        {
            if (CB_Edit.Checked)
            {
                GridView2.ShowFooter = true;
                GridViewAnalog.ShowFooter = true;
                //ImageButtonDel
                ((ImageButton)GridView2.FindControl("ImageButtonDel")).Visible = false;
            }
            else
            {
                GridView2.ShowFooter = false;
                GridViewAnalog.ShowFooter = false;
            }
        }
    }

    protected void Shop_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (IsPostBack)
        {
            Prolet.DataSource = AccessDataSource2;
            Prolet.DataTextField = "Prolet_Name";
            Prolet.DataValueField = "Prolet";
            Prolet.DataBind();
            if (Prolet.SelectedIndex > 0)
            {
                Prolet.SelectedIndex = 1;
            }
            //Prolet.Items.Add(new ListItem("все", "-100"));
           // Prolet.SelectedValue = "-100";
            //Otobrazit();

        }
    }
  

    protected void ImgBtnInsertIP_Click(object sender, EventArgs e)
    {
        int number_v;
             
        string strOC = ((TextBox)GridView2.FooterRow.FindControl("txtInsert_OC")).Text;
        bool b_OC = Int32.TryParse(strOC, out number_v);

        if (b_OC)
        {
            
        ODS_VideoIP.InsertParameters["ShopID"].DefaultValue =
            ((DropDownList)GridView2.FooterRow.FindControl("DDL_Foot_Tab_Shop")).SelectedValue;
               
        ODS_VideoIP.InsertParameters["Prolet"].DefaultValue =
            ((DropDownList)GridView2.FooterRow.FindControl("DDL_Foot_Prolet")).SelectedValue;
        ODS_VideoIP.InsertParameters["Oc"].DefaultValue = strOC;
        ODS_VideoIP.InsertParameters["Uchastok"].DefaultValue =
            ((TextBox)GridView2.FooterRow.FindControl("txtInsert_Uchastok")).Text;
         ODS_VideoIP.InsertParameters["IPaddress"].DefaultValue =
        ((TextBox)GridView2.FooterRow.FindControl("txtInsert_IPAddress")).Text;
        ODS_VideoIP.InsertParameters["Camera_number"].DefaultValue =
        ((TextBox)GridView2.FooterRow.FindControl("txtInsert_Camera_number")).Text;
        ODS_VideoIP.InsertParameters["IDCAM_NAME"].DefaultValue =
        ((DropDownList)GridView2.FooterRow.FindControl("DDL_Foot_Spr_Cameras")).SelectedValue;
        ODS_VideoIP.InsertParameters["IP_Server_PC"].DefaultValue =
        ((TextBox)GridView2.FooterRow.FindControl("txt_Insert_IPServerPC")).Text;
        ODS_VideoIP.InsertParameters["upload_img"].DefaultValue =
        ((TextBox)GridView2.FooterRow.FindControl("txt_Insert_IP_CAM")).Text;
 
        ODS_VideoIP.InsertParameters["IP_CAMERA_STREAM"].DefaultValue =
        ((TextBox)GridView2.FooterRow.FindControl("txtLinkFoterIP")).Text;
        ODS_VideoIP.InsertParameters["Login_password"].DefaultValue =
        ((TextBox)GridView2.FooterRow.FindControl("txt_Insert_Login_password")).Text;
        ODS_VideoIP.InsertParameters["ID_CISCO"].DefaultValue =
        ((DropDownList)GridView2.FooterRow.FindControl("DDL_Foot_CISCO")).SelectedValue;
        ODS_VideoIP.InsertParameters["Port_CISCO"].DefaultValue =
        ((TextBox)GridView2.FooterRow.FindControl("txt_Insert_Port_CISCO")).Text;
         ODS_VideoIP.InsertParameters["Video_out_lacation_PC"].DefaultValue =
        ((TextBox)GridView2.FooterRow.FindControl("txt_Insert_Video_out_lacation")).Text;
        ODS_VideoIP.InsertParameters["Monitor"].DefaultValue =
        ((TextBox)GridView2.FooterRow.FindControl("txt_Insert_Monitor")).Text;
         ODS_VideoIP.InsertParameters["Opisanie"].DefaultValue =
        ((TextBox)GridView2.FooterRow.FindControl("txt_Insert_Opisanie")).Text;
         ODS_VideoIP.InsertParameters["Camera_Type"].DefaultValue = "IP";
        ODS_VideoIP.Insert();
        }
    }

    protected void ImgBtnInsertAnalog_Click(object sender, EventArgs e)
    {
        int number_v;

        string strOC = ((TextBox)GridViewAnalog.FooterRow.FindControl("txtInsert_OC_A")).Text;
        bool b_OC = Int32.TryParse(strOC, out number_v);

        if (b_OC)
        {
            ODS_VideoAnalog.InsertParameters["ShopID"].DefaultValue =
                ((DropDownList)GridViewAnalog.FooterRow.FindControl("DDL_Foot_Tab_Shop_A")).SelectedValue;
            ODS_VideoAnalog.InsertParameters["Prolet"].DefaultValue =
                ((DropDownList)GridViewAnalog.FooterRow.FindControl("DDL_Foot_Prolet_A")).SelectedValue;
            ODS_VideoAnalog.InsertParameters["Oc"].DefaultValue =
                ((TextBox)GridViewAnalog.FooterRow.FindControl("txtInsert_OC_A")).Text;
            ODS_VideoAnalog.InsertParameters["Uchastok"].DefaultValue =
                ((TextBox)GridViewAnalog.FooterRow.FindControl("txtInsert_Uchastok_A")).Text;
            ODS_VideoAnalog.InsertParameters["IPaddress"].DefaultValue =
            ((TextBox)GridViewAnalog.FooterRow.FindControl("txtInsert_IPAddress_A")).Text;
            ODS_VideoAnalog.InsertParameters["Camera_number"].DefaultValue =
            ((TextBox)GridViewAnalog.FooterRow.FindControl("txtInsert_Camera_number_A")).Text;
            ODS_VideoAnalog.InsertParameters["IDCAM_NAME"].DefaultValue =
            ((DropDownList)GridViewAnalog.FooterRow.FindControl("DDL_Foot_Spr_Cameras_A")).SelectedValue;
            ODS_VideoAnalog.InsertParameters["IP_Server_PC"].DefaultValue =
            ((TextBox)GridViewAnalog.FooterRow.FindControl("txt_Insert_IPServerPC_A")).Text;
            ODS_VideoAnalog.InsertParameters["upload_img"].DefaultValue =
            ((TextBox)GridViewAnalog.FooterRow.FindControl("txt_Insert_IP_CAM_A")).Text;
            ODS_VideoAnalog.InsertParameters["IP_CAMERA_STREAM"].DefaultValue =
            ((TextBox)GridViewAnalog.FooterRow.FindControl("txtLinkFoter")).Text;
            ODS_VideoAnalog.InsertParameters["Login_password"].DefaultValue =
            ((TextBox)GridViewAnalog.FooterRow.FindControl("txt_Insert_Login_password_A")).Text;
            ODS_VideoAnalog.InsertParameters["ID_CISCO"].DefaultValue =
            ((DropDownList)GridViewAnalog.FooterRow.FindControl("DDL_Foot_CISCO_A")).SelectedValue;
            ODS_VideoAnalog.InsertParameters["Port_CISCO"].DefaultValue =
            ((TextBox)GridViewAnalog.FooterRow.FindControl("txt_Insert_Port_CISCO_A")).Text;
            ODS_VideoAnalog.InsertParameters["Video_out_lacation_PC"].DefaultValue =
            ((TextBox)GridViewAnalog.FooterRow.FindControl("txt_Insert_Video_out_lacation_A")).Text;
            ODS_VideoAnalog.InsertParameters["Monitor"].DefaultValue =
            ((TextBox)GridViewAnalog.FooterRow.FindControl("txt_Insert_Monitor_A")).Text;
            ODS_VideoAnalog.InsertParameters["Opisanie"].DefaultValue =
            ((TextBox)GridViewAnalog.FooterRow.FindControl("txt_Insert_Opisanie_A")).Text;
            ODS_VideoAnalog.InsertParameters["Camera_Type"].DefaultValue = "Analog";

            ODS_VideoAnalog.Insert();
        }
    }

    protected void Prolet_SelectedIndexChanged(object sender, EventArgs e)
    {
        //if (IsPostBack)
        //{
        //    //Otobrazit();
        //}
    }


    protected void CB_Edit_CheckedChanged(object sender, EventArgs e)
    {
        if (CB_Edit.Checked)
        {
            GridView2.ShowFooter = true;
            GridViewAnalog.ShowFooter = true;
        }
        else
        {
            GridView2.ShowFooter = false;
            GridViewAnalog.ShowFooter = false;
        }
    }


    protected void btnUploadAnalog_Click(object sender, EventArgs e)
    {
        if (((FileUpload)GridViewAnalog.FooterRow.FindControl("FileUploadAnalog")).HasFile)
        {
            string fileName = ((FileUpload)GridViewAnalog.FooterRow.FindControl("FileUploadAnalog")).FileName;
            string fileExtensions = System.IO.Path.GetExtension(fileName);
            
            if (fileExtensions.ToLower() != ".png" && fileExtensions.ToLower() != ".jpeg" && fileExtensions.ToLower() != ".jpg" && fileExtensions.ToLower() != ".gif")
            {
                ((Label)GridViewAnalog.FooterRow.FindControl("lblMessage")).Text = "Только файлы с расширением .png или .jpeg";
                ((Label)GridViewAnalog.FooterRow.FindControl("lblMessage")).BackColor = System.Drawing.Color.Red;
            }
            else
            {
                int fileSize = ((FileUpload)GridViewAnalog.FooterRow.FindControl("FileUploadAnalog")).PostedFile.ContentLength;
                if (fileSize > 4194304)
                {
                    ((Label)GridViewAnalog.FooterRow.FindControl("lblMessage")).Text = "Максимальный размер файла 4Mb";
                    ((Label)GridViewAnalog.FooterRow.FindControl("lblMessage")).BackColor = System.Drawing.Color.Red;
                }
                else
                {
                    ((FileUpload)GridViewAnalog.FooterRow.FindControl("FileUploadAnalog")).SaveAs(Server.MapPath("~/uploads/" + fileName)); 
                    ((Label)GridViewAnalog.FooterRow.FindControl("lblMessage")).Text = "Файл загружен";
                    ((Label)GridViewAnalog.FooterRow.FindControl("lblMessage")).BackColor = System.Drawing.Color.Green;
                    ((TextBox)GridViewAnalog.FooterRow.FindControl("txt_Insert_IP_CAM_A")).Text = "uploads/" + fileName;

                }
            }
        }

        else
        {
            ((Label)GridViewAnalog.FooterRow.FindControl("lblMessage")).Text = "Выбери файл для загрузки";
            ((Label)GridViewAnalog.FooterRow.FindControl("lblMessage")).BackColor = System.Drawing.Color.Red;
        }
    }

    //------------------------
    protected void btnUploadIP_Click(object sender, EventArgs e)
    {
        if (((FileUpload)GridView2.FooterRow.FindControl("FileUploadIP")).HasFile)
        {
            string fileName = ((FileUpload)GridView2.FooterRow.FindControl("FileUploadIP")).FileName;
            string fileExtensions = System.IO.Path.GetExtension(fileName);

            if (fileExtensions.ToLower() != ".png" && fileExtensions.ToLower() != ".jpeg" && fileExtensions.ToLower() != ".jpg" && fileExtensions.ToLower() != ".gif")
            {
                ((Label)GridView2.FooterRow.FindControl("lblMessageIP")).Text = "Только файлы с расширением .png или .jpeg";
                ((Label)GridView2.FooterRow.FindControl("lblMessageIP")).BackColor = System.Drawing.Color.Red;
            }
            else
            {
                int fileSize = ((FileUpload)GridView2.FooterRow.FindControl("FileUploadIP")).PostedFile.ContentLength;
                if (fileSize > 4194304)
                {
                    ((Label)GridView2.FooterRow.FindControl("lblMessageIP")).Text = "Максимальный размер файла 4Mb";
                    ((Label)GridView2.FooterRow.FindControl("lblMessageIP")).BackColor = System.Drawing.Color.Red;
                }
                else
                {
                    ((FileUpload)GridView2.FooterRow.FindControl("FileUploadIP")).SaveAs(Server.MapPath("~/uploads/" + fileName));
                    ((Label)GridView2.FooterRow.FindControl("lblMessageIP")).Text = "Файл загружен";
                    ((Label)GridView2.FooterRow.FindControl("lblMessageIP")).BackColor = System.Drawing.Color.Green;
                    ((TextBox)GridView2.FooterRow.FindControl("txt_Insert_IP_CAM")).Text = "uploads/" + fileName;

                }
            }
        }

        else
        {
            ((Label)GridView2.FooterRow.FindControl("lblMessageIP")).Text = "Выбери файл для загрузки";
            ((Label)GridView2.FooterRow.FindControl("lblMessageIP")).BackColor = System.Drawing.Color.Red;
        }
    }
    //--------------------------
    // protected void btnUploadAnalog_Click(object sender, EventArgs e)
    //{
    //    if (FileUploadAnalog.HasFile)
    //    {
    //        string fileExtensions = System.IO.Path.GetExtension(FileUploadAnalog.FileName);
    //        if (fileExtensions.ToLower() != ".png" && fileExtensions.ToLower() != ".jpeg" && fileExtensions.ToLower() != ".jpg" && fileExtensions.ToLower() != ".gif")
    //        {
    //            lblMessage.Text = "Только файлы с расширением .png или .jpeg";
    //            lblMessage.BackColor = System.Drawing.Color.Red;
    //        }
    //        else
    //        {
    //            int fileSize = FileUploadAnalog.PostedFile.ContentLength;
    //            if (fileSize > 4194304)
    //            {
    //                lblMessage.Text = "Максимальный размер файла 4Mb";
    //                lblMessage.BackColor = System.Drawing.Color.Red;
    //            }
    //            else
    //            {
    //                FileUploadAnalog.SaveAs(Server.MapPath("~/uploads/" + FileUploadAnalog.FileName));
    //                GridViewAnalog.FooterRow.FindControl("lblMessage).Text = "Файл загружен";
    //                lblMessage.BackColor = System.Drawing.Color.Green;
    //                ((TextBox)GridViewAnalog.FooterRow.FindControl("txt_Insert_IP_CAM_A")).Text = "uploads/" + FileUploadAnalog.FileName;

    //            }
    //        }
    //    }

    //    else
    //    {
    //        lblMessage.Text = "Выбери файл для загрузки";
    //        lblMessage.BackColor = System.Drawing.Color.Red;

    //    }
    //}
}
