--幻界行舟
local cm,m=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,11451599)
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_RELEASE+CATEGORY_SEARCH)
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
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_LEAVE_GRAVE+CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetLabelObject(e0)
	e2:SetCondition(cm.adcon2)
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
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(cm.filter,1,nil,tp,se)
end
function cm.mfilter(c)
	return c:GetLevel()>0 and (c:IsAbleToDeck() or c:IsAbleToHand()) --and c:IsReason(REASON_RELEASE)
end
function cm.mfilter2(c)
	return c:IsType(TYPE_SPELL) and (c:IsAbleToDeck() or c:IsAbleToHand())
end
function cm.RitualUltimateFilter(c,filter,e,tp,m1,m2,level,greater_or_equal,chk)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1 --:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level
	Auxiliary.GCheckAdditional=aux.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(cm.RitualCheck,1,lv,tp,c,lv,greater_or_equal)
	Auxiliary.GCheckAdditional=nil
	return res
end
function cm.RitualCheck(g,tp,c,lv,greater_or_equal)
	return Auxiliary["RitualCheck"..greater_or_equal](g,c,lv) and Duel.GetMZoneCount(tp,g,tp)>0 and (not c.mat_group_check or c.mat_group_check(g,tp)) and (not Auxiliary.RCheckAdditional or Auxiliary.RCheckAdditional(tp,g,c)) and g:IsExists(cm.thfilter2,1,nil,g)
end
function cm.thfilter2(c,g)
	return c:IsAbleToHand() and not g:IsExists(cm.ntdfilter,1,c)
end
function cm.ntdfilter(c)
	return not c:IsAbleToDeck()
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
		local mg2=Duel.GetMatchingGroup(cm.mfilter2,tp,LOCATION_GRAVE,0,nil)
		local _GetRitualLevel=Card.GetRitualLevel
		Card.GetRitualLevel=function(c,rc) if c:IsType(TYPE_SPELL) then return 1 else return _GetRitualLevel(c,rc) end end
		local res=not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.IsExistingMatchingCard(cm.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,cm.nfilter,e,tp,mg,mg2,8,"Equal") --((Duel.IsExistingMatchingCard(cm.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,cm.nfilter,e,tp,mg,nil,7,"Equal") and Duel.IsExistingMatchingCard(cm.mfilter2,tp,LOCATION_GRAVE,0,1,nil)) or Duel.IsExistingMatchingCard(cm.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,cm.nfilter,e,tp,mg,nil,8,"Equal"))
		Card.GetRitualLevel=_GetRitualLevel
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function cm.adop2(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.mfilter),tp,LOCATION_GRAVE,0,nil)
	local mg2=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.mfilter2),tp,LOCATION_GRAVE,0,nil)
	local _GetRitualLevel=Card.GetRitualLevel
	Card.GetRitualLevel=function(c,rc) if c:IsType(TYPE_SPELL) then return 1 else return _GetRitualLevel(c,rc) end end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local fil=cm.RitualUltimateFilter
	--if Duel.IsExistingMatchingCard(cm.mfilter2,tp,LOCATION_GRAVE,0,1,nil) then fil=cm.rfilter end
	local g=Duel.SelectMatchingCard(tp,fil,tp,LOCATION_HAND,0,1,1,nil,cm.nfilter,e,tp,mg,mg2,8,"Equal")
	local tc=g:GetFirst()
	if tc then
		--mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		--[[local rc=nil
		if cm.RitualUltimateFilter(tc,cm.nfilter,e,tp,mg,nil,7,"Equal") and Duel.IsExistingMatchingCard(cm.mfilter2,tp,LOCATION_GRAVE,0,1,nil) and (not cm.RitualUltimateFilter(tc,cm.nfilter,e,tp,mg,nil,8,"Equal") or Duel.SelectYesNo(tp,aux.Stringid(m,3))) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			rc=Duel.SelectMatchingCard(tp,cm.mfilter2,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
		end--]]
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local lv=8
		--if rc then lv=7 end
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,lv,"Equal")
		local mat=mg:SelectSubGroup(tp,cm.RitualCheck,true,1,lv,tp,tc,lv,"Equal")
		aux.GCheckAdditional=nil
		--if not mat then goto cancel end
		Card.GetRitualLevel=_GetRitualLevel
		--if rc then mat:AddCard(rc) end
		tc:SetMaterial(mat)
		--if rc then mat:RemoveCard(rc) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local rc=mat:FilterSelect(tp,cm.thfilter2,1,1,nil,mat):GetFirst()
		Duel.SendtoHand(rc,nil,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		mat:RemoveCard(rc)
		Duel.SendtoDeck(mat,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		--[[if rc then
			Duel.SendtoHand(rc,nil,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
			Duel.ConfirmCards(1-tp,rc)
		end--]]
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end