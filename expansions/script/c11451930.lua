--结界守护灵 英士白
local cm,m=GetID()
function cm.initial_effect(c)
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.adcon)
	e1:SetCost(cm.adcost)
	e1:SetTarget(cm.adtg)
	e1:SetOperation(cm.adop)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--ritual
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetLabelObject(e0)
	e2:SetCondition(cm.adcon2)
	e2:SetCost(cm.adcost2)
	e2:SetTarget(cm.adtg2)
	e2:SetOperation(cm.adop2)
	c:RegisterEffect(e2)
	local e5=e2:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function cm.filter(c,tp,se)
	if not (se==nil or c:GetReasonEffect()~=se) then return false end
	return c:IsControler(tp)
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,1-tp)
end
function cm.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,4))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end
function cm.spfilter1(c,e,tp)
	return c:IsLevelAbove(1) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and Duel.GetMZoneCount(1-tp)>0)
end
function cm.spfilter2(c,e,tp)
	return c:IsLevelAbove(1) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0)
end
function cm.spfilter(c,e,tp)
	return cm.spfilter1(c,e,tp) or cm.spfilter2(c,e,tp)
end
function cm.spfilter3(c,e,tp,g)
	return cm.spfilter1(c,e,tp) and g:FilterCount(cm.spfilter2,c,e,tp)==#g-1
end
function cm.spfilter4(c,e,tp)
	return cm.spfilter1(c,e,tp) and c:IsLevel(8)
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then
		if g:IsExists(cm.spfilter4,1,nil,e,tp) then return true end
		local ft=Duel.GetMZoneCount(tp)
		return not Duel.IsPlayerAffectedByEffect(tp,59822133) and g:CheckSubGroup(cm.fselect,1,math.min(#g,ft+1),e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.fselect(g,e,tp)
	return g:GetSum(Card.GetLevel)==8 and g:IsExists(cm.spfilter3,1,nil,e,tp,g) 
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	local ft=Duel.GetMZoneCount(tp)
	if g:IsExists(cm.spfilter4,1,nil,e,tp) or (not Duel.IsPlayerAffectedByEffect(tp,59822133) and g:CheckSubGroup(cm.fselect,1,math.min(#g,ft+1),e,tp)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,cm.fselect,false,1,math.min(#g,ft+1),e,tp)
		local tg=sg
		if #sg>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
			tg=sg:FilterSelect(tp,cm.spfilter3,1,1,nil,e,tp,sg)
		end
		sg:Sub(tg)
		Duel.SpecialSummonStep(tg:GetFirst(),0,tp,1-tp,false,false,POS_FACEUP)
		for sc in aux.Next(sg) do
			Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end
function cm.adcon2(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(cm.filter,1,nil,tp,se)
end
function cm.adcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHandAsCost,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(m,3))
	local pg=Duel.SelectMatchingCard(1-tp,Card.IsAbleToHandAsCost,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoHand(pg,1-tp,REASON_COST)
end
function cm.adtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(Card.IsControler,nil,tp):Filter(Card.IsLocation,nil,LOCATION_MZONE)
	if chk==0 then return #g>0 end
	Duel.SetTargetCard(g)
end
function cm.tgfilter(c,e)
	return c:IsRelateToEffect(e) --and not c:IsImmuneToEffect(e)
end
function cm.adop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(cm.tgfilter,nil,e)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetValue(LOCATION_HAND)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		tc:RegisterEffect(e1)
	end
end