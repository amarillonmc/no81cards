--拟态武装 耳光
function c67200677.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c67200677.mfilter,1)
	c:EnableReviveLimit()
	--tohand2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200677,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c67200677.thtg2)
	e2:SetOperation(c67200677.thop2)
	c:RegisterEffect(e2) 
	if not c67200677.global_check then
		c67200677.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetCondition(c67200677.plcon)
		ge1:SetOperation(c67200677.checkop)
		Duel.RegisterEffect(ge1,0)
	end 
end
function c67200677.mfilter(c)
	return c:IsLinkSetCard(0x667b)
end
function c67200677.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp)
		and c:IsSetCard(0x667b) and c:IsSummonType(TYPE_LINK)
end
function c67200677.plcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200677.cfilter,1,nil,tp)
end
function c67200677.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),67200677,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
--
function c67200677.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c67200677.thop2(e,tp,eg,ep,ev,re,r,rp)
	local atk=Duel.GetFlagEffect(tp,67200677)*500
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsCode,67200677))
	e0:SetValue(atk)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp) 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(c67200677.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp) 
end
function c67200677.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end