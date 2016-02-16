using DevMagazine.Cars.Mvc.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DevMagazine.Cars.Mvc.Models
{
    public interface ICarsModel
    {
        CarViewModel GetSingleCar();

        Guid CarId { get; set; }
    }
}
