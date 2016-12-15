using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;

namespace Seaside.Web.Api.Controllers
{
    [Route("")]
    public class HomeController : Controller
    {
        [HttpHead]
        [HttpGet]
        public string Get()
        {
            return "Seaside 3.0!";
        }
    }
}
