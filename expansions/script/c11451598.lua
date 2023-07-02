--幻界行舟
local cm,m=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,11451599)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_RELEASE+CATEGORY_SEARCH)
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
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_LEAVE_GRAVE+CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(cm.adcon2)
	e2:SetTarget(cm.adtg2)
	e2:SetOperation(cm.adop2)
	c:RegisterEffect(e2)
	local e5=e2:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function cm.filter(c,tp)
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
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsReleasableByEffect,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function cm.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevel(7,8) and c:IsAbleToHand()
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasableByEffect,tp,LOCATION_ONFIELD,0,1,1,nil)
	if #g>0 and Duel.Release(g,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function cm.adcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,tp)
end
function cm.mfilter(c)
	return c:GetLevel()>0 and c:IsAbleToDeck() and c:IsReason(REASON_RELEASE)
end
function cm.mfilter2(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToDeck()
end
function cm.RitualUltimateFilter(c,filter,e,tp,m1,m2,level,greater_or_equal,chk)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level
	Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(Auxiliary.RitualCheck,1,lv,tp,c,lv,greater_or_equal)
	Auxiliary.GCheckAdditional=nil
	return res
end
function cm.rfilter(c,filter,e,tp,m1,m2,level,greater_or_equal,chk)
	return cm.RitualUltimateFilter(c,filter,e,tp,m1,m2,7,greater_or_equal,chk) or cm.RitualUltimateFilter(c,filter,e,tp,m1,m2,8,greater_or_equal,chk)
end
function cm.nfilter(c)
	return c:IsCode(11451599)
end
function cm.adtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_GRAVE,0,nil)
		return (Duel.IsExistingMatchingCard(cm.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,cm.nfilter,e,tp,mg,nil,7,"Equal") and Duel.IsExistingMatchingCard(cm.mfilter2,tp,LOCATION_GRAVE,0,1,nil)) or Duel.IsExistingMatchingCard(cm.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,cm.nfilter,e,tp,mg,nil,8,"Equal")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function cm.adop2(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.mfilter),tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local fil=cm.RitualUltimateFilter
	if Duel.IsExistingMatchingCard(cm.mfilter2,tp,LOCATION_GRAVE,0,1,nil) then fil=cm.rfilter end
	local g=Duel.SelectMatchingCard(tp,fil,tp,LOCATION_HAND,0,1,1,nil,cm.nfilter,e,tp,mg,nil,8,"Equal")
	local tc=g:GetFirst()
	if tc then
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		local rc=nil
		if Duel.IsExistingMatchingCard(cm.mfilter2,tp,LOCATION_GRAVE,0,1,nil) and cm.RitualUltimateFilter(tc,cm.nfilter,e,tp,mg,nil,7,"Equal") and (not cm.RitualUltimateFilter(tc,cm.nfilter,e,tp,mg,nil,8,"Equal") or Duel.SelectYesNo(tp,aux.Stringid(m,3))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			rc=Duel.SelectMatchingCard(tp,cm.mfilter2,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local lv=8
		if rc then lv=7 end
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,lv,"Equal")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,lv,tp,tc,lv,"Equal")
		aux.GCheckAdditional=nil
		if not mat then goto cancel end
		if rc then mat:AddCard(rc) end
		tc:SetMaterial(mat)
		if rc then mat:RemoveCard(rc) end
		Duel.SendtoDeck(mat,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		if rc then
			Duel.SendtoHand(rc,nil,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
			Duel.ConfirmCards(1-tp,rc)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end