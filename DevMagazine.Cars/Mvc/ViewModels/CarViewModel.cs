using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Telerik.Sitefinity.Libraries.Model;

namespace DevMagazine.Cars.Mvc.ViewModels
{
    public class CarViewModel
    {
        public string Title { get; set; }

        public string Info { get; set; }

        public Guid Id { get; set; }

        public Image Image { get; set; }

        public int? PartsCount
        {
            get
            {
                if (partsCount == null)
                {
                    partsCount = GetNumOfParts();
                }
                return partsCount;
            }

            set
            {
                partsCount = value;
            }
        }

        private int? partsCount = null;

        private int? GetNumOfParts()
        {
            Thread.Sleep(5000);
            return 5;
        }
    }
}
