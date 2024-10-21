local dashboard = require("dashboard")

dashboard.setup({ 
  theme = 'doom',
  config = {
    center = { 
      {
        icon = "  ",
        desc = "Find  File                              ",
        action = "Telescope find_files",
        shortcut = "<Leader> f f",
      },
      {
        icon = "  ",
        desc = "Recently opened files                   ",
        action = "MRU",
        shortcut = "<Leader> f r",
      },
      {
        icon = "  ",
        desc = "Open Nvim config                        ",
        action = "tabnew $MYVIMRC | tcd %:p:h",
        shortcut = "<Leader> e v",
      },
      {
        icon = "  ",
        desc = "New file                                ",
        action = "enew",
        shortcut = "e           ",
      },
      {
        icon = "  ",
        desc = "Quit Nvim                               ",
        -- desc = "Quit Nvim                               ",
        action = "qa",
        shortcut = "q           ",
      },
    }
  }
})
