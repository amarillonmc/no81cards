local m=11223424
local cm=_G["c"..m]
cm.name="精灵的神佑"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cm.etarget)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
	--Recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end
--Immune
function cm.etarget(e,c)
	return e:GetHandler():GetOwner()==c:GetOwner() and c:GetBaseAttack()==500
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL)
end
--Recover
function cm.filter(c)
	return c:GetAttack()==500 and c:GetDefense()==500 and c:IsAttribute(ATTRIBUTE_DARK)
		and c:IsRace(RACE_WARRIOR) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			local b1=tc:IsAbleToHand()
			local b2=tc:IsAbleToGrave()
			if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(m,3))) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SendtoGrave(tc,REASON_EFFECT)
			end
		end
	end
end