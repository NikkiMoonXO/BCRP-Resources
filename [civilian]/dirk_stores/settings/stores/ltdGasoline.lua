BaseStores = BaseStores or {}
BaseStores.ltdGasoline = {
  type = 'buy', --## 'sell' or 'buy' 
  name = 'LTD Gasoline',
  description = 'Watered down gas and overpriced snacks, what more could you want?',
  icon = 'fas fa-gas-pump',
  
  models = {'mp_m_shopkeep_01'}, --## Ped model to spawn (randomly selected from the list)
  locations = {
    vector4(-47.23, -1758.62, 29.42, 59.9),
    vector4(-705.9, -914.63, 19.22, 99.36),
    vector4(1164.97, -323.74, 69.21, 114.35),
    vector4(1697.44, 4923.28, 42.06, 333.94),
    vector4(-1819.52, 793.48, 138.09, 130.84),
  },

  blip = {
    color   = 29,
    scale   = 0.6,
    sprite  = 52,
    display = 2,
  },

  canOpen = function() -- ## Optional function to check if the store can be opened (check license etc?) (server side)
    return true 
  end,

  openingHours = { 0, 24 },--## 24 hour format can also be false or non existent
  
  paymentMethods = { 'cash', 'bank' },


  categories = {
    {
      name = 'Drinks',
      description = 'Refreshing beverages to quench your thirst.',
      icon = 'fas fa-cocktail',
    },
    {
      name = 'Food',
      description = 'Delicious meals to satisfy your hunger.',
      icon = 'fas fa-hamburger',
    },
    {
      name = 'Snacks',
      description = 'Quick bites to keep you going.',
      icon = 'fas fa-cookie',
    },
  },

  stock = {
    {
      name = 'water',
      category = 'Drinks',
      price = 100,
    },
    {
      name = 'burger',
      category = 'Food',
      price = 300,
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


