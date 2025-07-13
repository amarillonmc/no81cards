--溯洄之门
function c11771174.initial_effect(c)
	aux.AddCodeList(c,11771171)
	--Activate
	local e1=aux.AddRitualProcGreater2(c,c11771174.filter,LOCATION_HAND+LOCATION_GRAVE,nil,c11771174.filter,false,c11771174.extraop)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11771174)
	e2:SetTarget(c11771174.thtg)
	e2:SetOperation(c11771174.thop)
	c:RegisterEffect(e2)
end
function c11771174.filter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c11771174.extraop(e,tp,eg,ep,ev,re,r,rp,tc,mat)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11771174.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c11771174.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsNonAttribute(ATTRIBUTE_WATER)
end
function c11771174.thfilter(c)
	return c:IsCode(11771171) and c:IsAbleToHand()
end
function c11771174.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c11771174.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11771174.thfilter,tp,LOCATION_GRAVE,0,1,nil) and e:GetHandler():IsAbleToDeck() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c11771174.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c11771174.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
end
