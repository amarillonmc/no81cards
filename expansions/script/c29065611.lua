--战械后勤官 格林娜
function c29065611.initial_effect(c)
	--Equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,29065611)
	e1:SetTarget(c29065611.eqtg)
	e1:SetOperation(c29065611.eqop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,19065611)
	e2:SetTarget(c29065611.sptg)
	e2:SetOperation(c29065611.spop)
	c:RegisterEffect(e2)
end
function c29065611.eqfil(c,tp) 
	return c:IsRace(RACE_MACHINE) and c:IsSetCard(0x7ad) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
end
function c29065611.eqtfil(c)
	return c:IsSetCard(0x7ad)
end
function c29065611.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065611.eqfil,tp,LOCATION_DECK,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(c29065611.eqtfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function c29065611.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c29065611.eqfil,tp,LOCATION_DECK,0,nil,tp)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,c29065611.eqtfil,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	local ec=g:Select(tp,1,1,nil):GetFirst()
	if Duel.Equip(tp,ec,tc) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(tc)
			e1:SetValue(c29065611.eqlimit)
			ec:RegisterEffect(e1)
	end
end
function c29065611.eqlimit(e,c)
	return c==e:GetLabelObject() 
end
function c29065611.filter(c)
	return c:IsAbleToDeck() or c:IsAbleToGrave()
end
function c29065611.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c29065611.filter,tp,LOCATION_HAND,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c29065611.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		local g=Duel.SelectMatchingCard(tp,c29065611.filter,tp,LOCATION_HAND,0,1,1,nil)
		if #g==0 then return end
		local tc=g:GetFirst()
		if tc:IsAbleToDeck() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1193,1191)==0) then
			Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end
