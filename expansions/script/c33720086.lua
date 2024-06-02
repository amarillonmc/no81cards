--[[
先制攻击
Taking Initiative
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id,o=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--Activation
	aux.AddEquipSpellEffect(c,true,true,Card.IsFaceup)
	--[[If this card becomes equipped to a monster: Banish from your Deck, 1 monster whose DEF is equal to or lower than the DEF of the monster with the highest DEF you control
	(if you do not control a monster, banish 1 monster with 0 DEF instead).]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_EQUIP)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.rmcon)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	--[[Apply 1 of these effects, based on the equipped monster's original ATK:
	● Higher than the banished monster's DEF: The equipped monster loses ATK equal to the banished monster's DEF.
	● Lower than the banished monster's DEF: The equipped monster gains ATK equal to the banished monster's DEF.
	● Equal to the banished monster's DEF: All monsters you control gain ATK equal to the ATK of the equipped monster.]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(s.highcon)
	e2:SetValue(s.highval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCondition(s.lowcon)
	e3:SetValue(s.lowval)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(s.eqcon)
	e4:SetValue(s.eqval)
	c:RegisterEffect(e4)
end
--E1
function s.rmcon(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	return eg:IsContains(c)
end
function s.filter(c)
	return c:IsFaceup() and c:HasDefense()
end
function s.rmfilter(c,def)
	return c:IsMonster() and c:IsDefenseBelow(def) and c:IsAbleToRemove()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	local def=0
	if #g>0 then
		_,def=g:GetMaxGroup(Card.GetDefense)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_DECK,0,1,1,nil,def):GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and tc:IsBanished() and c:IsRelateToChain() then
		c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,0,0,tc:GetDefense())
	end
end

--E2
function s.highcon(e)
	local c=e:GetHandler()
	return c:HasFlagEffect(id) and c:GetEquipTarget():GetBaseAttack()>c:GetFlagEffectLabel(id)
end
function s.highval(e,c)
	return -e:GetHandler():GetFlagEffectLabel(id)
end
--E3
function s.lowcon(e)
	local c=e:GetHandler()
	return c:HasFlagEffect(id) and c:GetEquipTarget():GetBaseAttack()<c:GetFlagEffectLabel(id)
end
function s.lowval(e,c)
	return e:GetHandler():GetFlagEffectLabel(id)
end
--E4
function s.eqcon(e)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	return ec and c:HasFlagEffect(id) and ec:GetBaseAttack()==c:GetFlagEffectLabel(id)
end
function s.eqval(e,c)
	return e:GetHandler():GetEquipTarget():GetBaseAttack()
end