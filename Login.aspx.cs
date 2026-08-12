using System;
using System.Text.RegularExpressions;
using System.Web.Script.Services;
using System.Web.Services;
using QualityHD.Helpers;

namespace QualityHD
{
    public partial class Login : System.Web.UI.Page
    {
        private const string OnlyRole = "User"; // single role for now — add more here if that changes
        private static readonly Regex TokenPattern = new Regex("^[A-Za-z0-9-]{8,64}$");

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        // In production the real launcher hands off token+role, and this app
        // resolves the plant itself via PlantHelper (access.login_tokenpass ->
        // plant_master.tbl_Plant). Those DBs aren't reachable in dev, so this
        // simulated launcher lets the plant be picked manually instead.
        [WebMethod(EnableSession = false)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object GenerateToken(string token, string plant)
        {
            if (string.IsNullOrWhiteSpace(token) || !TokenPattern.IsMatch(token))
                throw new InvalidOperationException("Invalid token format.");

            if (string.IsNullOrWhiteSpace(plant) || Array.IndexOf(HdOptions.Plants, plant) < 0)
                throw new InvalidOperationException("Invalid plant.");

            string jwt = JwtHelper.Issue(token, OnlyRole, plant);
            return new { jwt = jwt, role = OnlyRole, plant = plant };
        }
    }
}
