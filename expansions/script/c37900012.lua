--红魔馆门番·华人小姑娘
function c37900012.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),7,2,c37900012.ovfilter,aux.Stringid(37900012,1),2,c37900012.xyzop)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(2)
	e1:SetValue(c37900012.valcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetValue(c37900012.atlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c37900012.tglimit)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_DECKDES)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c37900012.cost)
	e4:SetTarget(c37900012.tg)
	e4:SetOperation(c37900012.op)
	c:RegisterEffect(e4)
end
function c37900012.ovfilter(c)
	return c:IsFaceup() and c:IsCode(37900097)
end
function c37900012.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,37900012)==0 end
	Duel.RegisterFlagEffect(tp,37900012,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c37900012.valcon(e,re,r,rp)
	return r & (REASON_BATTLE + REASON_EFFECT) ~=0
end
function c37900012.atlimit(e,c)
	return c~=e:GetHandler()
end
function c37900012.tglimit(e,c)
	return c~=e:GetHandler()
end
function c37900012.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c37900012.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),1-tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_DECK)
end
function c37900012.t(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c37900012.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if g:GetCount()>0 then
	local ct=Duel.Destroy(g,REASON_EFFECT)
	local sg=Duel.GetMatchingGroup(c37900012.t,tp,0,LOCATION_DECK,nil,e,tp)
		if ct>0 and sg:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(37900012,0)) then
		Duel.BreakEffect()
		local ct2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		if ct>ct2 then ct=ct2 end
		if ct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local gg=Duel.SelectMatchingCard(1-tp,c37900012.t,tp,0,LOCATION_DECK,ct,ct,nil,e,tp)
			if Duel.SpecialSummon(gg,0,1-tp,1-tp,false,false,POS_FACEUP_ATTACK)>0 then
			local tc=gg:GetFirst()
			while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			tc=gg:GetNext()
			end
			end
		end
	end
end