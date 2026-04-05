--森久保自动防卫
local s,id,o=GetID()
function s.initial_effect(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.cost)
	e2:SetCondition(s.con)
	e2:SetTarget(s.target)
	e2:SetOperation(s.prop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(s.reptg)
	e3:SetValue(s.repval)
	e3:SetOperation(s.repop)
	c:RegisterEffect(e3)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,2))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetValue(id)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(s.condition)
	e0:SetCost(s.cost0)
	c:RegisterEffect(e0)
	
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_CHANGE_POS)
	ge1:SetOperation(s.checkop)
	--Duel.RegisterEffect(ge1,0)
end


function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0x619) then
			if tc:IsFacedown() then
				local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_SZONE,0,nil,id)
				local ct=Duel.GetFieldGroupCount(tp,LOCATION_SZONE,0)
				local tc1=g:GetFirst()
				while tc1 do
					local e2=Effect.CreateEffect(tc)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_CANNOT_TRIGGER)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e2)
					tc1=g:GetNext()
				end
			end
			if tc:IsFaceup() then
				
			end
		end
		tc=eg:GetNext()
	end
	
end

function s.condition(e)
	return e:GetHandler():IsStatus(STATUS_SET_TURN) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end

function s.filter(c,e,tp)
	return c:IsSetCard(0x619) and c:IsFacedown()
end
function s.cost0(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g = Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
end
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	e:SetLabel(1)
	return true
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=re:GetHandler()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then 
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) 
		else
			return tc:IsRelateToEffect(re) and tc:IsCanBeEffectTarget(e)
		end
	end
	
	if e:GetLabel()==1 then
		e:SetLabel(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g = Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	end
	
	Duel.SetTargetCard(tc)
end
function s.prop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end


function s.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and c:IsSetCard(0x619)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(s.repfilter,1,c,tp) and c:IsDestructable(e)
		and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and c:IsAbleToHand() end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT+REASON_REPLACE)
end