--FLUFT-OF-POROS
xpcall(function() require("expansions/script/c16199990") end,function() require("script/c16199990") end)
local m,cm=rk.set(16101177,"PORO")
function cm.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1) 
end
function cm.filter(c,e,tp,m)
	local b=0
	if not rk.check(c,"PORO") then return end
	if c:IsType(TYPE_SYNCHRO) then b=SUMMON_TYPE_SYNCHRO 
	elseif c:IsType(TYPE_FUSION) then b=SUMMON_TYPE_FUSION
	elseif c:IsType(TYPE_XYZ) then b=SUMMON_TYPE_XYZ
	elseif c:IsType(TYPE_RITUAL) then b=TYPE_RITUAL
	else b=0 end
	m=m:Filter(cm.matfilter,nil,c)
	local num=c:GetLevel()+c:GetRank()
	return c:IsCanBeSpecialSummoned(e,b,tp,true,true) and (c:IsLevelAbove(1) or c:IsRankAbove(1)) and m:CheckWithSumEqual(cm.sumfun,num,1,99)
end
function cm.sumfun(c)
	return c:GetLevel()
end
function cm.matfilter(c,mc)
	if mc==nil then return true end
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.tdfilter(c)
	return not c:IsLocation(LOCATION_EXTRA)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
		return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		local num=tc:GetLevel()+tc:GetRank()
		mg=mg:Filter(cm.matfilter,nil,tc)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		local mat=mg:SelectWithSumEqual(tp,cm.sumfun,num,1,99)
		Duel.SendtoGrave(mat,REASON_EFFECT)
		Duel.BreakEffect()
		local b=0
		if tc:IsType(TYPE_SYNCHRO) then b=SUMMON_TYPE_SYNCHRO 
		elseif tc:IsType(TYPE_FUSION) then b=SUMMON_TYPE_FUSION
		elseif tc:IsType(TYPE_XYZ) then b=SUMMON_TYPE_XYZ
		elseif tc:IsType(TYPE_RITUAL) then b=TYPE_RITUAL
		else b=0 end
		Duel.SpecialSummon(tc,b,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end