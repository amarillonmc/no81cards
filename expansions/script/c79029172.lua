--猩红古堡
function c79029172.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029172,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(c79029172.ngcon)
	e1:SetOperation(c79029172.ngop)
	c:RegisterEffect(e1)  
	--Damage
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(79029172,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c79029172.dacon)
	e2:SetOperation(c79029172.daop)
	c:RegisterEffect(e2)
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval)
	e1:SetCondition(c79029172.incon)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.indoval)
	e2:SetCondition(c79029172.incon)
	c:RegisterEffect(e2)
end
function c79029172.ngcon(e,tp,eg,ep,ev,re,r,rp)
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER) 
	local tc=te:GetHandler()
	return rp==1-tp and p==tp and tc:IsType(TYPE_MONSTER) and tc:IsRace(RACE_FIEND) and tc:IsLevelAbove(10) and Duel.IsChainNegatable(ev) and e:GetHandler():GetFlagEffect(79029172)==0 
end
function c79029172.ngop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(79029172,0)) then 
	Duel.Hint(HINT_CARD,0,79029172)
	Duel.NegateEffect(ev)
	end
end
function c79029172.ckfil(c)
	if c:IsLocation(LOCATION_MZONE) then 
	return c:IsRace(RACE_FIEND) and c:IsLevel(10) and c:IsFaceup()
	elseif c:IsLocation(LOCATION_HAND) then 
	return c:IsRace(RACE_FIEND) and c:IsLevel(10) and c:IsPublic()  
	else return false end
end
function c79029172.dacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c79029172.ckfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and rp==1-tp
end
function c79029172.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,79029172)
	Duel.Damage(1-tp,300,REASON_EFFECT)
end
function c79029172.incon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end





