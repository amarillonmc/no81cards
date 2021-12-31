--巡星 北极星
local m=33701516
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cm.wincon)
	e3:SetOperation(cm.winop)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		cm[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.spcfilter(c,tp)
	return c:IsCode(33701507) and c:IsCanRemoveCounter(tp,0x9440,1,REASON_COST)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.spcfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	local ct=0
	for tc in aux.Next(g) do
		ct=ct+tc:GetCounter(0x9440)
	end
	return ct>=5 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.spcfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	if #g==1 then
		g:GetFirst():RemoveCounter(tp,0x9440,5,REASON_COST)
	else
		for i=1,5 do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		local tg=Duel.SelectMatchingCard(tp,cm.spcfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
		tg:GetFirst():RemoveCounter(tp,0x9440,1,REASON_COST)
		end
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=0
	local n=cm[ep]
	while n do
		if (n%2)==1 then
			ct=ct+1
		end
		n=n>>1
	end
	return ct>=7
end
function cm.winop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetSummonPlayer()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9440))
	e1:SetValue(8000)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9440))
	e3:SetValue(cm.efilter)
	Duel.RegisterEffect(e3,tp)
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if tc:IsLevelAbove(1) and tc:IsSetCard(0x9440) then
		cm[ep]=bit.bor(cm[ep],0x1<<tc:GetLevel())
	end
end
