using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Managingtasks.Models.Entities;

namespace Managingtasks.Data
{
    public class ApplicationDbContext 
        : IdentityDbContext<IdentityUser>
    {
        public DbSet<TaskItem> Tasks { get; set; }

        public ApplicationDbContext(
            DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }
    }
    public class ApplicationUser : IdentityUser
    {
        // שדות נוספים בעתיד
    }
}