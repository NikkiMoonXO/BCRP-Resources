Config = Config or {}


-- Choose inventory backend: 'ox' or 'qb'
Config.Inventory = 'ox' -- change to 'ox' to use ox_inventory


-- Default drop size used by both backends unless overridden per-call
Config.DropSize = {
slots = 25,
maxweight = 30000,
}


-- For QB only (fallback or overrides): map item name -> prop model (hash or model name)
-- For OX, props are read directly from ox_inventory Items() (modelp/prop)
Config.ItemProps = {
-- examples (edit to your server items)
water = 'prop_ld_flow_bottle',
sandwich = 'prop_sandwich_01',
kurkakola = 'prop_ecola_can',
bread = 'v_res_fa_bread03',
advancedlockpick = 'prop_tool_box_04',
}