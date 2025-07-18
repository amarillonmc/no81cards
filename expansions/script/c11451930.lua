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
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
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
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
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
	return cm.spfilter(c,e,tp) and c:IsLevel(8)
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then
		if g:IsExists(cm.spfilter4,1,nil,e,tp) then return true end
		local ft1=Duel.GetMZoneCount(1-tp)
		local ft2=Duel.GetMZoneCount(tp)
		local ft=ft1+ft2
		return not Duel.IsPlayerAffectedByEffect(tp,59822133) and g:CheckSubGroup(cm.fselect,2,math.min(#g,ft),e,tp,ft1,ft2)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.fselect(g,e,tp,ft1,ft2)
	return g:GetSum(Card.GetLevel)==8 and g:CheckSubGroup(cm.fselect1,math.max(0,#g-ft2),math.min(#g,ft1),e,tp,g,ft1,ft2) 
end
function cm.fselect1(g,e,tp,mg,ft1,ft2)
	local g2=mg-g
	return g:FilterCount(cm.spfilter1,nil,e,tp)==#g and g2:FilterCount(cm.spfilter2,nil,e,tp)==#g2
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	local ft1=Duel.GetMZoneCount(1-tp)
	local ft2=Duel.GetMZoneCount(tp)
	local ft=ft1+ft2
	if g:IsExists(cm.spfilter4,1,nil,e,tp) or (not Duel.IsPlayerAffectedByEffect(tp,59822133) and g:CheckSubGroup(cm.fselect,2,math.min(#g,ft),e,tp,ft1,ft2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,cm.fselect,false,1,math.min(#g,ft),e,tp,ft1,ft2)
		local tg=Group.CreateGroup()
		if #sg>ft2 or (ft1>0 and not Duel.SelectYesNo(tp,aux.Stringid(m,6))) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
			sg=sg:Filter(cm.spfilter1,nil,e,tp,sg,ft1,ft2)
			if #sg-ft2>0 then
				tg=sg:Select(tp,math.max(1,#sg-ft2),math.min(#sg,ft1),nil)
			else
				tg=sg:CancelableSelect(tp,1,math.min(#sg,ft1),nil)
			end
			if not tg then tg=Group.CreateGroup() end
			sg:Sub(tg)
		end
		for sc in aux.Next(sg) do
			Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
		end
		for tc in aux.Next(tg) do
			Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP)
		end
		for tc in aux.Next(tg+sg) do
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e2=e1:Clone()
				e2:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				tc:RegisterEffect(e2)
			end
		end
		Duel.SpecialSummonComplete()
		--[[local g1=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
		if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=g1:Select(tp,1,1,nil):GetFirst()
			Duel.SynchroSummon(tp,sc,nil)
		end--]]
		Duel.AdjustAll()
		local tp=1-tp
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
		local ft1=Duel.GetMZoneCount(1-tp)
		local ft2=Duel.GetMZoneCount(tp)
		local ft=ft1+ft2
		if (g:IsExists(cm.spfilter4,1,nil,e,tp) or (not Duel.IsPlayerAffectedByEffect(tp,59822133) and g:CheckSubGroup(cm.fselect,2,math.min(#g,ft),e,tp,ft1,ft2))) and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:SelectSubGroup(tp,cm.fselect,false,1,math.min(#g,ft),e,tp,ft1,ft2)
			local tg=Group.CreateGroup()
			if #sg>ft2 or (ft1>0 and not Duel.SelectYesNo(tp,aux.Stringid(m,6))) then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
				sg=sg:Filter(cm.spfilter1,nil,e,tp,sg,ft1,ft2)
				if #sg-ft2>0 then
					tg=sg:Select(tp,1,math.min(#sg,ft1),nil)
				else
					tg=sg:CancelableSelect(tp,1,math.min(#sg,ft1),nil)
				end
				if not tg then tg=Group.CreateGroup() end
				sg:Sub(tg)
			end
			for tc in aux.Next(tg) do
				Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP)
			end
			for sc in aux.Next(sg) do
				Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
			end
			Duel.SpecialSummonComplete()
		end
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
	Duel.ConfirmCards(tp,pg)
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