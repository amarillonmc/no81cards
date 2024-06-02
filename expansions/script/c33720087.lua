--[[
仙灵光线
Sylph Ray
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id,o=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	c:EnableCounterPermit(COUNTER_SAN)
	--Activation
	aux.AddEquipSpellEffect(c,true,false,Card.IsFaceup)
	--[[If this card becomes equipped to a monster: You lose LP equal to the ATK of the equipped monster.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_EQUIP)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.lpcon)
	e1:SetTarget(s.lptg)
	e1:SetOperation(s.lpop)
	c:RegisterEffect(e1)
	--If the equipped monster would inflict battle damage to your opponent, place 1 "SAN Counter" on this card for each 100 damage that would be inflicted instead.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_REPLACE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(aux.IsEquippedCond)
	e2:SetValue(s.damval)
	c:RegisterEffect(e2)
	--[[All monsters your opponent controls lose 100 ATK for each "SAN Counter" on this card, and if their ATK is reduced to 0 by this effect, return them to the hand.]]
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_CAN_FORBIDDEN)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(aux.IsEquippedCond)
	e3:SetOperation(s.regop)
	c:RegisterEffect(e3)
	--[[You can remove 80 "SAN Counters" from this card; destroy this card, and if you do, inflict 8000 damage to your opponent.]]
	local e4=Effect.CreateEffect(c)
	e4:Desc(1,id)
	e4:SetCategory(CATEGORY_DESTROY|CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(aux.RemoveCounterSelfCost(COUNTER_SAN,80))
	e4:SetTarget(s.damtg)
	e4:SetOperation(s.damop)
	c:RegisterEffect(e4)
end
--E1
function s.lpcon(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	return eg:IsContains(c)
end
function s.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	Duel.SetTargetCard(ec)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if ec:IsRelateToChain() and ec:IsFaceup() and ec:HasAttack() then
		Duel.LoseLP(tp,ec:GetAttack())
	end
end

--E2
function s.damval(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if val>=100 and r&REASON_BATTLE>0 and rc and rc==ec and c:IsCanAddCounter(COUNTER_SAN,math.floor(val/100),true) then
		c:AddCounter(COUNTER_SAN,math.floor(val/100),true)
		return 0
	end
	return val
end

--E3
function s.thfilter(c)
	return c:IsFaceup() and c:IsAttackAbove(1)
end
function s.chkfilter(c,e)
	return c:IsFaceup() and c:IsAttack(0) and not c:IsImmuneToEffect(e)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eid=e:GetFieldID()
	local g=Duel.GetMatchingGroup(s.thfilter,tp,0,LOCATION_MZONE,nil)
	local ct=c:GetCounter(COUNTER_SAN)
	local diff=ct
	if c:HasFlagEffect(id+100) then
		diff=diff-c:GetFlagEffectLabel(id+100)
		c:SetFlagEffectLabel(id+100,ct)
	else
		c:RegisterFlagEffect(id+100,RESET_EVENT|RESETS_STANDARD,0,0,ct)
	end
	if not c:HasFlagEffectLabel(id,eid) then
		c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,0,0,eid)
	end
	local tg=Group.CreateGroup()
	for tc in aux.Next(g) do
		local flagchk=tc:HasFlagEffectLabel(id,eid)
		local phchk=false
		if diff~=0 or not flagchk then
			local val=diff*-100
			if not flagchk then
				val=ct*-100
				tc:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,0,0,eid)
			end
			local ph=Effect.CreateEffect(c)
			ph:SetType(EFFECT_TYPE_SINGLE)
			ph:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			ph:SetCode(EFFECT_UPDATE_ATTACK)
			ph:SetLabel(val,eid)
			ph:SetCondition(s.eqcon)
			ph:SetValue(s.eqval)
			ph:SetReset(RESET_EVENT|RESETS_STANDARD)
			if tc:RegisterEffect(ph) and s.chkfilter(tc,ph) then
				phchk=true
			end
		end
		Duel.AdjustInstantly(tc)
		if phchk and (diff>0 or not flagchk) then
			tg:AddCard(tc)
		end
	end
	if #tg>0 then
		Duel.Hint(HINT_CARD,tp,id)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
function s.eqcon(e)
	local c=e:GetOwner()
	local _,eid=e:GetLabel()
	return c:HasCounter(COUNTER_SAN) and c:HasFlagEffectLabel(id,eid)
end
function s.eqval(e,c)
	local val,_=e:GetLabel()
	return val
end

--E4
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.SetCardOperationInfo(c,CATEGORY_DESTROY)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,8000)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)>0 then
		Duel.Damage(1-tp,8000,REASON_EFFECT)
	end
end