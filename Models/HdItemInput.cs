namespace QualityHD.Models
{
    // Plain data holder the AJAX layer deserializes the "Add New Item" form into.
    public class HdItemInput
    {
        public string hdTheme { get; set; }
        public string improvementType { get; set; }
        public string hdSourcePlant { get; set; }
        public string aggregateType { get; set; }
        public string description { get; set; }
        public string modelFamily { get; set; }
        public string issueSource { get; set; }
        public string casesCount { get; set; }
        public string analysisDetails { get; set; }
        public string actionDetails { get; set; }
        public string improvementCategory { get; set; }
        public string hdApplicablePlants { get; set; }
        public string responsiblePersons { get; set; }

        public string ngpOrcStatus { get; set; }
        public string ngpHdDetails { get; set; }
        public string ngpTargetDate { get; set; }

        public string zhbOrcStatus { get; set; }
        public string zhbHdDetails { get; set; }
        public string zhbTargetDate { get; set; }

        public string rdpOrcStatus { get; set; }
        public string rdpHdDetails { get; set; }
        public string rdpTargetDate { get; set; }

        public string jprOrcStatus { get; set; }
        public string jprHdDetails { get; set; }
        public string jprTargetDate { get; set; }

        public string rjkOrcStatus { get; set; }
        public string rjkHdDetails { get; set; }
        public string rjkTargetDate { get; set; }

        public string kndOrcStatus { get; set; }
        public string kndHdDetails { get; set; }
        public string kndTargetDate { get; set; }

        public string attachments { get; set; }
    }
}
