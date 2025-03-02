using Microsoft.AspNetCore.Mvc;

namespace API_Ecommerce.Controllers;

[ApiController]
[Route("/api/[controller]")]
public class AuthController(IHttpClientFactory httpClientFactory) : Controller
{
    [HttpGet]
    public async Task<IActionResult> Get()
    {
        using var httpClient = httpClientFactory.CreateClient("AuthService");

        var response = await httpClient.GetAsync("/api/test");

        var content = await response.Content.ReadAsStringAsync();

        return Ok(content);
    }
}