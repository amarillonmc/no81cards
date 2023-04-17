--方舟骑士长夜临光
local m=29081673
local cm=_G["c"..m]
cm.named_with_Arknight=1
function cm.initial_effect(c)
	aux.AddCodeList(c,29016634)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
cm.kinkuaoi_Lightakm=true
function cm.filter(c,e,tp)
	return c:IsCode(29016634)--(c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function cm.mfilter(c)
	return c:GetLevel()>0 and c:IsAttribute(ATTRIBUTE_LIGHT) and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsReleasableByEffect()
end
function cm.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
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
	Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(Auxiliary.RitualCheck,1,lv,tp,c,lv,greater_or_equal)
	Auxiliary.GCheckAdditional=nil
	return res
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
	
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(p,5)
	local g=Duel.GetDecktopGroup(p,5)
	local ct=5
	if #g>0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=g:Filter(cm.mfilter,nil)
		mg1:Merge(mg2)
		if Duel.IsExistingMatchingCard(cm.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,cm.filter,e,tp,mg1,nil,Card.GetLevel,"Greater") and Duel.SelectYesNo(tp,aux.Stringid(93754402,1)) then
			Duel.BreakEffect()
			::cancel::
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,cm.filter,e,tp,mg1,nil,Card.GetLevel,"Greater")
			local tc=g:GetFirst()
			if tc then
				local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
				if tc.mat_filter then
					mg=mg:Filter(tc.mat_filter,tc,tp)
				else
					mg:RemoveCard(tc)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
				local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
				aux.GCheckAdditional=nil
				if not mat then goto cancel end
				tc:SetMaterial(mat)
				Duel.ReleaseRitualMaterial(mat)
				local mat1=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
				if #mat1>0 then
					Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_RELEASE+REASON_MATERIAL)
				end
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
				tc:CompleteProcedure()
				ct=5-#mat1
			end
		end
		if ct>0 then Duel.SortDecktop(tp,tp,ct) end
	end
end