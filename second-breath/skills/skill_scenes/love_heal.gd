extends Node3D

var timeInEffect : float = 0
var animationTime : float = 0.5
var skillCooldown : float = 2
var healthChange : int = 50
var dmgDealt : int = 0
var debuff : int = 0
var dmgDebuff : int = 0
var weaponBuff : float = 0
var speedBuff : float = 0
var maxHealth : int = 100
var staminaDrain : int = -25
var type : String = "buff"
var colour : Color = Color("e03dc6ff")
