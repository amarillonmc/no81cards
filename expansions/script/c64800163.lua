--燃煤补给
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x541a) and not c:IsCode(64800150)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,64800150) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,64800150) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
		local g1=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,64800150)   
		local g2=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)  
		g1:Merge(g2)
		if g1:GetCount()==2 then
			Duel.SendtoExtraP(g1,tp,REASON_EFFECT)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e2:SetTargetRange(1,0)
			e2:SetTarget(s.splimit)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function s.splimit(e,c,tp,sumtp,sumpos)
	return c:IsSetCard(0x541a) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM 
end
