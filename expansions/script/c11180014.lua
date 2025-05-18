-- 龙之圣域
local s, id = GetID()

function s.initial_effect(c)
	-- Field Spell  
	-- ① On activation effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(s.acttg)
	e2:SetOperation(s.actop)
	c:RegisterEffect(e2)
	
	-- ② Steal control effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,id+100,EFFECT_COUNT_CODE_OATH)
	e3:SetCost(s.ctcost)
	e3:SetTarget(s.cttg)
	e3:SetOperation(s.ctop)
	c:RegisterEffect(e3)
	

end

-- ① Activation filter
function s.tgfilter(c)
	return (c:IsSetCard(0x3450) or c:IsSetCard(0x6450)) and (c:IsAbleToGrave() or c:IsAbleToRemove())
end

-- ① Activation target
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end

-- ① Activation operation
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		local op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
		if op==0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		else
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
		-- Skip battle phase
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END,1)
		Duel.RegisterEffect(e1,tp)
	end
end


-- ② Control change cost
function s.fit11(c)
	return c:IsAbleToGraveAsCost() or c:IsAbleToRemoveAsCost()
end
function s.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.fit11,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,s.fit11,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler()):GetFirst()
	if tc:IsAbleToGraveAsCost() and (not tc:IsAbleToRemoveAsCost() or Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))==0) then
		Duel.SendtoGrave(g,REASON_COST)
	else
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end

-- ② Control change target
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end

-- ② Control change operation
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.GetControl(g,tp,PHASE_END,1)
	end
end

-- ③ Banish condition

