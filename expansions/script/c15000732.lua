local m=15000732
local cm=_G["c"..m]
cm.name="噩梦茧机蝶·贝娅特丽克丝"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,3,cm.ovfilter,aux.Stringid(m,0),3,cm.xyzop)
	c:EnableReviveLimit()
	--P
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON+CATEGORY_DESTROY+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(cm.pcon)
	e1:SetTarget(cm.ptg)
	e1:SetOperation(cm.pop)
	c:RegisterEffect(e1)
	--SearchCard
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,15000732)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.mcon)
	e2:SetTarget(cm.mtg)
	e2:SetOperation(cm.mop)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(cm.retcon)
	e3:SetCost(cm.retcost)
	e3:SetTarget(cm.rettg)
	e3:SetOperation(cm.retop)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_HAND,0)
	e4:SetTarget(cm.eftg)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
c15000732.pendulum_level=4
function cm.ovfilter(c)
	return c:GetEffectCount(15000724)~=0
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return e:GetHandler():IsRank(2,3) end
end
function cm.pfilter(c,e,tp)
	return c:IsSetCard(0x6f38) and c:IsAbleToHand()
end
function cm.pcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x6f38)
end
function cm.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDestructable(e) and Duel.IsExistingTarget(cm.pfilter,tp,LOCATION_PZONE,0,1,c) end
	local g=Duel.SelectTarget(tp,cm.pfilter,tp,LOCATION_PZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_PZONE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,tp,LOCATION_PZONE)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,0)
end
function cm.sumfilter(c)
	return c:IsSetCard(0x6f38) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_PENDULUM) and c:IsSummonable(true,nil)
end
function cm.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	if not tc:IsRelateToEffect(e) then return end
	if Duel.Destroy(c,REASON_EFFECT)~=0 then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and Duel.SelectYesNo(tp,aux.Stringid(15000722,0)) and Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
			local sumc=g:GetFirst()
			if sumc then
				Duel.Summon(tp,sumc,true,nil)
			end
		end
	end
end
function cm.mcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()==0
end
function cm.mtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.srfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.srfilter(c)
	return c:IsSetCard(0x6f38) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.mop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.srfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()~=0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,15000732)~=0 then
		for _,i in ipairs{Duel.GetFlagEffectLabel(tp,15000732)} do
			if i==c:GetOriginalCodeRule() then return false end
		end
	end
	if Duel.GetFlagEffect(tp,15000733)~=0 then
		for _,i in ipairs{Duel.GetFlagEffectLabel(tp,15000733)} do
			if bit.band(i,bit.band(re:GetActiveType(),TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER))~=0 then return false end
		end
	end
	return Duel.IsChainNegatable(ev)
end
function cm.retcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.RegisterFlagEffect(tp,15000732,RESET_PHASE+PHASE_END,0,1,c:GetOriginalCodeRule())
end
function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoExtraP(c,nil,REASON_EFFECT)~=0 then
		if Duel.NegateActivation(ev) then
			Duel.RegisterFlagEffect(tp,15000733,RESET_PHASE+PHASE_END,0,1,bit.band(re:GetActiveType(),TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER))
			if re:GetHandler():IsRelateToEffect(re) then
				Duel.Destroy(eg,REASON_EFFECT)
			end
		end
	end
end
function cm.eftg(e,c)
	return c:IsSetCard(0x6f38) and c:IsLocation(LOCATION_HAND) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_PENDULUM)
end