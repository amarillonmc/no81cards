--虚毒溶解
local m=33700716
local cm=_G["c"..m]
function cm.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.atcost)
	e1:SetOperation(cm.atop)
	c:RegisterEffect(e1)	
end
function cm.atfilter(c)
	return c:IsSetCard(0x144b) and Duel.IsExistingMatchingCard(cm.atfilter2,0,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function cm.atfilter2(c)
	return not c:IsSetCard(0x144b) and c:IsFaceup() and (c:IsAttackAbove(0) or c:IsDefenseAbove(0))
end
function cm.disfilter(c)
	return not c:IsSetCard(0x144b) and c:IsFaceup() and aux.disfilter1(c) and c:GetCounter(0x144b)>0
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.atfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local atk=e:GetLabel()
	local rg=Group.CreateGroup()
	for tc in aux.Next(g) do
		local atk,def=tc:GetAttack(),tc:GetDefense()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		if (atk>0 and tc:IsAttack(0)) or (def>0 and tc:IsDefense(0)) then
		   rg:AddCard(tc)
		end
	end
	if rg:GetCount()>0 then
	   Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
	local sg=Duel.GetMatchingGroup(cm.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(sg) do
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetValue(RESET_TURN_SET)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e4)
	end
end
function cm.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.atfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,cm.atfilter,1,1,nil)
	local atk=g:GetFirst():GetTextAttack()
	if atk<0 then atk=0 end
	e:SetLabel(atk)
	Duel.Release(g,REASON_COST)
end

