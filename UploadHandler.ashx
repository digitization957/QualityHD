<%@ WebHandler Language="C#" Class="QualityHD.UploadHandler" %>

using System;
using System.IO;
using System.Web;
using Newtonsoft.Json;
using QualityHD.Helpers;

namespace QualityHD
{
    public class UploadHandler : IHttpHandler
    {
        private static readonly string[] AllowedExtensions = { ".pdf", ".png", ".jpg", ".jpeg", ".doc", ".docx", ".xls", ".xlsx" };
        private const long MaxFileSize = 10 * 1024 * 1024; // 10 MB

        public bool IsReusable { get { return false; } }

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            try
            {
                AuthHelper.RequireRole();

                if (context.Request.Files.Count == 0)
                {
                    WriteError(context, 400, "No file uploaded.");
                    return;
                }

                var file = context.Request.Files[0];

                if (file.ContentLength <= 0 || file.ContentLength > MaxFileSize)
                {
                    WriteError(context, 400, "File is empty or exceeds the 10 MB limit.");
                    return;
                }

                string ext = Path.GetExtension(file.FileName).ToLowerInvariant();
                if (Array.IndexOf(AllowedExtensions, ext) < 0)
                {
                    WriteError(context, 400, "File type not allowed.");
                    return;
                }

                // App_Data is blocked from direct HTTP access by ASP.NET, so
                // uploaded files can never be executed or fetched by URL guessing.
                string uploadsDir = context.Server.MapPath("~/App_Data/Uploads");
                if (!Directory.Exists(uploadsDir)) Directory.CreateDirectory(uploadsDir);

                string storedName = Guid.NewGuid().ToString("N") + ext;
                string fullPath = Path.Combine(uploadsDir, storedName);

                file.SaveAs(fullPath);

                string safeOriginal = Path.GetFileName(file.FileName);
                context.Response.Write(JsonConvert.SerializeObject(new { success = true, storedName = storedName, originalName = safeOriginal }));
            }
            catch (UnauthorizedAccessException)
            {
                WriteError(context, 401, "Session expired. Please sign in again.");
            }
            catch
            {
                WriteError(context, 500, "Upload failed.");
            }
        }

        private void WriteError(HttpContext context, int status, string message)
        {
            context.Response.StatusCode = status;
            context.Response.Write(JsonConvert.SerializeObject(new { success = false, message = message }));
        }
    }
}
