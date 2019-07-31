--假面驾驭·555-爆裂形态
function c9980659.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,c9980659.ffilter,c9980659.ffilter2,1,true,true)
	aux.AddContactFusionProcedure(c,c9980659.cfilter,LOCATION_ONFIELD,0,aux.tdcfop(c)):SetValue(1)
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980659.sumsuc)
	c:RegisterEffect(e8)
	--atk change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980659,4))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c9980659.atktg)
	e2:SetOperation(c9980659.atkop)
	c:RegisterEffect(e2)
	--destroy & damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9980659,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9980659)
	e3:SetCondition(c9980659.damcon)
	e3:SetTarget(c9980659.damtg)
	e3:SetOperation(c9980659.damop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9980659,2))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_MSET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,9980659)
	e5:SetCondition(c9980659.damcon2)
	e5:SetTarget(c9980659.damtg2)
	e5:SetOperation(c9980659.damop2)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SSET)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(9980659,2))
	e7:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_CHANGE_POS)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,9980659)
	e7:SetCondition(c9980659.damcon3)
	e7:SetTarget(c9980659.damtg3)
	e7:SetOperation(c9980659.damop3)
	c:RegisterEffect(e7)
end
function c9980659.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980659,1))
end 
function c9980659.ffilter(c)
	return c:IsFusionCode(9980450,9980642) and c:IsType(TYPE_MONSTER)
end
function c9980659.ffilter2(c)
	return c:IsFusionSetCard(0x9bcd,0x9bca) and c:IsType(TYPE_MONSTER)
end
function c9980659.cfilter(c)
	return (c:IsFusionCode(9980450,9980642) or c:IsFusionSetCard(0x9bcd,0x9bca) and c:IsType(TYPE_MONSTER))
		and c:IsAbleToDeckOrExtraAsCost()
end
function c9980659.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c9980659.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980659.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c9980659.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9980659.atkfilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetValue(c9980659.val)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c9980659.val(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then
		return math.ceil(dam/2)
	else return dam end
end
function c9980659.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c9980659.dfilter(c,e,sp)
	return c:GetSummonPlayer()==sp and (not e or c:IsRelateToEffect(e))
end
function c9980659.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c9980659.dfilter,1,nil,nil,1-tp) end
	local g=eg:Filter(c9980659.dfilter,nil,nil,1-tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c9980659.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c9980659.dfilter,nil,e,1-tp)
	if e:GetHandler():IsRelateToEffect(e) and g:GetCount()~=0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,1000,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980659,3))
	end
end
function c9980659.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and rp==1-tp
end
function c9980659.damtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c9980659.sfilter,1,nil) end
	local g=eg:Filter(c9980659.sfilter,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c9980659.damop2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c9980659.sfilter,nil,e)
	if e:GetHandler():IsRelateToEffect(e) and g:GetCount()~=0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,1000,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980659,3))
	end
end
function c9980659.damcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and rp==1-tp
end
function c9980659.sfilter(c,e)
	return c:IsFacedown() and (not e or c:IsRelateToEffect(e))
end
function c9980659.damtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c9980659.sfilter,1,nil) end
	local g=eg:Filter(c9980659.sfilter,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c9980659.damop3(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c9980659.sfilter,nil,e)
	if e:GetHandler():IsRelateToEffect(e) and g:GetCount()~=0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,1000,REASON_EFFECT)
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980659,3))
	end
end
