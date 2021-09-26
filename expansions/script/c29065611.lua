--战械人形 AN94
function c29065611.initial_effect(c)
	--special summon while equipped
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065611,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,29065611)
	e2:SetTarget(c29065611.sptg)
	e2:SetOperation(c29065611.spop)
	c:RegisterEffect(e2)  
	--To hand or equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(29065611,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE)
	e4:SetCountLimit(1,29065611)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c29065611.eqtg)
	e4:SetOperation(c29065611.eqop)
	c:RegisterEffect(e4)  
end
function c29065611.filter(c,e,tp)
	return c:IsSetCard(0x7ad) and not c:IsCode(29065611) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c29065611.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c29065611.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c29065611.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c29065611.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c29065611.cfilter(c)
	return c:IsSetCard(0x7ad) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c29065611.eqfilter(c)
	return not c:IsCode(29065611) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c29065611.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local equip=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingMatchingCard(c29065611.cfilter,tp,LOCATION_MZONE,0,1,nil)
		return Duel.IsExistingMatchingCard(c29065611.eqfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,equip,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c29065611.eqop(e,tp,eg,ep,ev,re,r,rp)
	local equip=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c29065611.cfilter,tp,LOCATION_MZONE,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c29065611.eqfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,equip,tp)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
		if equip and tc:CheckUniqueOnField(tp) and not tc:IsForbidden()
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,aux.Stringid(29065611,2))==1) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local sc=Duel.SelectMatchingCard(tp,c29065611.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
			Duel.Equip(tp,tc,sc:GetFirst())
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c29065611.eqlimit)
			e1:SetLabelObject(sc:GetFirst())
			tc:RegisterEffect(e1)
		else
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c29065611.eqlimit(e,c)
	return c==e:GetLabelObject() 
end