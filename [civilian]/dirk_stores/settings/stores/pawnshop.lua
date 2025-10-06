BaseStores = BaseStores or {}
BaseStores.pawnshop = {
  type = 'sell', --## 'sell' or 'buy' 
  name = 'Pawn Shop',
  description = 'We buy anything and everything, no questions asked!',
  icon = 'fas fa-hand-holding-dollar',
  
  models = {'mp_m_shopkeep_01'}, --## Ped model to spawn (randomly selected from the list)
  locations = {
    vector4(-278.8, 2205.79, 129.86, 67.65)
  },

  canOpen = function() -- ## Optional function to check if the store can be opened (check license etc?) (server side)
    return true 
  end,

  openingHours = { 0, 24 },--## 24 hour format can also be false or non existent
  
  paymentMethods = { 'cash', 'bank' },


  categories = {
    {
      name = 'Trash',
      description = 'One persons trash is anothers treasure.',
      icon = 'user',
    },
  },

  stock = {
    {
      name = 'panties',
      category = 'Trash',
      price = 15,
    },
  },

  theme = {
    primaryColor = 'pink',
    primaryShade = 8,
    customTheme  = {
      -- Array of 9 colors from bright to dark
    },
  },
}


