--混沌No.30 终结之王水亚当
function c40008801.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ROCK),4,3)
	c:EnableReviveLimit()   
	--cannot diratk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e4)
	 --remove material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008801,1))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c40008801.rmcon)
	e1:SetTarget(c40008801.rmtg)
	e1:SetOperation(c40008801.rmop)
	c:RegisterEffect(e1)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008801,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c40008801.setcon1)
	e2:SetCost(c40008801.setcost)
  --  e2:SetTarget(c40008801.atktg)
	e2:SetOperation(c40008801.atkop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c40008801.setcon2)
	c:RegisterEffect(e3)
end
c40008801.xyz_number=30
function c40008801.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c40008801.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():GetOverlayCount()==0 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,4000)
	end
end
function c40008801.rmop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(40008801,2)) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	else
		Duel.Damage(tp,4000,REASON_EFFECT)
	end
end
function c40008801.setcon1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,40008801)
end
function c40008801.setcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,40008801)
end
function c40008801.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c40008801.atkfilter(c,e,tp)
	return c:IsControler(tp) and c:IsPosition(POS_FACEUP) and (not e or c:IsRelateToEffect(e))
end
function c40008801.atkop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		while sc do
			local preatk=sc:GetAttack()
			local predef=sc:GetDefense()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(-2000)
			sc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			sc:RegisterEffect(e2)
			if (preatk~=0 and predef~=0) and (sc:IsAttack(0) or sc:IsDefense(0)) then dg:AddCard(sc) end
			sc=g:GetNext()
		end
		Duel.Destroy(dg,REASON_EFFECT)
	end
end