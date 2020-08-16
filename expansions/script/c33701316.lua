--散华—神性的终结
function c33701316.initial_effect(c)
	--ac
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33701316.tg)
	e1:SetOperation(c33701316.op)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_REPEAT)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c33701316.handcon)
	c:RegisterEffect(e2)
end
function c33701316.cdfil(c,code)
	return c:IsCode(code)
end
function c33701316.handcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local code1=0
	local tc1=g:GetFirst()
	while tc1 do
	code1=bit.bor(code1,tc1:GetCode())
	tc1=g:GetNext()
	end
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)   
	local code2=0
	local tc2=g1:GetFirst()
	while tc2 do
	code2=bit.bor(code2,tc2:GetCode())
	tc2=g1:GetNext()
	end 
	return code1==code2
end
function c33701316.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local code=g:GetCode()
	e:SetLabel(code)
end
function c33701316.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()   
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetRange(LOCATION_EXTRA+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetLabel(code)
	e0:SetOperation(c33701316.tiop2)
	c:RegisterEffect(e0) 
	--Disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_EXTRA+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetLabel(code)
	e2:SetTarget(c33701316.cntg)
	e2:SetCondition(c33701316.cncon1)
	c:RegisterEffect(e2) 
	local e3=e2:Clone()
	e3:SetCode(EFFECT_DISABLE_EFFECT)  
	c:RegisterEffect(e3) 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetRange(LOCATION_EXTRA+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED)
	e1:SetLabel(code)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(c33701316.cncon2)
	e1:SetTargetRange(0,1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e3)
end
function c33701316.tiop2(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	if not eg:IsExists(Card.IsCode,1,nil,code) then return end
	if not eg:GetFirst():GetSummonPlayer()==tp then return end
	e:GetHandler():RegisterFlagEffect(code,0,0,0)
end
function c33701316.cncon1(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	return e:GetHandler():GetFlagEffect(code)>=7
end
function c33701316.cntg(e,c)
	return c:GetSummonPlayer()~=e:GetHandlerPlayer()
end
function c33701316.cncon2(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	return e:GetHandler():GetFlagEffect(code)>=13
end












