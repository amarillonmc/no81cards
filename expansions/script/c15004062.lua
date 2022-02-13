local m=15004062
local cm=_G["c"..m]
cm.name="荒仙法令-伊甸登出"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(cm.srcost)
	e2:SetTarget(cm.srtg)
	e2:SetOperation(cm.srop)
	c:RegisterEffect(e2)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RELEASE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.rhcon)
	e3:SetTarget(cm.rhtg)
	e3:SetOperation(cm.rhop)
	c:RegisterEffect(e3)
end
function cm.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsReleasable()
		and Duel.IsExistingMatchingCard(cm.srfilter,tp,LOCATION_DECK,0,1,nil,c:GetOriginalAttribute())
end
function cm.srfilter(c,att)
	return c:IsSetCard(0x9f3e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:GetOriginalAttribute()~=att
end
function cm.srcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) and (Duel.GetFlagEffect(tp,15004062)<1 or (e:GetHandler():IsHasEffect(15004080) and Duel.GetFlagEffect(tp,15004062)<3))
	end
	Duel.RegisterFlagEffect(tp,15004062,RESET_PHASE+PHASE_END,0,1)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetOriginalAttribute())
	Duel.Release(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.srop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local att=e:GetLabel()
	if att==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.srfilter,tp,LOCATION_DECK,0,1,1,nil,att)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.rhfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and c:IsReason(REASON_COST) and c:IsAbleToHand()
end
function cm.rhcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActivated() and eg:IsExists(cm.rhfilter,1,nil,tp) and not re:GetHandler():IsCode(15004062)
end
function cm.rhtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.rhfilter,1,nil,tp)
		and (Duel.GetFlagEffect(tp,15004063)<1 or (e:GetHandler():IsHasEffect(15004080) and Duel.GetFlagEffect(tp,15004063)<3)) end
	Duel.RegisterFlagEffect(tp,15004063,RESET_PHASE+PHASE_END,0,1)
	local g=eg:Filter(cm.rhfilter,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function cm.rhop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(cm.rhfilter,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end