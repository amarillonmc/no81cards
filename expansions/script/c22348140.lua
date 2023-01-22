--地 狱 恶 魔 正 义 的 杰 斯 提 斯
local m=22348140
local cm=_G["c"..m]
function cm.initial_effect(c)
	--特 殊 召 唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e1:SetCost(cm.spcost)
	e1:SetCondition(cm.spcon1)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE+TIMING_MAIN_END)
	e2:SetCondition(cm.spcon2)
	c:RegisterEffect(e2)
	--场 上 盖 放
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348140,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(cm.cost)
	e3:SetTarget(c22348140.settg)
	e3:SetOperation(c22348140.setop)
	c:RegisterEffect(e3)
	c22348140.onfield_effect=e3
	c22348140.SetCard_diyuemo=true
end
function cm.srfilter(c)
	return c:IsAbleToRemove() and c:IsSetCard(0x45) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsEnvironment(94585852)
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(94585852)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,600) end
	Duel.PayLPCost(tp,600)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		or Duel.IsExistingMatchingCard(cm.srfilter,tp,LOCATION_MZONE,0,1,nil))
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetHandler():GetFlagEffect(m)==0
		and Duel.IsExistingMatchingCard(cm.srfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,nil) end
	e:GetHandler():RegisterFlagEffect(m,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.srfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if not c:IsRelateToEffect(e) or g:GetCount()<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	local tg=Duel.SelectMatchingCard(tp,cm.srfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,2,nil)
	if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)==2
	and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_REMOVED)) then
		Duel.BreakEffect()
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	else
	local g1=Duel.SelectMatchingCard(tp,cm.srfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,cm.srfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,g1)
	local tg=Group.__add(g1,g2)
	if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)==2
	and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_REMOVED)) then
		Duel.BreakEffect()
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c22348140.filter(c,chk)
	return c:IsSetCard(0x45) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(chk)
end
function c22348140.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348140.filter,tp,LOCATION_REMOVED,0,1,nil,true) end
end
function c22348140.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c22348140.filter,tp,LOCATION_REMOVED,0,1,1,nil,false)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end