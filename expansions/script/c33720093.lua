--[[
伪羽知觉
Counterfeit Consciousness
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	c:SetUniqueOnField(1,1,id)
	c:Activation()
	--[[If a player declares an attack with a monster: That player rolls a six-sided die, and assigns to each of their opponent's Main Monster Zones the numbers from 1 to 5 (counting from their right) and the number 6 to the Extra Monster Zones. That player chooses 1 of these effects for you to apply:
	● If there is an opponent's monster in the Monster Zone that has the result as its assigned number, change the attack target to that monster.
	● Otherwise, inflict damage to that player's opponent equal to the attacking monster's ATK.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_DAMAGE|CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.toss_dice=true
--E1
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local a=Duel.GetAttacker()
	Duel.SetTargetCard(a)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,ep,1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-ep,a:GetAttack())
end
function s.filter(c,seq)
	local cseq=c:GetSequence()
	if seq>4 then
		return cseq>=5
	else
		return cseq==seq
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local dc=Duel.TossDice(ep,1)
	local a=Duel.GetAttacker()
	if not a or not a:IsRelateToChain() or not a:IsRelateToBattle() then return end
	if not Duel.IsExists(false,s.filter,ep,0,LOCATION_MZONE,1,nil,dc-1) then
		if Duel.NegateAttack() then
			Duel.Damage(1-ep,a:GetAttack(),REASON_EFFECT)
		end
	else
		local tc=Duel.Group(s.filter,ep,0,LOCATION_MZONE,nil,dc-1):GetFirst()
		Duel.HintSelection(Group.FromCards(tc))
		if Duel.GetAttackTarget()==tc then return end
		local ag=a:GetAttackableTarget()
		if a:IsAttackable() and not tc:IsImmuneToEffect(e) and ag:IsContains(tc) then
			Duel.ChangeAttackTarget(tc)
		end
	end
end