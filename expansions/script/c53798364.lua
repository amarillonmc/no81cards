local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id+4)
	--Ritual Summon
	local e1=Auxiliary.AddRitualProcUltimate(c,s.ritual_filter,s.ritual_lv,"Greater",LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,nil,s.mat_filter,true,s.exop)
	e1:SetCountLimit(2,id)
	c:RegisterEffect(e1)
	--Set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(2,id+o)
	e2:SetCost(s.setcost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
function s.ritual_filter(c,e,tp,chk)
	return c:IsCode(id+4)
end
function s.ritual_lv(c)
	return 1
end
function s.mat_filter(c,e,tp)
	return c:IsLocation(LOCATION_HAND)
end
function s.spfilter(c,e,tp)
	return c:IsAttackAbove(1500) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.exop(e,tp,eg,ep,ev,re,r,rp,tc,mat)
	local loc=tc:GetPreviousLocation()
	local oloc=0
	if loc&LOCATION_HAND~=0 then oloc=LOCATION_HAND
	elseif loc&LOCATION_DECK~=0 then oloc=LOCATION_DECK
	elseif loc&LOCATION_GRAVE~=0 then oloc=LOCATION_GRAVE end
	if oloc==0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(s.spfilter,1-tp,oloc,0,nil,e,1-tp)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local sg=g:Select(1-tp,1,1,nil)
		local sc=sg:GetFirst()
		if sc and Duel.SpecialSummonStep(sc,0,1-tp,1-tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
		end
	end
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
	end
end