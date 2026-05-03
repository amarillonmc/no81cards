--龙装-身骋疾雷
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,16190330)
	--同调召唤
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_LIGHT),1)
	c:EnableReviveLimit()
	--种族视为雷族
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetRange(LOCATION_MZONE+LOCATION_REMOVED+LOCATION_GRAVE)
	e1:SetValue(RACE_THUNDER)
	c:RegisterEffect(e1)
	--特殊召唤    
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)    
end    
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.spfilter(c,e,tp,ec)
	return c:IsCode(16190330) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetMZoneCount(tp,ec)>0
end
function s.disfilter(c)
	return c:IsFaceup() and aux.NegateAnyFilter(c) and c:IsAbleToGrave()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(s.disfilter,tp,LOCATION_ONFIELD,0,nil)
    local g2=Duel.GetMatchingGroup(s.disfilter,tp,0,LOCATION_ONFIELD,nil) 
    g1:Merge(g2)
	if chk==0 then return g2:GetCount()>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g1,2,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp,e:GetHandler())
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
    	local g1=Duel.GetMatchingGroup(s.disfilter,tp,LOCATION_ONFIELD,0,nil)
    	local g2=Duel.GetMatchingGroup(s.disfilter,tp,0,LOCATION_ONFIELD,nil)  
        if g1:GetCount()>0 and g2:GetCount()>0 then
        	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
           	local sg1=g1:Select(tp,1,1,nil)
			Duel.HintSelection(sg1)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
           	local sg2=g2:Select(tp,1,1,nil)
			Duel.HintSelection(sg2)
            sg1:Merge(sg2)
           	local c=e:GetHandler()
           	for tc in aux.Next(sg1) do
				if tc:IsCanBeDisabledByEffect(e,false) then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetValue(RESET_TURN_SET)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e2)
					if tc:IsType(TYPE_TRAPMONSTER) then
						local e3=Effect.CreateEffect(c)
						e3:SetType(EFFECT_TYPE_SINGLE)
						e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
						e3:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e3)        
                    end    
                    Duel.AdjustInstantly()
					Duel.NegateRelatedChain(tc,RESET_TURN_SET)
					Duel.SendtoGrave(tc,REASON_EFFECT)
                end        
            end                         
        end
	end
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(s.spscon)
	e1:SetOperation(s.spsop)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	Duel.RegisterEffect(e1,tp)
end
function s.spsfilter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_THUNDER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spsfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function s.spsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spsfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end