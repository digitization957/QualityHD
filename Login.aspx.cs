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

        // DEMO MODE: token + plant are hardcoded (kept in sync with login.js
        // DEMO_TOKENS/DEMO_PLANTS) since plant_master isn't reliably reachable.
        // Swap back to PlantHelper.GetAllPlants() once that's fixed.
        private static readonly string[] DemoTokens = { "DEMO-TOKEN-0001", "DEMO-TOKEN-0002", "DEMO-TOKEN-0003" };
        private static readonly string[] DemoPlants = { "NGP", "ZHB", "RDP", "JPR", "RJK", "KND" };

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod(EnableSession = false)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object GenerateToken(string token, string plant)
        {
            if (string.IsNullOrWhiteSpace(token) || !TokenPattern.IsMatch(token) || Array.IndexOf(DemoTokens, token) < 0)
                throw new InvalidOperationException("Invalid token format.");

            if (string.IsNullOrWhiteSpace(plant) || Array.IndexOf(DemoPlants, plant) < 0)
                throw new InvalidOperationException("Invalid plant.");

            string jwt = JwtHelper.Issue(token, OnlyRole, plant);
            return new { jwt = jwt, role = OnlyRole, plant = plant };
        }
    }
}
