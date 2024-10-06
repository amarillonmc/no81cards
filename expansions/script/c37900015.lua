--幽人的庭师
function c37900015.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),7,2,c37900015.ovfilter,aux.Stringid(37900015,0),2,c37900015.xyzop)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c37900015.ind2)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(c37900015.ind1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c37900015.cost)
	e3:SetTarget(c37900015.tg)
	e3:SetOperation(c37900015.op)
	c:RegisterEffect(e3)
end
function c37900015.ovfilter(c)
	return c:IsFaceup() and c:IsCode(37900095)
end
function c37900015.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,37900015)==0 end
	Duel.RegisterFlagEffect(tp,37900015,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c37900015.ind1(e,c)
	local def1=e:GetHandler():GetDefense()
	return c:GetDefense()>def1 and c:IsFaceup()
end
function c37900015.ind2(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetHandler():GetBaseDefense()<e:GetHandler():GetDefense()
end
function c37900015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c37900015.q(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsPosition(POS_FACEUP_DEFENSE) and c:IsCanChangePosition()
end
function c37900015.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c37900015.q,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c37900015.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c37900015.q,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if g:GetCount()>0 then
		if Duel.ChangePosition(g,POS_FACEUP_ATTACK)>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_BATTLE_START)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCondition(c37900015.condition)
		e3:SetTarget(c37900015.target)
		e3:SetOperation(c37900015.thop)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
		end
	end
end
function c37900015.cfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsCode(89631139)
end
function c37900015.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:GetDefense()>bc:GetAttack() or (not bc:IsType(TYPE_LINK) and c:GetDefense()>bc:GetDefense())
end
function c37900015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,bc,1,1-tp,LOCATION_MZONE)
end
function c37900015.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc:IsRelateToBattle(e) then 
		if Duel.SendtoDeck(bc,nil,2,REASON_EFFECT)>0 then
		local atk=bc:GetBaseAttack()
			if atk>0 then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
			end
		end
	end	
end