def get_value():
    # Accessing global state variables
    global gvar
    return gvar

def modify_value():
    # Modifying global state variables
    global gvar
    gvar += 10
    return gvar

def read_from_os(filename: str) -> str:
    # Accessing os storage space
    with open(filename, "r") as fp:
        return fp.read()

def write_to_os(filename: str) -> str:
    # Modfying os storage space
    with open(filename, "a") as fp:
        fp.write("Hello there!~")
        return "Same output, but the os storage state was modified"



# print() is also not pure
gvar = 5
print("get_value() = ", get_value())
gvar = 10
print("get_value() = ", get_value())
gvar = 15
print("get_value() = ", get_value())
gvar = 20
print("get_value() = ", get_value())
gvar = 25
print("get_value() = ", get_value())

print("modify_value() = ", modify_value())
print("modify_value() = ", modify_value())
print("modify_value() = ", modify_value())

filename = "side_effects_with_python.txt"
print(f"read_from_os('{filename}') = ", read_from_os(filename))
print(f"write_to_os('{filename}') = ", write_to_os(filename))
print(f"read_from_os('{filename}') = ", read_from_os(filename))
print(f"write_to_os('{filename}') = ", write_to_os(filename))
print(f"read_from_os('{filename}') = ", read_from_os(filename))
print(f"write_to_os('{filename}') = ", write_to_os(filename))

"""
OUTPUT:
    get_value() = 5
    get_value() = 10
    get_value() = 15
    get_value() = 20
    get_value() = 25
    modify_value() = 35
    modify_value() = 45
    modify_value() = 55
    read_from_os('side_effects_with_python.txt') = None
    write_to_os('side_effects_with_python.txt') = Same output, but the os storage state was modified
    read_from_os('side_effects_with_python.txt') = Hello there!~
    write_to_os('side_effects_with_python.txt') = Same output, but the os storage state was modified
    read_from_os('side_effects_with_python.txt') = Hello there!~Hello there!~
    write_to_os('side_effects_with_python.txt') = Same output, but the os storage state was modified
"""
