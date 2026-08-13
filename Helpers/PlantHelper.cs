using System;
using System.Collections.Generic;
using System.Configuration;
using MySqlConnector;

namespace QualityHD.Helpers
{
    // Resolves plant info from the plant_master DB — the app never hardcodes
    // plant names, they always come from plant_master.tbl_Plant.
    public static class PlantHelper
    {
        // plant_master.tbl_Plant: Plant_ID, Plant_Name
        public static List<PlantInfo> GetAllPlants()
        {
            var plants = new List<PlantInfo>();
            using (var conn = new MySqlConnection(ConfigurationManager.ConnectionStrings["PlantMasterConnection"].ConnectionString))
            {
                conn.Open();
                using (var cmd = new MySqlCommand("SELECT Plant_ID, Plant_Name FROM tbl_Plant ORDER BY Plant_Name", conn))
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        plants.Add(new PlantInfo { id = reader.GetInt32(0), name = reader.GetString(1) });
                    }
                }
            }
            return plants;
        }

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

    public class PlantInfo
    {
        public int id { get; set; }
        public string name { get; set; }
    }
}
