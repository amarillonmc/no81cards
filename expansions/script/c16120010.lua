--龙素记号Xf
local m=16120010
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1) 
end
function cm.filter(c,e,tp,m)
	local b=0
	if not c:IsSetCard(0xcc6) then return end
	if c:IsType(TYPE_SYNCHRO) then 
			b=SUMMON_TYPE_SYNCHRO 
	elseif c:IsType(TYPE_FUSION) then 
			b=SUMMON_TYPE_FUSION
	elseif c:IsType(TYPE_XYZ) then 
			b=SUMMON_TYPE_XYZ
	elseif c:IsType(TYPE_RITUAL) then 
			b=TYPE_RITUAL
			if not c:IsLocation(LOCATION_HAND+LOCATION_DECK) then
				return false 
			end
	else b=0 
			return false
	end
	local num=c:GetLevel()+c:GetRank()
	return c:IsCanBeSpecialSummoned(e,b,tp,false,true) and (c:IsLevelAbove(1) or c:IsRankAbove(1)) and m:CheckWithSumEqual(cm.sumfun,num,1,m:GetCount()) and (c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function cm.sumfun(c)
	return c:GetLevel()+c:GetRank()+c:GetLink()
end
function cm.matfilter(c)
	return c:IsRace(RACE_FAIRY) and ((c:IsReleasable() and not c:IsLocation(LOCATION_GRAVE)) or (c:IsAbleToRemove() and c:IsLocation(LOCATION_GRAVE)))
end
function cm.gfilter(g,e,tp)
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,g)
end
function cm.tdfilter(c)
	return not c:IsLocation(LOCATION_EXTRA)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_HAND,0,nil)
		return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		local num=tc:GetLevel()+tc:GetRank()
		mg=mg:Filter(cm.matfilter,nil,tc)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		local mat=mg:SelectWithSumEqual(tp,cm.sumfun,num,1,99)
		tc:SetMaterial(mat)
		local mat1=mat:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		mat:Sub(mat1)
		Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT)
		Duel.Release(mat,REASON_EFFECT)
		Duel.BreakEffect()
		if tg:GetCount()>0 then
			local b=0
			if tc:IsType(TYPE_SYNCHRO) then 
				b=SUMMON_TYPE_SYNCHRO 
			elseif tc:IsType(TYPE_FUSION) then 
				b=SUMMON_TYPE_FUSION
			elseif tc:IsType(TYPE_XYZ) then 
				b=SUMMON_TYPE_XYZ
			elseif tc:IsType(TYPE_RITUAL) then 
				b=TYPE_RITUAL
			end
			Duel.SpecialSummon(tc,b,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
		tc:CompleteProcedure()
	end
end