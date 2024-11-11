--岭偶擎天神将
function c9911672.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,3)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9911672)
	e1:SetCost(c9911672.thcost)
	e1:SetTarget(c9911672.thtg)
	e1:SetOperation(c9911672.thop)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCountLimit(1,9911673)
	e2:SetCondition(c9911672.efcon)
	e2:SetOperation(c9911672.efop)
	c:RegisterEffect(e2)
end
function c9911672.thfilter(c)
	return (c:IsSetCard(0x5957) or c:IsCode(9911675)) and c:IsAbleToHand()
end
function c9911672.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9911672.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) and #g>0 end
	local ct=Duel.RemoveOverlayCard(tp,1,0,1,math.min(#g,2),REASON_COST)
	e:SetLabel(ct)
end
function c9911672.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911672.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	local ct=e:GetLabel()
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ct,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9911672.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9911672.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if #g>=ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,ct,ct,nil)
		if #sg>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c9911672.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c9911672.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(9911672,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c9911672.destg)
	e1:SetOperation(c9911672.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function c9911672.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*300)
end
function c9911672.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
		Duel.Damage(1-tp,ct*300,REASON_EFFECT)
	end
end
