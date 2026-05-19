using Managingtasks.Data;
using Managingtasks.Models.Entities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Security.Claims;

namespace Managingtasks.Pages.Tasks;

[Authorize]
public class CreateModel : PageModel
{
    private readonly ApplicationDbContext _db;

    [BindProperty]
    public TaskItem TaskItem { get; set; } = new();

    public CreateModel(ApplicationDbContext db)
    {
        _db = db;
    }

    public void OnGet()
    {
    }

    public IActionResult OnPost()
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

        TaskItem.UserId = userId;

        _db.Tasks.Add(TaskItem);
        _db.SaveChanges();

        return RedirectToPage("Index");
    }
}