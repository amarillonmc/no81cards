--闪蝶幻乐手 广町七深
function c9911459.initial_effect(c)
	--recycle
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9911459)
	e1:SetTarget(c9911459.rctg)
	e1:SetOperation(c9911459.rcop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP)
	e3:SetCondition(c9911459.rccon)
	c:RegisterEffect(e3)
	c9911459.morfonica_summon_effect=e1
	--adjust(disablecheck)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(0xff)
	e4:SetLabelObject(e1)
	e4:SetOperation(c9911459.adjustop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetLabelObject(e2)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetLabelObject(e3)
	c:RegisterEffect(e6)
	--to hand(self)
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCountLimit(1,9911460)
	e7:SetCondition(c9911459.thcon2)
	e7:SetTarget(c9911459.thtg2)
	e7:SetOperation(c9911459.thop2)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e8)
end
function c9911459.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	if Duel.GetFlagEffect(tp,9911471)~=0 then
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	else
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	end
end
function c9911459.rccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9911472)~=0
end
function c9911459.rcfilter1(c,e)
	return c:IsCanBeEffectTarget(e) and (c:IsAbleToHand() or c:IsAbleToDeck())
end
function c9911459.rcfilter2(c)
	return c:IsFaceupEx() and c:IsSetCard(0x3952)
end
function c9911459.fselect(g)
	return g:IsExists(c9911459.rcfilter2,1,nil) and g:IsExists(Card.IsAbleToHand,1,nil) and g:IsExists(Card.IsAbleToDeck,2,nil)
end
function c9911459.rctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local dg=Duel.GetMatchingGroup(c9911459.rcfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil,e)
	if chkc then return false end
	if chk==0 then return dg:CheckSubGroup(c9911459.fselect,3,3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=dg:SelectSubGroup(tp,c9911459.fselect,false,3,3)
	if chk==9911466 then Duel.HintSelection(g) end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,3,0,0)
end
function c9911459.rcop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #tg==0 or aux.NecroValleyNegateCheck(tg) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=tg:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
	Duel.HintSelection(sg)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	tg:Sub(sg)
	if #tg>0 then
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c9911459.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c9911459.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c9911459.sumfilter(c)
	return c:IsSetCard(0x3952) and c:IsSummonable(true,nil)
end
function c9911459.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_HAND)
		and Duel.IsExistingMatchingCard(c9911459.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9911459,1)) then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,c9911459.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
