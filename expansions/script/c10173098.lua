--钢铁天使的威压
function c10173098.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10173098+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c10173098.condition)
	e1:SetTarget(c10173098.target)
	e1:SetOperation(c10173098.activate)
	c:RegisterEffect(e1)	
end
function c10173098.desfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:GetSummonLocation()==LOCATION_EXTRA 
end
function c10173098.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,nil)
end
function c10173098.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c10173098.desfilter,tp,0,LOCATION_MZONE,3,nil) or Duel.IsExistingTarget(Card.IsType,tp,0,LOCATION_ONFIELD,3,nil,TYPE_SPELL+TYPE_TRAP) end
	local g1=Duel.GetMatchingGroup(c10173098.desfilter,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg1=g1:Select(tp,1,1,nil)
	Duel.HintSelection(dg1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg2=Group.CreateGroup()
	if dg1:GetFirst():IsType(TYPE_MONSTER) then
	   dg2=Duel.SelectTarget(tp,c10173098.desfilter,tp,0,LOCATION_MZONE,1,1,dg1)
	else
	   dg2=Duel.SelectTarget(tp,Card.IsType,tp,0,LOCATION_MZONE,1,1,dg1,TYPE_SPELL+TYPE_TRAP)
	end
	dg2:Merge(dg1)
	Duel.ClearTargetCard()
	Duel.SetTargetCard(dg2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,dg2,1,0,0)
end
function c10173098.activate(e)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
	   Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end
