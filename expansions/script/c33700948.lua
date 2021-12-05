--Maize ～自我牺牲的树精～
local m=33700948
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(cm.tgcon)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetCost(cm.rmcost)
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)
	
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local c=e:GetHandler()
		if Duel.SendtoGrave(g,REASON_EFFECT)>0 and not c:IsImmuneToEffect(e) then
			local fe=c:GetFlagEffect(m)
			local t=0
			t=bit.bor(t,bit.band(t:GetType(),TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP))
			if fe<=0 then
				c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,t)
			else
				local fl=c:GetFlagEffectLabel(m)
				fl=bit.bor(fl,t)
				t=fl-t
				c:SetFlagEffectLabel(m,fl)
			end
			if bit.band(t,TYPE_MONSTER)~=0 then
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(m,1))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_IMMUNE_EFFECT)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e1:SetRange(LOCATION_MZONE)
				e1:SetValue(cm.efilter)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e1)
				--battle indes
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e2:SetRange(LOCATION_MZONE)
				e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
				e2:SetValue(1)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e2)
			end
			if bit.band(t,TYPE_SPELL)~=0 then
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(m,2))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_IMMUNE_EFFECT)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e1:SetRange(LOCATION_MZONE)
				e1:SetValue(cm.efilter1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e1)
				--inactivatable
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_CANNOT_DISABLE)
				e2:SetRange(LOCATION_MZONE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_FIELD)
				e3:SetCode(EFFECT_CANNOT_DISEFFECT)
				e3:SetRange(LOCATION_MZONE)
				e3:SetValue(cm.effectfilter)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e3)
			end
			if bit.band(t,TYPE_TRAP)~=0 then
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(m,3))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_IMMUNE_EFFECT)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e1:SetRange(LOCATION_MZONE)
				e1:SetValue(cm.efilter2)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e1)
				--cannot release
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e2:SetRange(LOCATION_MZONE)
				e2:SetCode(EFFECT_UNRELEASABLE_SUM)
				e2:SetValue(1)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e2)
				local e3=e2:Clone()
				e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
				c:RegisterEffect(e3)
			end
		end
	end
end
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end
function cm.effectfilter(e,ct)
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te:GetHandler()==e:GetHandler()
end
function cm.efilter1(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function cm.efilter2(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function cm.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
