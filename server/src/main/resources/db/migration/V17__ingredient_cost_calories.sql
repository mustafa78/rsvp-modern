-- Add cost and calorie fields to ingredients table

ALTER TABLE ingredients ADD COLUMN cost_per_unit DECIMAL(10, 2);
ALTER TABLE ingredients ADD COLUMN calories_per_unit INTEGER;

COMMENT ON COLUMN ingredients.cost_per_unit IS 'Cost in dollars per unit (e.g., $5.99/lb)';
COMMENT ON COLUMN ingredients.calories_per_unit IS 'Calories per unit (e.g., 165 cal/lb)';
