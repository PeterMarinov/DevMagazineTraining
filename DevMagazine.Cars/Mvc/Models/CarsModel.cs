using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DevMagazine.Cars.Mvc.ViewModels;
using Telerik.Sitefinity.DynamicModules;
using Telerik.Sitefinity.Utilities.TypeConverters;
using Telerik.Sitefinity.DynamicModules.Model;
using Telerik.Sitefinity.Model;
using Telerik.Sitefinity.RelatedData;
using Telerik.Sitefinity.Libraries.Model;
using System.Threading;
using Telerik.Sitefinity.Data;
using Telerik.Sitefinity.GenericContent.Model;

namespace DevMagazine.Cars.Mvc.Models
{
    public class CarsModel : ICarsModel
    {
        #region Properties

        public Guid CarId { get; set; }

        #endregion

        #region ICarsModel region

        public CarViewModel GetSingleCar()
        {
            CarViewModel carViewModel = new CarViewModel();

            var car = Manager.GetDataItems(CarsType)
    .Where(d => d.Id == CarId)
    .SingleOrDefault();

            if (car != null)
                carViewModel = GetViewModel(car);

            return carViewModel;
        }

        #endregion

        #region private methods

        private CarViewModel GetViewModel(DynamicContent dContent)
        {
            CarViewModel viewModel = new CarViewModel();

            viewModel.Id = dContent.Id;
            viewModel.Title = dContent.GetString("Title").Value;
            viewModel.Info = dContent.GetString("CarInfo").Value;

            if (dContent.GetRelatedItemsCountByField("CarImages") > 0)
            {
                viewModel.Image = dContent.GetRelatedItems<Image>("CarImages").FirstOrDefault();
            }

            return viewModel;
        }


        public IList<CacheDependencyKey> GetCacheDependencyKeys()
        {
            var keys = new List<CacheDependencyKey>(1);

            if (CarId != Guid.Empty)
            {
                keys.Add(new CacheDependencyKey()
                {
                    Key = CarId.ToString(),
                    Type = typeof(DynamicContent)
                });
            }

            return keys;
        }


        #endregion


        public Type CarsType
        {
            get
            {
                return TypeResolutionService.ResolveType("Telerik.Sitefinity.DynamicTypes.Model.Cars.Car");
            }
        }

        public DynamicModuleManager Manager
        {
            get
            {
                return DynamicModuleManager.GetManager();
            }
        }
    }
}
