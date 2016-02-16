using System;
using System.Web.Mvc;

namespace DevMagazine.Core.Mvc.Helpers
{
    public static class PageHtmlHelperExtensions
    {
        public static string GetPageTitle(this HtmlHelper helper, Guid pageId)
        {
            return "Will do it tomorrow";
        }
    }
}
