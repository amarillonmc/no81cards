local m=15005036
local cm=_G["c"..m]
cm.name="羽袖一触·陵薮层岩"
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
function cm.cfilter0(c)
	return c:IsCode(15005037) and c:IsFaceup()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.cfilter0,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsPlayerCanSpecialSummonMonster(tp,15005037,0,TYPES_TOKEN_MONSTER,1000,1000,4,RACE_ROCK,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,15005037,0,TYPES_TOKEN_MONSTER,1000,1000,4,RACE_ROCK,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,15005037)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
		--extra summon
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(m,1))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e2:SetAbsoluteRange(tp,LOCATION_HAND+LOCATION_MZONE,0)
		e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9f31))
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e2,true)
	end
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsCanAddCounter(0x1f31,1) and rp==e:GetLabel() then
		c:AddCounter(0x1f31,1,REASON_EFFECT)
	end
end
function cm.actfilter(c,e)
	return c:IsCode(15005037) and c:IsFaceup() --and c==e:GetLabelObject()
end
function cm.ctop1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local g=Duel.GetMatchingGroup(cm.actfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	Duel.RaiseEvent(g,EVENT_CUSTOM+15005037,e,0,tp,0,0)
	--Duel.RaiseEvent(e:GetLabelObject(),EVENT_CUSTOM+15005037,e,0,0,0,0)
	--local tc=g:GetFirst()
	--while tc do
	--  Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+15005037,e,0,0,0,0)
	--  tc=g:GetNext()
	--end
end
function cm.eftg(e,c)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end