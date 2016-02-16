using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;
using Telerik.Sitefinity.DynamicModules;
using Telerik.Sitefinity.Mvc;
using Telerik.Sitefinity.Utilities.TypeConverters;
using Telerik.Sitefinity.Model;
using DevMagazine.Cars.Mvc.Models;
using Telerik.Sitefinity.Services;
using Telerik.Sitefinity.Frontend.Mvc.Infrastructure.Controllers;

namespace DevMagazine.Cars.Mvc.Controllers
{
    [ControllerToolboxItem(Name = "CarsSpecial", SectionName = "Training MVC", Title = "Cars Special Widget")]
    public class CarsController : Controller
    {
        public CarsController()
        {
            model = new CarsModel();
        }

        #region Properties

        public Guid CarId
        {
            get
            {
                return carId;
            }
            set
            {
                carId = value;
            }
        }

        #endregion
        public ActionResult Index()
        {
            model.CarId = CarId;
            var viewModel = model.GetSingleCar();

            if(SystemManager.CurrentHttpContext != null)
            {
                this.AddCacheDependencies(model.GetCacheDependencyKeys());
            }

            return View("Index", viewModel);
        }

        private CarsModel model;
        private Guid carId;
    }
}
