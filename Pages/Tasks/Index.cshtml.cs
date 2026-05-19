using Managingtasks.Data;
using Managingtasks.Models.Entities;
using Managingtasks.Models.Enums;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;

namespace Managingtasks.Pages.Tasks;

[Authorize]
public class IndexModel : PageModel
{
    private readonly ApplicationDbContext _db;

    public List<TaskItem> Tasks { get; set; } = new();

    [BindProperty]
    public TaskItem TaskItem { get; set; } = new();

    public IndexModel(ApplicationDbContext db)
    {
        _db = db;
    }

    public void OnGet()
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

        Tasks = _db.Tasks
            .Where(t => t.UserId == userId)
            .ToList();
    }
    public IActionResult OnPostadd()
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

        TaskItem.UserId = userId;
        TaskItem.CreatedAt = DateTime.UtcNow;
        TaskItem.UpdatedAt = DateTime.UtcNow;

        _db.Tasks.Add(TaskItem);
        _db.SaveChanges();

        return RedirectToPage("Index");
    }
    public IActionResult OnPostedit(int id, TaskItemStatus status)
    {
    var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

    var task = _db.Tasks.FirstOrDefault(t => t.Id == id);

    if (task == null || task.UserId != userId)
    {
        return NotFound();
    }

    task.Status = status;

    _db.SaveChanges();

    return RedirectToPage();
    }
    public IActionResult OnPostDelete(int id){
      var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

      var task = _db.Tasks.FirstOrDefault(t => t.Id == id);

      if (task == null || task.UserId != userId)
      {
          return NotFound(); // אבטחה
      }

      _db.Tasks.Remove(task);
      _db.SaveChanges();

      return RedirectToPage();
    }
}
