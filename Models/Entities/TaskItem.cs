using System.ComponentModel.DataAnnotations;
using Managingtasks.Models.Enums;

namespace Managingtasks.Models.Entities;

public class TaskItem
{
    public int Id { get; set; }
    
    [Required]
    [MinLength(2)]
    public string Title { get; set; } = null!;

    public string? Description { get; set; }

    public TaskItemStatus Status { get; set; } = TaskItemStatus.ToDo;

    public DateTime CreatedAt { get; set; }
    public DateTime UpdatedAt { get; set; }

    [Required]
    public string UserId { get; set; } = null!;
    
}
