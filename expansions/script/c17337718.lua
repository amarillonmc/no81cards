--合辛的水门共斗
function c17337718.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--attack up-other
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c17337718.atkcon)
	e1:SetValue(c17337718.atkval)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,17337718)
	e2:SetCondition(c17337718.setcon)
	--e2:SetTarget(c17337718.settg)
	e2:SetOperation(c17337718.setop)
	c:RegisterEffect(e2)
	if not c17337718.global_check then
		c17337718.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetOperation(c17337718.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c17337718.cfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousSetCard(0x3f51) and c:IsPreviousPosition(POS_FACEUP)
end
function c17337718.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c17337718.cfilter,nil)
	if #g==0 then return end
	for tc in aux.Next(g) do
		Duel.RegisterFlagEffect(tc:GetPreviousControler(),17337718,RESET_PHASE+PHASE_END,0,1)
	end
end
function c17337718.atkcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),17337718)>0
end
function c17337718.atkval(e,c)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)*100
end
function c17337718.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c17337718.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c17337718.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end
