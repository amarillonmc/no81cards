--电子界思考者@火灵天星
function c98920619.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c98920619.mfilter,2)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920619,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,98920619)
	e1:SetCondition(c98920619.condition)
	e1:SetTarget(c98920619.target)
	e1:SetOperation(c98920619.operation)
	c:RegisterEffect(e1)   
end
function c98920619.mfilter(c)
	return c:IsAttack(2300) and c:IsLinkRace(RACE_CYBERSE)
end
function c98920619.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c98920619.filter(c,e,tp)
	return c:IsSetCard(0x135) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
function c98920619.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(c98920619.filter,tp,0x13,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SetChainLimit(c98920619.chlimit)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c98920619.chlimit(e,ep,tp)
	return tp==ep
end
function c98920619.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
	local n=Duel.Destroy(g,REASON_EFFECT)
	if n~=0 then
		local tg=Duel.GetMatchingGroup(c98920619.filter,tp,0x13,0,nil,e,tp)
		local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ct<0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
		ct=math.min(ct,n)
		if ct>0 and tg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=tg:SelectSubGroup(tp,aux.dabcheck,false,1,ct)
			if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then
				if Duel.IsExistingMatchingCard(c98920619.lkfilter,tp,LOCATION_EXTRA,0,1,nil,c) and Duel.SelectYesNo(tp,aux.Stringid(98920619,2)) then
					Duel.BreakEffect()
					local g=Duel.GetMatchingGroup(c98920619.lkfilter,tp,LOCATION_EXTRA,0,nil,nil,c)
					if g:GetCount()>0 then
					   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					   local sg=g:Select(tp,1,1,nil)
					   Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
					end
				end
			end
		end
	end
end
function c98920619.lkfilter(c,lc)
	return c:IsCode(11738489) and c:IsLinkSummonable(nil,lc)
end