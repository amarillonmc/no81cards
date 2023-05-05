--星辉之夜尽女神
function c9910626.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1)
	e1:SetTarget(c9910626.mattg)
	e1:SetOperation(c9910626.matop)
	c:RegisterEffect(e1)
	--tohand spell
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c9910626.thcon)
	e2:SetTarget(c9910626.thtg)
	e2:SetOperation(c9910626.thop)
	c:RegisterEffect(e2)
	--tohand monster
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(c9910626.thcon2)
	e3:SetOperation(c9910626.thop2)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c9910626.xfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c9910626.xfilter2(c,e)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and not c:IsImmuneToEffect(e)
end
function c9910626.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsCanOverlay() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanOverlay,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c9910626.xfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,Card.IsCanOverlay,tp,0,LOCATION_MZONE,1,1,nil)
end
function c9910626.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e)
		and Duel.IsExistingMatchingCard(c9910626.xfilter2,tp,LOCATION_MZONE,0,1,nil,e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=Duel.SelectMatchingCard(tp,c9910626.xfilter2,tp,LOCATION_MZONE,0,1,1,nil,e)
		local sc=sg:GetFirst()
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(sc,Group.FromCards(tc))
	end
end
function c9910626.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9910626.thfilter(c)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand()
end
function c9910626.thfilter2(c,e)
	if bit.band(c:GetType(),0x82)~=0x82 or not c:IsAbleToHand() then return false end
	local flag=0
	local codes={}
	table.insert(codes,e:GetLabel())
	if #codes>0 then
		for i=1,#codes do
			if aux.IsCodeListed(c,codes[i]) then flag=1 end
		end
	end
	return flag==1
end
function c9910626.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910626.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910626.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910626.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		if not c:IsRelateToEffect(e) or not c:IsLocation(LOCATION_GRAVE) then return end
		e:SetLabel(tc:GetOriginalCodeRule())
		c:RegisterFlagEffect(9910626,RESET_EVENT+0x1e60000,0,1)
	end
end
function c9910626.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and e:GetHandler():GetFlagEffect(9910626)~=0
end
function c9910626.thop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910626.thfilter2,tp,LOCATION_DECK,0,nil,e:GetLabelObject())
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910626,0)) then
		Duel.Hint(HINT_CARD,0,9910626)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
