--大魔术师 阿瓦隆女士
function c22024370.initial_effect(c)
	c:SetSPSummonOnce(22024370)
	--spsummon hand
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c22024370.spcon1)
	e1:SetOperation(c22024370.spop1)
	c:RegisterEffect(e1)
	--spsummon grave
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c22024370.spcon2)
	e2:SetOperation(c22024370.spop2)
	c:RegisterEffect(e2)
	--spsummon deck
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_DECK)
	e3:SetCondition(c22024370.spcon3)
	e3:SetOperation(c22024370.spop3)
	c:RegisterEffect(e3)
	--Add counter
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9634146,0))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetTarget(c22024370.target)
	e4:SetOperation(c22024370.operation)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
c22024370.effect_with_avalon=true
function c22024370.spcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsCanRemoveCounter(tp,1,0,0xfee,3,REASON_COST)
end
function c22024370.spop1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,0,0xfee,3,REASON_COST)
end
function c22024370.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsCanRemoveCounter(tp,1,0,0xfee,6,REASON_COST)
end
function c22024370.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,0,0xfee,6,REASON_COST)
end
function c22024370.spcon3(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsCanRemoveCounter(tp,1,0,0xfee,12,REASON_COST)
end
function c22024370.spop3(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,0,0xfee,12,REASON_COST)
end
function c22024370.filter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0xfee,2)
end
function c22024370.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22024370.filter,tp,LOCATION_ONFIELD,0,1,nil) end
end
function c22024370.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22024370.filter,tp,LOCATION_ONFIELD,0,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0xfee,2)
		tc=g:GetNext()
	end
end
