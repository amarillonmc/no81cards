--超速再生
function c60150641.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,60150641+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c60150641.target)
	e1:SetOperation(c60150641.activate)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60150641+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c60150641.target2)
	e1:SetOperation(c60150641.activate2)
	c:RegisterEffect(e1)
end
function c60150641.rmfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xab21) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()==0
end
function c60150641.rmfilter2(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsAbleToChangeControler() and not c:IsType(TYPE_TOKEN)
end
function c60150641.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c60150641.rmfilter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingTarget(c60150641.rmfilter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c60150641.rmfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c60150641.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150641,0))
		local g=Duel.SelectMatchingCard(tp,c60150641.rmfilter2,tp,0,LOCATION_MZONE,1,2,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			local tc2=g:GetFirst()
			while tc2 do
				if tc:IsRelateToEffect(e) and not tc2:IsImmuneToEffect(e) then
					local og=tc2:GetOverlayGroup()
					if og:GetCount()>0 then
						Duel.SendtoGrave(og,REASON_RULE)
					end
					Duel.Overlay(tc,tc2)
				end
				tc2=g:GetNext()
			end
		end
	end
end
--[[function c60150641.thfilter(c)
return c:IsSetCard(0x5b21) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c60150641.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150641.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c60150641.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end]]
	
function c60150641.filter(c,e,tp)
	return c:IsSetCard(0xab21) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60150641.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c60150641.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c60150641.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
		and Duel.IsExistingTarget(c60150641.filter2,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c60150641.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c60150641.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c60150641.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150641,0))
			local g=Duel.SelectMatchingCard(tp,c60150641.filter2,tp,LOCATION_EXTRA,0,1,1,nil)
			if g:GetCount()>0 then
				e:GetHandler():CancelToGrave()
				g:AddCard(e:GetHandler())
				Duel.Overlay(tc,g)
			end
		end
	end
end