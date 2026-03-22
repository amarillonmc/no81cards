local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,17390000)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,id+1)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end

function s.desfilter(c)
	return c:IsSetCard(0x5f51)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	if chk==0 then return g:IsExists(Card.IsCode,1,nil,17389985) 
		and Duel.IsExistingMatchingCard(function(c,e,tp) return c:IsCode(17390000) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) end,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	if not g:IsExists(Card.IsCode,1,nil,17389985) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local cg=g:Filter(Card.IsCode,nil,17389985)
	local tg=g:SelectSubGroup(tp,function(sg) return sg:IsExists(Card.IsCode,1,nil,17389985) end,false,1,#g)
	if tg and #tg>0 then
		for tc in aux.Next(tg) do
			if tc:IsFacedown() or tc:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,tc) end
		end
		if Duel.Destroy(tg,REASON_EFFECT)>0 then
			local og=Duel.GetOperatedGroup()
			local tc=Duel.GetFirstMatchingCard(function(c,e,tp) return c:IsCode(17390000) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) end,tp,LOCATION_EXTRA,0,nil,e,tp)
			if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
				tc:CompleteProcedure()
				og:KeepAlive()
				local matg=og:Filter(Card.IsLocation,nil,LOCATION_GRAVE+LOCATION_REMOVED)
				if #matg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
					Duel.Overlay(tc,matg)
				end
			end
		end
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetOperation(s.delayed_set)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.delayed_set(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	e:Reset()
	local tc=Duel.GetFirstMatchingCard(function(c) return c:IsCode(id) and c:IsSSetable() end,tp,LOCATION_GRAVE,0,nil)
	if tc then
		Duel.SSet(tp,tc)
	end
end