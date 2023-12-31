--龙刻秘仪
local m=40010352
local cm=_G["c"..m]
cm.named_with_DragWizard=1
function cm.DragWizard(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_DragWizard
end
function cm.initial_effect(c)

	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.rtg)
	e1:SetOperation(cm.rtop)
	c:RegisterEffect(e1)

end
--Effect 1
function cm.filter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.rtf(c,filter,e,tp,m1,m2,level_function,greater_or_equal)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level_function(c)
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(aux.RitualCheck,1,lv,tp,c,lv,greater_or_equal)
	aux.GCheckAdditional=nil
	return res
end
function cm.f3(c,filter,e,tp,m1,m2,level_function,greater_or_equal,rg)
	local mchk=cm.DragWizard(c) and bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToGrave() 
	if mchk and cm.rtf(c,filter,e,tp,m1,m2,level_function,greater_or_equal) then
		rg:AddCard(c)
	end
	return mchk and #rg>0
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp) 
		local rg=Duel.GetMatchingGroup(cm.rtf,tp,LOCATION_GRAVE,0,nil,cm.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
		return Duel.IsExistingMatchingCard(cm.f3,tp,LOCATION_DECK,0,1,nil,cm.filter,e,tp,mg,mg2,Card.GetLevel,"Greater",rg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE) 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.rtop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp) 
	local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.rtf),tp,LOCATION_GRAVE,0,nil,cm.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local ag=Duel.SelectMatchingCard(tp,cm.f3,tp,LOCATION_DECK,0,1,1,nil,cm.filter,e,tp,mg,mg2,Card.GetLevel,"Greater",rg)
	if #ag>0 and Duel.SendtoGrave(ag,REASON_EFFECT)~=0 then
		local agc=ag:GetFirst()
		if agc:IsLocation(LOCATION_GRAVE) and agc:IsAttribute(ATTRIBUTE_DARK) and agc:IsType(TYPE_RITUAL) then
			rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.rtf),tp,LOCATION_GRAVE,0,nil,cm.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
		end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=rg:FilterSelect(tp,aux.NecroValleyFilter(cm.rtf),1,1,nil,cm.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
		local tc=tg:GetFirst()
		if tc then
			mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,tc,tp)
			else
				mg:RemoveCard(tc)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
			local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
			aux.GCheckAdditional=nil
			if not mat or mat:GetCount()==0 then return end
			tc:SetMaterial(mat) 
			Duel.ReleaseRitualMaterial(mat)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end   
end

--Effect 3 
--Effect 4 
--Effect 5   
