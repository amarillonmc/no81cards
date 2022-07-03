--方舟骑士-凛冬
c29065536.named_with_Arknight=1
function c29065536.initial_effect(c)
	c:EnableCounterPermit(0x10ae)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,29065536+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c29065536.hspcon)
	e1:SetOperation(c29065536.hspop)
	c:RegisterEffect(e1)  
	--counter 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3026686,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,29065537)
	e2:SetTarget(c29065536.ctg)
	e2:SetOperation(c29065536.cop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	c29065536.summon_effect=e2
end
function c29065536.cfilter(c)
	return c:IsCode(29065521,29065523,29065536,15000129,29065537) and c:IsType(TYPE_MONSTER)
end
function c29065536.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>0 and Duel.IsCanRemoveCounter(tp,1,0,0x10ae,1,REASON_COST)
end
function c29065536.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,0,0x10ae,1,REASON_EFFECT)
end
function c29065536.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29065536.cfilter,tp,LOCATION_MZONE,0,1,nil) end 
end
function c29065536.cop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c29065536.cfilter,tp,LOCATION_MZONE,0,1,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x10ae,1)
		tc=g:GetNext()
	end
end