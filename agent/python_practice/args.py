def order(name, type, *args):
  print(f"name: {name}, type: {type}")
  print(f"ext pos args: 0: {args[0]}, 1: {args[1]}")


order("ishtiaq", "black", "honey", "milk")



def order(name, type, *arg, **kw):
  print(f"name: {name}, type: {type}")
  print(f"ext pos args: 0: {arg[0]}, 1: {arg[1]}")
  print(f"kwargs: 0: {kw["quantity"]}, 1: {kw["cup_type"]}")


order("ishtiaq", "black", "honey", "milk", quantity="medium", cup_type="straight")
