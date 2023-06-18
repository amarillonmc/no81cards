--天璀司的光轮
local m=82209091
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_ACTIVATE)  
	e0:SetCode(EVENT_FREE_CHAIN)  
	e0:SetHintTiming(TIMING_REMOVE+TIMING_END_PHASE)  
	c:RegisterEffect(e0)  
	--special summon limit  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(m)  
	e1:SetRange(LOCATION_SZONE)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetTargetRange(1,0)  
	c:RegisterEffect(e1)  
	--Activate  
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m)
	e2:SetHintTiming(TIMING_REMOVE+TIMING_END_PHASE)  
	e2:SetTarget(cm.sptg)  
	e2:SetOperation(cm.spop)  
	c:RegisterEffect(e2)  
end
function cm.filter(c,e,tp)  
	return c:IsFaceup() and c:IsSetCard(0x9298) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.filter2(c,e,tp)  
	return c:IsFaceup() and c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.synchrofilter(c,tuner,nontuner)
	local mg=Group.FromCards(tuner,nontuner)
	return c:IsRace(RACE_MACHINE) and c:IsSynchroSummonable(nil,mg)  
end  
function cm.mfilter1(c,mg,exg)  
	return c:IsType(TYPE_TUNER) and mg:IsExists(cm.mfilter2,1,c,c,exg) and mg:IsExists(cm.mfilter2,1,nil,c,exg) 
end  
function cm.mfilter2(c,tuner,exg)  
	return not c:IsType(TYPE_TUNER) and exg:IsExists(cm.synchrofilter,1,nil,tuner,c)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and chkc:IsFaceup() and chkc:IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	local mg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_REMOVED,0,nil,e,tp)  
	local exg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_EXTRA,0,nil)  
	if chk==0 then return mg:IsExists(cm.mfilter1,1,nil,mg,exg) and Duel.IsPlayerCanSpecialSummonCount(tp,2) and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local sg1=mg:FilterSelect(tp,cm.mfilter1,1,1,nil,mg,exg)  
	local tuner=sg1:GetFirst()  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local sg2=mg:FilterSelect(tp,cm.mfilter2,1,1,nil,tuner,exg)  
	sg1:Merge(sg2)  
	Duel.SetTargetCard(sg1)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,2,0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(cm.filter2,nil,e,tp)  
		if g:GetCount()==2 then
			local tuner
			local nontuner
			local tc=g:GetFirst()  
			while tc do  
				if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then  
					local e1=Effect.CreateEffect(c)  
					e1:SetType(EFFECT_TYPE_SINGLE)  
					e1:SetCode(EFFECT_DISABLE)  
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
					tc:RegisterEffect(e1)  
					local e2=e1:Clone()  
					e2:SetCode(EFFECT_DISABLE_EFFECT)  
					tc:RegisterEffect(e2)
					if tc:IsType(TYPE_TUNER) then
						tuner=tc
					else
						nontuner=tc
					end
				end
				tc=g:GetNext()  
			end  
			Duel.SpecialSummonComplete()  
			local sg=Duel.GetMatchingGroup(cm.synchrofilter,tp,LOCATION_EXTRA,0,nil,tuner,nontuner)  
			if sg:GetCount()>0 then  
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
				local sc=sg:Select(tp,1,1,nil):GetFirst()  
				Duel.SynchroSummon(tp,sc,nil,Group.FromCards(tuner,nontuner))  
			end 
		end
	end
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(cm.splimit)  
	e1:SetReset(RESET_PHASE+PHASE_END,2)   
	Duel.RegisterEffect(e1,tp)  
end  
function cm.splimit(e,c)  
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_SYNCHRO)
end  