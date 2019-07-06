--虚毒SHROUD
if not pcall(function() require("expansions/script/c33700701") end) then require("script/c33700701") end
local m=33700706
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsve.NormalSummonFunction(c,4)  
	rsve.BattleFunction(c,2500)
	rsve.DirectAttackFunction(c,5)
	--tg
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_COUNTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
end
function cm.tgfilter(c)
	local ct=c:GetCounter(0x144b)
	return ct>0 and c:IsCanRemoveCounter(tp,0x144b,ct,REASON_EFFECT) and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(Card.IsFaceup,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and cm.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local ct=tc:GetCounter(0x144b)
	if ct>0 and tc:IsCanRemoveCounter(tp,0x144b,ct,REASON_EFFECT) and tc:RemoveCounter(tp,0x144b,ct,REASON_EFFECT) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
	   rsve.addcounter(tp,ct)
	end
end