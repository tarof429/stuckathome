# Part 10: JSON

The json module provides methods to parse JSON.

```python
import json
weapon = '{"name": "dagger", "damage": "1-6", "type": "melee", "minimum-level": "1", "cost": "3", "minimum-strength": "6", "minimum-dexterity": "3"}'

weapon_json = json.loads(weapon)

print(weapon_json['name']) 
```

Now if we are given a Python dictionary instead of a string, we will need to convert it to a string first.

```python
import json

weapon = {"name": "dagger", "damage": "1-6", "type": "melee", "minimum-level": "1", "cost": "3", "minimum-strength": "6", "minimum-dexterity": "3"}

weapon_str = json.dumps(weapon)
print(type(weapon_str)) # string
weapon_json = json.loads(weapon_str)
print(weapon_json['name']) 
```

If the json data was in a file, we can pass in the file pointer to the loads() function.

```python

```
