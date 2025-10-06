BaseStores = BaseStores or {}
BaseStores.ammunation = {
  type = 'buy',
  name = 'Goop Store',
  description = 'The GOOP STORE',
  icon = 'fa-solid fa-gun',
  modelType = 'ped',
  models = {'a_m_y_hasjew_01'},
  locations = { 
    vector4(3612.59, 3633.23, 44.78, 121.93)
  },

  paymentMethods = {'cash', 'bank'},

  categories = {
    {
      name = 'Class 1', 
      icon = 'user', 
      description = 'Class 1 Weapons'
    },
    {       
      name = 'Class 2', 
      icon = 'user', 
      description = 'Class 2 Weapons'
    },
    {   
      name = 'Class 3', 
      icon = 'user', 
      description = 'Class 3 Weapons'
    },
    {
      name = 'Ammo & Armour', 
      icon = 'user', 
      description = 'Ammo & Armour'
    },
    {
      name = 'Attachments & Tints', 
      icon = 'user', 
      description = 'Attachments & Tints'
    },
  },

  stock = {
    { name = 'WEAPON_PISTOL', label = 'Pistol', price = 1500, category = 'Class 1' },
    { name = 'armor_vest', label = 'Armor Vest', price = 1000, category = 'Ammo & Armour' },
    { name = 'armor_plate1', label = 'Armor Plate', price = 250, category = 'Ammo & Armour' },
    { name = 'ammo-9', label = 'Pistol Ammo', price = 5, category = 'Ammo & Armour' },
  },

  theme = {
    primaryColor = 'pink',
    primaryShade = 8,
    customTheme  = {
      -- Array of 9 colors from bright to dark
    },
  },

}