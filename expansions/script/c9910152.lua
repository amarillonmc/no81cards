--战车道极限装填
function c9910152.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES_SELF)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9910152)
	e1:SetTarget(c9910152.target)
	e1:SetOperation(c9910152.activate)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910153)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910152.mattg)
	e2:SetOperation(c9910152.matop)
	c:RegisterEffect(e2)
end
function c9910152.xmfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c9910152.rthfilter(c,tp)
	local res=Duel.IsExistingMatchingCard(c9910152.xmfilter,tp,LOCATION_MZONE,0,1,nil) and c:IsCanOverlay(tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsAbleToHand() or res)
end
function c9910152.spfilter(c,e,tp)
	return c:IsCode(9910105) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c9910152.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c9910152.rthfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),tp)
	local b2=Duel.IsExistingMatchingCard(c9910152.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
end
function c9910152.activate(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c9910152.rthfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,aux.ExceptThisCard(e),tp)
	local b2=Duel.IsExistingMatchingCard(c9910152.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(9910152,0),aux.Stringid(9910152,1))+1
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(9910152,0))+1
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(9910152,1))+2
	end
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local rg=Duel.SelectMatchingCard(tp,c9910152.rthfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,aux.ExceptThisCard(e),tp)
		Duel.HintSelection(rg)
		local tc=rg:GetFirst()
		if tc then
			local res=Duel.IsExistingMatchingCard(c9910152.xmfilter,tp,LOCATION_MZONE,0,1,nil) and tc:IsCanOverlay(tp)
			if res and (not tc:IsAbleToHand() or Duel.SelectOption(tp,aux.Stringid(9910152,2),aux.Stringid(9910152,3))==1) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
				local tg=Duel.SelectMatchingCard(tp,c9910152.xmfilter,tp,LOCATION_MZONE,0,1,1,nil)
				Duel.HintSelection(tg)
				if tg:GetFirst():IsImmuneToEffect(e) then return end
				local og=tc:GetOverlayGroup()
				if #og>0 then Duel.SendtoGrave(og,REASON_RULE) end
				tc:CancelToGrave()
				Duel.Overlay(tg:GetFirst(),Group.FromCards(tc))
			else
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
			end
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c9910152.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c9910152.matfilter(c)
	return c:IsSetCard(0x9958) and c:IsCanOverlay()
end
function c9910152.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9910152.xmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910152.xmfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c9910152.matfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9910152.xmfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9910152.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c9910152.matfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
