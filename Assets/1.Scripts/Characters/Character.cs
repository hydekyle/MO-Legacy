using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Scriptables/Character")]
public class Character : ScriptableObject
{
    public string alias;
    public Sprite[] spriteList;
    public Stats stats;
    public List<Skill> skills;
}

public struct Stats
{
    public int strength;
    public int dexterity;
    public int constitution;
    public int intelligence;
    public int wisdom;
    public int charisma;
    public int luck;
}