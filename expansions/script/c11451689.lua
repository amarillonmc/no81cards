--水精鳞-深渊海信使
local cm,m=GetID()
function cm.initial_effect(c)
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m-3)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--effect2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m-2)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:SetLabel(0)
	local g=eg:Filter(cm.filter,nil)
	if #g>0 then
		--if r&REASON_DISCARD>0 then e:SetLabel(1) end
		return true
	else
		return false
	end
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spfilter2(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsReason(REASON_DISCARD)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then
			local g=eg:Filter(cm.spfilter2,nil,e,tp)
			return (Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) or #g>0) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		else
			return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		end
	end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	if e:GetLabel()==1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	else
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local g=eg:Filter(aux.NecroValleyFilter(cm.spfilter2),nil,e,tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if e:GetLabel()==0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			if #g>ft then g=g:Select(tp,ft,ft,nil) end
			for tc in aux.Next(g) do
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			local tc=g:GetFirst()
			if tc then Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) end
		end
	end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(1-tp,cm.spfilter,1-tp,LOCATION_HAND,0,1,1,nil,e,1-tp)
		local tc=g:GetFirst()
		if tc then Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP) end
	end
	Duel.SpecialSummonComplete()
end
function cm.tgfilter(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsLevelBelow(4) and c:IsSetCard(0x74)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and #g>0 then
		local lvt={}
		for sc in aux.Next(g) do
			local tlv=0
			tlv=tlv+sc:GetLevel()
			lvt[tlv]=tlv
		end
		local pc=1
		for i=1,4 do
			if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
		end
		lvt[pc]=nil
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
		local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(lv)
		tc:RegisterEffect(e1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:FilterSelect(tp,Card.IsLevel,1,1,nil,lv)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	elseif tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
		local lv=Duel.AnnounceNumber(tp,1,2,3,4)
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(lv)
		tc:RegisterEffect(e1)
	end
end