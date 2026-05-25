extends Node3D

var timeInEffect : float = 0
var animationTime : float = 0.5
var skillCooldown : int = 1
var healthChange : int = 0
var debuff : int = 8
var dmgDebuff : int = 0
var weaponBuff : float = 0
var speedBuff : float = 0
var maxHealth : int = 100
var staminaDrain : int = 10
var type : String = "melee"
var colour : Color = Color("999999ff")
