BaseStores = BaseStores or {}
BaseStores.hardware = {
  type = 'buy', --## 'sell' or 'buy' 
  name = 'Hardware Store',
  description = 'Your one-stop shop for all things hardware, from tools to building materials!',
  icon = 'fas fa-tools',
  
  models = {'mp_m_shopkeep_01'}, --## Ped model to spawn (randomly selected from the list)
  locations = {
    vector4(2747.8264160156, 3472.0263671875, 55.674186706543, 259.00454711914),
    vector4(46.35, -1749.63, 29.64, 55.82), -- NEAR SANDY
  },

  blip = {
    color   = 19,
    scale   = 0.7,
    sprite  = 402,
    display = 2,
  },

  canOpen = function() -- ## Optional function to check if the store can be opened (check license etc?) (server side)
    return true 
  end,

  openingHours = { 0, 24 },--## 24 hour format can also be false or non existent
  
  paymentMethods = { 'cash', 'bank' },

  stock = {
    { name = 'lockpick',          price = 500, amount = 50 },
    { name = 'phone',             price = 250, amount = 50 },
		{ name = 'radio',             price = 850, amount = 50 },
  },

  theme = {
    primaryColor = 'pink',
    primaryShade = 8,
    customTheme  = {
      -- Array of 9 colors from bright to dark
    },
  },
}


