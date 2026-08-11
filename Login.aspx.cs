using System;
using System.Text.RegularExpressions;
using System.Web.Script.Services;
using System.Web.Services;
using QualityHD.Helpers;

namespace QualityHD
{
    public partial class Login : System.Web.UI.Page
    {
        private static readonly string[] AllowedRoles = { "User", "Admin" };
        private static readonly Regex TokenPattern = new Regex("^[A-Za-z0-9-]{8,64}$");

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod(EnableSession = false)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object GenerateToken(string token, string role)
        {
            if (string.IsNullOrWhiteSpace(token) || !TokenPattern.IsMatch(token))
                throw new InvalidOperationException("Invalid token format.");

            if (string.IsNullOrWhiteSpace(role) || Array.IndexOf(AllowedRoles, role) < 0)
                throw new InvalidOperationException("Invalid role.");

            string jwt = JwtHelper.Issue(token, role);
            return new { jwt = jwt, role = role };
        }
    }
}
