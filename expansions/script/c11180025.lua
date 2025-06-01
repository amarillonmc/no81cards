--幻殇·辉裔
function c11180025.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--set
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOGRAVE)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,11180025)
	e0:SetTarget(c11180025.settg)
	e0:SetOperation(c11180025.setop)
	c:RegisterEffect(e0)
	--sp summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11180025,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11180025+1000)
	e1:SetTarget(c11180025.tgtg)
	e1:SetOperation(c11180025.tgop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11180025,2))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_EXTRA+LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,11180025+2000)
	e2:SetTarget(c11180025.tdtg)
	e2:SetOperation(c11180025.tdop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,11180025+3000)
	e3:SetCondition(c11180025.thcon)
	e3:SetTarget(c11180025.thtg)
	e3:SetOperation(c11180025.thop)
	c:RegisterEffect(e3)
end
function c11180025.rgfilter(c)
	return c:IsAbleToGrave()
end
function c11180025.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11180025.rgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x20)
end
function c11180025.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c11180025.rgfilter,tp,LOCATION_REMOVED,0,1,2,nil)
	if #g>0 then Duel.SendtoGrave(g,0x40+REASON_RETURN) end
end
function c11180025.tgfilter(c)
	return c:IsAbleToGrave() or c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c11180025.tgfilter2,tp,LOCATION_DECK,0,1,nil,c)
end
function c11180025.tgfilter2(c,tc)
	local type=tc:GetType()&0x7
	return c:IsSetCard(0x3450,0x6450) and not c:IsType(type) and (c:IsAbleToHand() or c:IsSSetable())
end
function c11180025.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c11180025.tgfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c11180025.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,c11180025.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
		local tc=g:GetFirst()
		local ck=0
		if tc and tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
			if Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(0x10) then ck=1 end
		else
			if Duel.Remove(tc,POS_FACEUP,0x40)>0 and tc:IsLocation(0x20) then ck=1 end
		end
		if ck==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g2=Duel.SelectMatchingCard(tp,c11180025.tgfilter2,tp,LOCATION_DECK,0,1,1,nil,tc)
			local tc2=g2:GetFirst()
			if tc2 then
				Duel.BreakEffect()
				Duel.SendtoGrave(tc2,0x40)
			end
		end
	end
end
function c11180025.tdfilter(c,tp,loc,sc)
	return c:IsSetCard(0x3450) and c:IsFaceup() and c:IsAbleToDeck()
		and (Duel.GetMZoneCount(tp,c)>0 and loc&(LOCATION_HAND)>0
			or Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and loc&(LOCATION_EXTRA)>0)
end
function c11180025.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c11180025.tdfilter(chkc) end
	local c=e:GetHandler()
	local loc=c:GetLocation()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c11180025.tdfilter,tp,LOCATION_ONFIELD,0,1,nil,tp,loc,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c11180025.tdfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp,loc,c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11180025.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0
		and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA)
		and c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c11180025.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetOwner():IsSetCard(0x3450,0x6450)
end
function c11180025.thfilter(c)
	return c:IsSetCard(0x3450) and c:IsFaceupEx() and c:IsAbleToHand()
end
function c11180025.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11180025.thfilter,tp,0x30,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x30)
end
function c11180025.filter2(c,tp)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c11180025.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11180025.thfilter,tp,0x30,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,0x40) and g:GetFirst():IsLocation(0x2) then
		local tg=Duel.GetMatchingGroup(c11180025.filter2,tp,LOCATION_MZONE,0,nil)
		if #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(11180025,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local tc=tg:Select(tp,1,1,nil):GetFirst()
			if tc then
				local sel=0
				local lvl=1
				if tc:IsLevel(1) then
					sel=Duel.SelectOption(tp,aux.Stringid(11180025,4))
				else
					sel=Duel.SelectOption(tp,aux.Stringid(11180025,4),aux.Stringid(11180025,5))
				end
				if sel==1 then
					lvl=-1
				end
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetValue(lvl)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		end
	end
end