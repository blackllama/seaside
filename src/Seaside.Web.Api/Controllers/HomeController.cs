using System;
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
            return $"Seaside 2.0! {Environment.MachineName}\n";
        }
    }
}
