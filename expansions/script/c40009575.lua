--焰之巫女的祈祷
if not pcall(function() require("expansions/script/c40009561") end) then require("script/c40009561") end
local m , cm = rscf.DefineCard(40009575)
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_GRAVE)  
	e3:SetCost(cm.spcost)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.cfilter(c)
	return c:IsSetCard(0x6f1b) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk == 0 then return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg = Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE,0,1,1,c)
	rg:AddCard(c)
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
end
function cm.spfilter(c,e,tp)
	local pos = c:GetPreviousPosition()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler() == tp and c:GetPreviousRaceOnField() & RACE_DRAGON ~= 0 and c:GetPreviousTypeOnField() & TYPE_RITUAL ~= 0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,pos) 
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	local sg = eg:Filter(cm.spfilter,nil,e,tp)
	local ft = Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk == 0 then return #sg > 0 and ft > 0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,ft,0,0)
	Duel.SetTargetCard(eg)
end
function cm.spop(e,tp)
	local tg = Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ft = Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sg = tg:Filter(cm.spfilter,nil,e,tp)
	if #sg <= 0 or ft <= 0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft = 1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2 = sg:Select(tp,ft,ft,nil)
	Duel.HintSelection(sg2)
	for tc in aux.Next(sg2) do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,tc:GetPreviousPosition())
	end
	Duel.SpecialSummonComplete()
end
function cm.exfilter0(c)
	return c:IsSetCard(0x6f1b) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function cm.filter(c,e,tp)
	return c:IsRace(RACE_DRAGON)
end
function cm.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 and c:IsCode(40009579) then
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
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local sg=Duel.GetMatchingGroup(cm.exfilter0,tp,LOCATION_DECK,0,nil)
		return Duel.IsExistingMatchingCard(cm.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,cm.filter,e,tp,mg,sg,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local sg=Duel.GetMatchingGroup(cm.exfilter0,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,cm.filter,e,tp,mg,sg,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if sg and tc:IsCode(40009579) then
			mg:Merge(sg)
		end
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
		local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
		mat:Sub(mat2)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
