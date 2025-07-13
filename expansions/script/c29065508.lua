--方舟骑士-陈
function c29065508.initial_effect(c)
	aux.AddCodeList(c,29065500) 
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	--attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065508,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,29065509)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c29065508.bttg)
	e2:SetOperation(c29065508.btop)
	c:RegisterEffect(e2)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(29065508,0))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1,29065508)
	e6:SetCost(c29065508.thcost)
	e6:SetTarget(c29065508.thtg)
	e6:SetOperation(c29065508.thop)
	c:RegisterEffect(e6)
end
function c29065508.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29065508.thfilter(c,tc)
	return aux.IsCodeListed(c,tc:GetCode()) and c:IsAbleToHand()
end
function c29065508.tgfilter(c,tp)
	return c:IsSetCard(0x87af) and c:IsFaceup() and Duel.IsExistingMatchingCard(c29065508.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c)
end
function c29065508.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c29065508.tgfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c29065508.tgfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c29065508.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c29065508.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c29065508.atkcheck(c,atk)
	return c:IsAttackBelow(atk-1)
end
function c29065508.bttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	if chk==0 then return Duel.IsExistingMatchingCard(c29065508.atkcheck,tp,0,LOCATION_MZONE,1,nil,atk) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
end
function c29065508.btop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local atk=c:GetAttack()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,c29065508.atkcheck,tp,0,LOCATION_MZONE,1,1,nil,atk)
		if dg:GetCount()>0 then
			Duel.HintSelection(dg)
			local tc=dg:GetFirst()
			local minatk=tc:GetAttack()
			local dam=atk-minatk
			if Duel.Destroy(dg,REASON_EFFECT)>0 then
				Duel.Damage(1-tp,dam,REASON_EFFECT)
			end
		end
	end
end










