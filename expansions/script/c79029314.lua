--罗德岛·狙击干员-酸糖
function c79029314.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,79029314)
	e1:SetCondition(c79029314.spcon1)
	e1:SetCost(c79029314.spcost1)
	e1:SetTarget(c79029314.sptg1)
	e1:SetOperation(c79029314.spop1)
	c:RegisterEffect(e1)	
	--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(79029314,2))
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,09029314)
	e2:SetCondition(c79029314.discon)
	e2:SetTarget(c79029314.distg)
	e2:SetOperation(c79029314.disop)
	c:RegisterEffect(e2)
end
function c79029314.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c79029314.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c79029314.spfilter1(c,e,tp)
	return c:IsSetCard(0xa900) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and Duel.IsExistingMatchingCard(c79029314.spfilter2,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,c,c:GetLevel(),e,tp) and c:IsLevelAbove(1)
end
function c79029314.spfilter2(c,lv,e,tp)
	return c:IsLevel(lv) and c:IsSetCard(0xa900) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelAbove(1)
end
function c79029314.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029314.spfilter1,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and x>=2 end
	local z=Duel.GetMatchingGroupCount(c79029314.spfilter1,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,e,tp)
	if x>z then x,z=z,x end
	Debug.Message("真让人跃跃欲试啊。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029314,0))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c79029314.spfilter1,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	local tc1=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c79029314.spfilter2,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,z-1,tc1,tc1:GetLevel(),e,tp)
	g1:Merge(g2)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,g1:GetCount(),0,0)
end
function c79029314.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<g:GetCount() or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local tc=g:GetFirst()
	while tc do
	Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2) 
	Duel.SpecialSummonComplete()  
	tc=g:GetNext()
	end
	Duel.Draw(1-tp,g:GetCount(),REASON_EFFECT+REASON_RULE)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c79029314.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c79029314.splimit(e,c)
	return not c:IsSetCard(0xa900)
end
function c79029314.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOriginalRace()==RACE_CYBERSE 
end
function c79029314.xfil(c,e,tp)
	local rk1=e:GetHandler():GetRank()
	local rk2=c:GetRank()
	if rk1==rk2 then return false end
	if rk1>rk2 then 
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.IsExistingMatchingCard(c79029314.xfil2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,rk1-rk2,nil,e,tp) and c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_XYZ)
	else 
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.IsExistingMatchingCard(c79029314.xfil2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,rk2-rk1,nil,e,tp) and c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_XYZ)
	end
end
function c79029314.xfil2(c,e,tp)
	return c:IsAbleToDeck() and c:IsSetCard(0xa900)
end
function c79029314.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029314.xfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	local tc=Duel.SelectMatchingCard(tp,c79029314.xfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	local rk1=e:GetHandler():GetRank()
	local rk2=tc:GetRank()   
	if rk1>rk2 then
	x=Duel.SelectMatchingCard(tp,c79029314.xfil2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,rk1-rk2,rk1-rk2,nil,e,tp)
	else
	x=Duel.SelectMatchingCard(tp,c79029314.xfil2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,rk2-rk1,rk2-rk1,nil,e,tp)
	end
	x:KeepAlive()
	e:SetLabelObject(x)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_EXTRA)
end
function c79029314.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local tc=Duel.GetFirstTarget()
		local mg=e:GetHandler():GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(tc,mg)
		end
	Duel.Overlay(tc,e:GetHandler())
	tc:SetMaterial(Group.FromCards(e:GetHandler()))
	Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	Debug.Message("跳吧！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029314,1))
end






