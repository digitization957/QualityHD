using System;
using System.Configuration;
using MySqlConnector;

namespace QualityHD.Helpers
{
    // Resolves which plant a launcher token belongs to, using the two
    // production-only DBs. Not reachable in this dev environment yet —
    // wire real host/creds into Web.config (AccessConnection / PlantMasterConnection)
    // before go-live.
    public static class PlantHelper
    {
        // access.login_tokenpass: Token, Plant_ID
        // plant_master.tbl_Plant: Plant_ID, Plant_Name
        public static string ResolvePlantByToken(string launcherToken)
        {
            if (string.IsNullOrWhiteSpace(launcherToken)) return null;

            int? plantId = null;
            using (var conn = new MySqlConnection(ConfigurationManager.ConnectionStrings["AccessConnection"].ConnectionString))
            {
                conn.Open();
                using (var cmd = new MySqlCommand("SELECT Plant_ID FROM login_tokenpass WHERE Token = @token LIMIT 1", conn))
                {
                    cmd.Parameters.AddWithValue("@token", launcherToken);
                    var result = cmd.ExecuteScalar();
                    if (result == null || result == DBNull.Value) return null;
                    plantId = Convert.ToInt32(result);
                }
            }

            using (var conn = new MySqlConnection(ConfigurationManager.ConnectionStrings["PlantMasterConnection"].ConnectionString))
            {
                conn.Open();
                using (var cmd = new MySqlCommand("SELECT Plant_Name FROM tbl_Plant WHERE Plant_ID = @plantId LIMIT 1", conn))
                {
                    cmd.Parameters.AddWithValue("@plantId", plantId.Value);
                    var result = cmd.ExecuteScalar();
                    return result == null || result == DBNull.Value ? null : Convert.ToString(result);
                }
            }
        }
    }
}
