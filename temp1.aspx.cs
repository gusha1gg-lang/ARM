using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;

public partial class temp1 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void ImageButton2_PreRender(object sender, EventArgs e)
    {
        //ImageButton1.Attributes.Add("onmouseover", "javascript: this.src = 'Images/Folder.jpg'");
        ImageButton2.Attributes.Add("onmouseover", "javascript: this.src = 'img/ipt4but2.jpg'");
        ImageButton2.Attributes.Add("onmouseout", "javascript: this.src = 'img/ipt4but1.jpg'");
        ImageButton2.Attributes.Add("onmouseclick", "javascript: this.src = 'img/ipt4but3.jpg'");  
    }
    protected void Button1_Click(object sender, EventArgs e)
    {

    }
}
