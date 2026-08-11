using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web.Script.Services;
using System.Web.Services;
using MySqlConnector;
using QualityHD.Helpers;
using QualityHD.Models;

namespace QualityHD
{
    public partial class _Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        private static readonly Regex EmailPattern = new Regex(@"^[^@\s]+@[^@\s]+\.[^@\s]+$");

        [WebMethod(EnableSession = false)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object GetItems()
        {
            AuthHelper.RequireRole();

            var items = new List<object>();
            using (var conn = DbHelper.GetConnection())
            {
                conn.Open();
                using (var cmd = new MySqlCommand(
                    @"SELECT id, hd_theme, improvement_type, hd_source_plant, aggregate_type, description,
                             model_family, issue_source, cases_count, improvement_category, hd_applicable_plants,
                             created_by_role, created_at
                      FROM hd_items ORDER BY id DESC", conn))
                using (var reader = cmd.ExecuteReader())
                {
                    int idxId = reader.GetOrdinal("id");
                    int idxTheme = reader.GetOrdinal("hd_theme");
                    int idxType = reader.GetOrdinal("improvement_type");
                    int idxPlant = reader.GetOrdinal("hd_source_plant");
                    int idxAggregate = reader.GetOrdinal("aggregate_type");
                    int idxDescription = reader.GetOrdinal("description");
                    int idxModelFamily = reader.GetOrdinal("model_family");
                    int idxIssueSource = reader.GetOrdinal("issue_source");
                    int idxCases = reader.GetOrdinal("cases_count");
                    int idxCategory = reader.GetOrdinal("improvement_category");
                    int idxApplicablePlants = reader.GetOrdinal("hd_applicable_plants");
                    int idxCreatedByRole = reader.GetOrdinal("created_by_role");
                    int idxCreatedAt = reader.GetOrdinal("created_at");

                    while (reader.Read())
                    {
                        items.Add(new
                        {
                            id = reader.GetInt32(idxId),
                            hdTheme = reader.GetString(idxTheme),
                            improvementType = reader.GetString(idxType),
                            hdSourcePlant = reader.GetString(idxPlant),
                            aggregateType = reader.GetString(idxAggregate),
                            description = reader.GetString(idxDescription),
                            modelFamily = reader.GetString(idxModelFamily),
                            issueSource = reader.GetString(idxIssueSource),
                            casesCount = reader.GetInt32(idxCases),
                            improvementCategory = reader.GetString(idxCategory),
                            hdApplicablePlants = reader.GetString(idxApplicablePlants),
                            createdByRole = reader.GetString(idxCreatedByRole),
                            createdAt = reader.GetDateTime(idxCreatedAt).ToString("yyyy-MM-dd HH:mm")
                        });
                    }
                }
            }
            return items;
        }

        [WebMethod(EnableSession = false)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static object SaveItem(HdItemInput item)
        {
            string role = AuthHelper.RequireRole();

            if (item == null) throw new InvalidOperationException("No data received.");

            string hdTheme = Require(item.hdTheme, "HD Theme", 255);
            string improvementType = RequireOneOf(item.improvementType, HdOptions.ImprovementTypes, "Improvement Type");
            string hdSourcePlant = RequireOneOf(item.hdSourcePlant, HdOptions.Plants, "HD Source Plant");
            string aggregateType = RequireOneOf(item.aggregateType, HdOptions.Aggregates, "Aggregate");
            string description = Require(item.description, "Description", 4000);
            string modelFamily = RequireOneOf(item.modelFamily, HdOptions.ModelFamilies, "Model Family");
            string issueSource = RequireOneOf(item.issueSource, HdOptions.IssueSources, "Issue Source");
            int casesCount = RequireInt(item.casesCount, "Cases");
            string analysisDetails = Require(item.analysisDetails, "Analysis details", 4000);
            string actionDetails = Require(item.actionDetails, "Action / Improvement details", 4000);
            string improvementCategory = RequireOneOf(item.improvementCategory, HdOptions.ImprovementCategories, "Improvement Category");
            string hdApplicablePlants = RequireMultiOf(item.hdApplicablePlants, HdOptions.Plants, "HD Applicable Plants");
            string responsiblePersons = RequireEmails(item.responsiblePersons, "Responsible persons for HD");

            string ngpStatus = OptionalOneOf(item.ngpOrcStatus, HdOptions.OrcStatuses, "Open");
            string zhbStatus = OptionalOneOf(item.zhbOrcStatus, HdOptions.OrcStatuses, "Open");
            string rdpStatus = OptionalOneOf(item.rdpOrcStatus, HdOptions.OrcStatuses, "Open");
            string jprStatus = OptionalOneOf(item.jprOrcStatus, HdOptions.OrcStatuses, "Open");
            string rjkStatus = OptionalOneOf(item.rjkOrcStatus, HdOptions.OrcStatuses, "Not Applicable");
            string kndStatus = OptionalOneOf(item.kndOrcStatus, HdOptions.OrcStatuses, "Not Applicable");

            string attachments = Optional(item.attachments, 2000);

            using (var conn = DbHelper.GetConnection())
            {
                conn.Open();
                using (var cmd = new MySqlCommand(@"INSERT INTO hd_items
                    (hd_theme, improvement_type, hd_source_plant, aggregate_type, description, model_family, issue_source, cases_count,
                     analysis_details, action_details, improvement_category, hd_applicable_plants, responsible_persons,
                     ngp_orc_status, ngp_hd_details, ngp_target_date,
                     zhb_orc_status, zhb_hd_details, zhb_target_date,
                     rdp_orc_status, rdp_hd_details, rdp_target_date,
                     jpr_orc_status, jpr_hd_details, jpr_target_date,
                     rjk_orc_status, rjk_hd_details, rjk_target_date,
                     knd_orc_status, knd_hd_details, knd_target_date,
                     attachments, created_by_role)
                    VALUES
                    (@hdTheme, @improvementType, @hdSourcePlant, @aggregateType, @description, @modelFamily, @issueSource, @casesCount,
                     @analysisDetails, @actionDetails, @improvementCategory, @hdApplicablePlants, @responsiblePersons,
                     @ngpStatus, @ngpDetails, @ngpDate,
                     @zhbStatus, @zhbDetails, @zhbDate,
                     @rdpStatus, @rdpDetails, @rdpDate,
                     @jprStatus, @jprDetails, @jprDate,
                     @rjkStatus, @rjkDetails, @rjkDate,
                     @kndStatus, @kndDetails, @kndDate,
                     @attachments, @createdByRole)", conn))
                {
                    cmd.Parameters.AddWithValue("@hdTheme", hdTheme);
                    cmd.Parameters.AddWithValue("@improvementType", improvementType);
                    cmd.Parameters.AddWithValue("@hdSourcePlant", hdSourcePlant);
                    cmd.Parameters.AddWithValue("@aggregateType", aggregateType);
                    cmd.Parameters.AddWithValue("@description", description);
                    cmd.Parameters.AddWithValue("@modelFamily", modelFamily);
                    cmd.Parameters.AddWithValue("@issueSource", issueSource);
                    cmd.Parameters.AddWithValue("@casesCount", casesCount);
                    cmd.Parameters.AddWithValue("@analysisDetails", analysisDetails);
                    cmd.Parameters.AddWithValue("@actionDetails", actionDetails);
                    cmd.Parameters.AddWithValue("@improvementCategory", improvementCategory);
                    cmd.Parameters.AddWithValue("@hdApplicablePlants", hdApplicablePlants);
                    cmd.Parameters.AddWithValue("@responsiblePersons", responsiblePersons);

                    cmd.Parameters.AddWithValue("@ngpStatus", ngpStatus);
                    cmd.Parameters.AddWithValue("@ngpDetails", Optional(item.ngpHdDetails, 4000));
                    cmd.Parameters.AddWithValue("@ngpDate", OptionalDate(item.ngpTargetDate));

                    cmd.Parameters.AddWithValue("@zhbStatus", zhbStatus);
                    cmd.Parameters.AddWithValue("@zhbDetails", Optional(item.zhbHdDetails, 4000));
                    cmd.Parameters.AddWithValue("@zhbDate", OptionalDate(item.zhbTargetDate));

                    cmd.Parameters.AddWithValue("@rdpStatus", rdpStatus);
                    cmd.Parameters.AddWithValue("@rdpDetails", Optional(item.rdpHdDetails, 4000));
                    cmd.Parameters.AddWithValue("@rdpDate", OptionalDate(item.rdpTargetDate));

                    cmd.Parameters.AddWithValue("@jprStatus", jprStatus);
                    cmd.Parameters.AddWithValue("@jprDetails", Optional(item.jprHdDetails, 4000));
                    cmd.Parameters.AddWithValue("@jprDate", OptionalDate(item.jprTargetDate));

                    cmd.Parameters.AddWithValue("@rjkStatus", rjkStatus);
                    cmd.Parameters.AddWithValue("@rjkDetails", Optional(item.rjkHdDetails, 4000));
                    cmd.Parameters.AddWithValue("@rjkDate", OptionalDate(item.rjkTargetDate));

                    cmd.Parameters.AddWithValue("@kndStatus", kndStatus);
                    cmd.Parameters.AddWithValue("@kndDetails", Optional(item.kndHdDetails, 4000));
                    cmd.Parameters.AddWithValue("@kndDate", OptionalDate(item.kndTargetDate));

                    cmd.Parameters.AddWithValue("@attachments", attachments);
                    cmd.Parameters.AddWithValue("@createdByRole", role);

                    cmd.ExecuteNonQuery();
                    return new { success = true, id = cmd.LastInsertedId };
                }
            }
        }

        private static string Require(string value, string field, int maxLen)
        {
            if (string.IsNullOrWhiteSpace(value)) throw new InvalidOperationException(field + " is required.");
            value = value.Trim();
            if (value.Length > maxLen) throw new InvalidOperationException(field + " is too long.");
            return value;
        }

        private static string Optional(string value, int maxLen)
        {
            if (string.IsNullOrWhiteSpace(value)) return null;
            value = value.Trim();
            if (value.Length > maxLen) throw new InvalidOperationException("Value too long.");
            return value;
        }

        private static object OptionalDate(string value)
        {
            if (string.IsNullOrWhiteSpace(value)) return DBNull.Value;
            DateTime dt;
            if (!DateTime.TryParse(value, out dt)) throw new InvalidOperationException("Invalid date value.");
            return dt.Date;
        }

        private static int RequireInt(string value, string field)
        {
            int n;
            if (!int.TryParse(value, out n) || n < 0 || n > 1000000)
                throw new InvalidOperationException(field + " must be a valid number.");
            return n;
        }

        private static string RequireOneOf(string value, string[] allowed, string field)
        {
            if (string.IsNullOrWhiteSpace(value) || Array.IndexOf(allowed, value.Trim()) < 0)
                throw new InvalidOperationException(field + " is invalid.");
            return value.Trim();
        }

        private static string OptionalOneOf(string value, string[] allowed, string fallback)
        {
            if (string.IsNullOrWhiteSpace(value)) return fallback;
            if (Array.IndexOf(allowed, value.Trim()) < 0) throw new InvalidOperationException("Invalid status value.");
            return value.Trim();
        }

        private static string RequireMultiOf(string csv, string[] allowed, string field)
        {
            if (string.IsNullOrWhiteSpace(csv)) throw new InvalidOperationException(field + " is required.");
            var parts = csv.Split(',').Select(p => p.Trim()).Where(p => p.Length > 0).ToArray();
            if (parts.Length == 0) throw new InvalidOperationException(field + " is required.");
            foreach (var p in parts)
            {
                if (Array.IndexOf(allowed, p) < 0) throw new InvalidOperationException(field + " contains an invalid value.");
            }
            return string.Join(",", parts.Distinct());
        }

        private static string RequireEmails(string csv, string field)
        {
            if (string.IsNullOrWhiteSpace(csv)) throw new InvalidOperationException(field + " is required.");
            var parts = csv.Split(new[] { ',', ';' }, StringSplitOptions.RemoveEmptyEntries).Select(p => p.Trim()).ToArray();
            if (parts.Length == 0) throw new InvalidOperationException(field + " is required.");
            foreach (var p in parts)
            {
                if (p.Length > 254 || !EmailPattern.IsMatch(p))
                    throw new InvalidOperationException("'" + p + "' is not a valid email address.");
            }
            return string.Join(",", parts);
        }
    }
}
