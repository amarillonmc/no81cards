--伏魔忍龙 魔军天武
function c40006906.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x2b),2)
	c:EnableReviveLimit()	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,40006906)
	e1:SetTarget(c40006906.targt)
	e1:SetOperation(c40006906.activate)
	c:RegisterEffect(e1)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40006906,0))
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON)
	e2:SetCountLimit(1)
	e2:SetCondition(c40006906.condition)
	e2:SetCost(c40006906.cost)
	e2:SetTarget(c40006906.target)
	e2:SetOperation(c40006906.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e4)
end
function c40006906.tfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x61) and c:IsFaceup()
end
function c40006906.targt(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c40006906.tfilter,tp,LOCATION_SZONE,0,1,c) and Duel.IsPlayerCanDraw(tp,1) end
	local g=Duel.GetMatchingGroup(c40006906.tfilter,tp,LOCATION_SZONE,0,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetCount())
end
function c40006906.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c40006906.tfilter,tp,0,LOCATION_SZONE,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
function c40006906.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c40006906.cfilter(c)
	return c:IsSetCard(0x61) and c:IsAbleToGraveAsCost()
end
function c40006906.cfilter2(c)
	return c:IsSetCard(0x2b) and c:IsAbleToGraveAsCost()
end
function c40006906.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40006906.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c40006906.cfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c40006906.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil) 
	local g=Duel.SelectMatchingCard(tp,c40006906.cfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil) 
	Duel.SendtoGrave(g,REASON_COST)
end
function c40006906.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function c40006906.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
end