--连接合战
function c98920737.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,98920737+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c98920737.condition)
	e1:SetTarget(c98920737.target)
	e1:SetOperation(c98920737.activate)
	c:RegisterEffect(e1)	
end
function c98920737.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return a and d and a:IsFaceup() and a:IsType(TYPE_LINK) and d:IsFaceup() and d:IsType(TYPE_LINK)
end
function c98920737.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c98920737.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c98920737.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=g:GetSum(Card.GetLink)
	if chk==0 then return ct>=4 and Duel.IsPlayerCanDraw(tp,math.floor(ct/4)) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c98920737.activate(e,tp,eg,ep,ev,re,r,rp)
	local sc=Duel.GetAttacker()
	if sc:IsControler(1-tp) then sc=Duel.GetAttackTarget() end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c98920737.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=g:GetSum(Card.GetLink)
	local ss=math.floor(ct/4)
	if Duel.Draw(tp,ss,REASON_EFFECT) then
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_UPDATE_ATTACK)
	   e1:SetReset(RESET_PHASE+PHASE_END)
	   e1:SetValue(ss*1000)
	   sc:RegisterEffect(e1)
	end	
end
function c98920737.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end