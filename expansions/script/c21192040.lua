--幻想时间 梦中的企鹅
local m=21192040
local cm=_G["c"..m]
local setcard=0x3917
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_ATKCHANGE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
function cm.q(c)
	return c:IsSetCard(setcard) and c:IsAbleToRemove() and c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER~=0
end
function cm.w(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk ==0 then return Duel.IsExistingTarget(cm.q,tp,12,0,1,nil) and Duel.IsExistingTarget(cm.w,tp,0,12,1,nil) end
	Duel.Hint(3,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,cm.q,tp,12,0,1,1,nil)
	Duel.Hint(3,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,cm.w,tp,0,12,1,1,nil)	
	g1:Merge(g2)	
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)	
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.e(c,e,tp)
	return c:IsSetCard(setcard) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,4)>0
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.e,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.e,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(4,0)
	e1:SetTarget(cm.val)
	e1:SetValue(1000)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
end
function cm.val(e,c)
	return c:IsSetCard(setcard) and c:IsFaceup()
end