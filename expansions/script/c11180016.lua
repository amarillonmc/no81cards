-- 龙血共振
local s, id = GetID()

function s.initial_effect(c)
	-- Add archetype
	
	-- ① Dual effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end

-- Cost filter
function s.costfilter(c)
	return (c:IsAbleToGraveAsCost() or c:IsAbleToRemoveAsCost()) and not c:IsCode(id)
end

-- ① Cost
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil):GetFirst()
		local op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
		e:SetLabel(op)
		if tc:IsAbleToGraveAsCost() and (not tc:IsAbleToRemoveAsCost() or Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))==0) then
			Duel.SendtoGrave(tc,REASON_COST)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_COST)
		end
		e:SetLabelObject(tc)
end

-- ① Target
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	if e:GetLabel()==0 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		local tc=e:GetLabelObject()
		if tc:IsType(TYPE_MONSTER)  then
			Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
		elseif tc:IsType(TYPE_SPELL) then
			Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
		elseif tc:IsType(TYPE_TRAP) then
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		end
	end
end

-- Search filter
function s.thfilter(c)
	return c:IsSetCard(0x3450) or c:IsSetCard(0x6450) -- Dragonborn/Phantom Grief
end

-- ① Operation
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local c=e:GetHandler()
	
	-- Effect 1: Search
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			-- Restriction
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetTarget(s.sumlimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			Duel.RegisterEffect(e2,tp)
		end
	-- Effect 2: Variable effect
	else
		local costcard=e:GetLabelObject()
		if costcard:IsType(TYPE_MONSTER) then
			Duel.Damage(1-tp,1000,REASON_EFFECT)
		elseif costcard:IsType(TYPE_SPELL) then
			Duel.Recover(tp,1000,REASON_EFFECT)
		elseif costcard:IsType(TYPE_TRAP) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

-- Summon restriction
function s.sumlimit(e,c)
	return c:IsRace(RACE_DRAGON) and not (c:IsSetCard(0x3450) or c:IsSetCard(0x6450))
end
