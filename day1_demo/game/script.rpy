

init python:
    class fighter:
        def __init__(self, name, max_hp, hp, dmg):
            self.name = name
            self.max_hp = max_hp
            self.hp = hp
            self.dmg = dmg
        
        def attack(self,target):
            target.hp -= self.dmg
            target.hp = max(target.hp, 0)
        

label start:
    show bg street
    $ cat = fighter("Cat", 15, 15, 2)
    $ box = fighter("Box", 10, 10, 3)
    show cat at left
    "Cat" "I love being a cat"
    show box at right
    "Cat" "Oh look a box"
    show box hit
    pause 0.2
    show box
    "Cat" "Ah! It moved!"

label fight:
    while cat.hp > 0:
        menu:
            "Attack":
                $ cat.attack(box)
                
                scene bg street
                show box at right 
                show cat:
                    ypos 400
                    xoffset 200
                    ease 0.4 xoffset 700
                pause 0.2
                show cat mid
                with vpunch
                pause 0.05
                show cat slap
                show box attacked at right
                "You slapped the box"
                "The Box has [box.hp] hp"
                if box.hp <= 0:
                    scene bg street
                    "You defeated the box!"
                    return
                $ box_angry = True
                "The box attacks you!"
                scene bg street
            "Do nothing":
                $ choice = renpy.random.choice(["yes", "no"])
                if choice == "yes":
                    "The box attacks you!"
                    $ box_angry = True
                else:
                    "You both stare at each other"
                    $ cat.hp += 3
                    "After taking a rest, your hp is [cat.hp]"
                    $ box_angry = False
        
        if box_angry:
            $ box.attack(cat)
            scene bg street
            show cat at left
            show box:
                ypos 400
                xoffset 1000
                ease 0.4 xoffset 500
            pause 0.2
            show box hit
            with vpunch
            show cat attacked at left
            "You have [cat.hp] hp"
            scene bg street
    
    "You Died..."
    return

