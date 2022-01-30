--暗影骑士出阵
local m=40010056
local cm=_G["c"..m]
cm.named_with_Revenger=1
function cm.Revenger(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Revenger
end
function cm.initial_effect(c)
	aux.AddRitualProcGreater2(c,cm.ritual_filter,LOCATION_HAND+LOCATION_GRAVE)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(cm.discon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.confilter(c)
	return c:IsFaceup() and (cm.Revenger(c) or c:IsCode(40010072))
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and cm.Revenger(c)
end
function cm.cfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and (cm.Revenger(c) or c:IsCode(40010072)) and c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil)
			and e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 and Duel.Release(g,REASON_EFFECT) then
		if c:IsRelateToEffect(e) then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,c)
		end
	end
end