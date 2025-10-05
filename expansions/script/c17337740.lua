--·夏乌拉·
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,17337760)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCost(s.spcost)
	c:RegisterEffect(e0)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(s.spcon)
	c:RegisterEffect(e2)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(1101)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e6:SetCountLimit(1,id)
	e6:SetCost(s.descost)
	e6:SetTarget(s.destg)
	e6:SetOperation(s.desop)
	c:RegisterEffect(e6)
	--draw
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,0))
	e7:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,id+1)
	e7:SetCost(s.cost)
	e7:SetTarget(s.tg)
	e7:SetOperation(s.op)
	c:RegisterEffect(e7)
end
function s.spcost(e,c,tp,st)
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function s.filter(c)
	return (c:IsSetCard(0x5f50) or c:IsCode(17337760)) and c:IsFaceup()
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=Duel.GetLP(tp)
	if chk==0 then return Duel.CheckLPCost(tp,lp-1000,true) end
	e:SetLabel(lp-1000)
	Duel.PayLPCost(tp,lp-1000,true)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsPlayerCanDraw(tp,1)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,0,1,nil)
	if chk==0 then return b1 or b2 end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsPlayerCanDraw(tp,1)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,0,nil)
	local b2=#g>0
	if not (b1 or b2) then return end
	local count=e:GetLabel()
	local d=math.floor(count/3000)
	for i=1,d do
		local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,0,nil)
		if b1 then Duel.Draw(tp,1,REASON_EFFECT) end
		if #g2>0 then 
			local sg=g2:RandomSelect(tp,1)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			g2:Sub(sg)
		end
	end	
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if #sg>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
end