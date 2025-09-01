--慈在天·云天士
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,2,s.lcheck)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.setcon)
	e1:SetCost(s.setcost)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
function s.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_PENDULUM)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return rg:FilterCount(Card.IsAbleToRemoveAsCost,nil)==3 end
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function s.setfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc37) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1) and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_EXTRA,0,2,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) or not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g1=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_EXTRA,0,2,2,nil)
	if #g1<2 then return end
	local tc1=g1:GetFirst()
	local tc2=g1:GetNext()
	if Duel.MoveToField(tc1,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
		if Duel.MoveToField(tc2,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
			tc2:SetStatus(STATUS_EFFECT_ENABLED,true)
		end
		tc1:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
end
function s.remfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.remfilter,1,nil,tp)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,0))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetCountLimit(1,id+1000)
		e1:SetValue(s.pendvalue)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.pendvalue(e,c)
	return c:IsSetCard(0xc37) or c:IsAttribute(ATTRIBUTE_WIND)
end
