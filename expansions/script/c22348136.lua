--地 狱 恶 魔 疲 惫 的 潘 德 莫 妮 卡
local m=22348136
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
	--加 速 超 量
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348136,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(cm.cost)
	e3:SetTarget(c22348136.xyztg)
	e3:SetOperation(c22348136.xyzop)
	c:RegisterEffect(e3)
	c22348136.onfield_effect=e3
	c22348136.SetCard_diyuemo=true
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
function c22348136.xyzfilter(c)
	return c:IsXyzSummonable(nil)
end
function c22348136.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348136.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22348136.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22348136.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
end

