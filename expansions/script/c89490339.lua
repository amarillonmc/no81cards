--世坏双星
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,56099748,89490273)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.tgfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x198) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc~=c and s.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_ONFIELD,0,1,c,tp) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_ONFIELD,0,1,1,c,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function s.spfilter2(c,e,tp)
	return c:IsCode(89490273) and c:IsLevelAbove(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g<=0 then return end
		local tc=g:GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and tc:IsCode(56099748) and tc:IsLevelAbove(1) and Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.spfilter2),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter2),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
			if #sg<=0 then return end
			local sc=sg:GetFirst()
			if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)<=0 then return end
			local op=aux.SelectFromOptions(tp,{true,aux.Stringid(id,1)},{true,aux.Stringid(id,2)})
			if op==1 then
				local gc2
				local gc1=Group.FromCards(tc,sc):Select(tp,1,1,nil):GetFirst()
				if gc1==tc then gc2=sc else gc2=tc end
				Duel.HintSelection(Group.FromCards(gc1))
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(gc2:GetOriginalLevel())
				gc1:RegisterEffect(e1)
			else
				local lv=tc:GetOriginalLevel()+sc:GetOriginalLevel()
				s.setlv(c,tc,lv)
				s.setlv(c,sc,lv)
			end
		end
	end
end
function s.setlv(c,ec,lv)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(lv)
	ec:RegisterEffect(e1)
end
