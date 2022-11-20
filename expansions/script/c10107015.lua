--安提抹杀者 素数
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
function c10107015.initial_effect(c)
	--link summon
	c:EnableReviveLimit() 
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_ZOMBIE),2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c10107015.matval)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c10107015.matcheck)
	c:RegisterEffect(e2)
	--race
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCode(EFFECT_CHANGE_RACE)
	e3:SetValue(RACE_ZOMBIE)
	c:RegisterEffect(e3)  
end
function c10107015.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return c:GetSummonPlayer()==e:GetHandlerPlayer() and c:IsFaceup(), true
end
function c10107015.matcheck(e,c)
	local mg,atk=c:GetMaterial(),0
	if mg:GetCount()>0 then
	   maxg,atk=mg:GetMaxGroup(Card.GetTextAttack)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
