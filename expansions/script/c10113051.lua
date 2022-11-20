--二选一
function c10113051.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10113051+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(TIMING_ATTACK,0x11e0)
	e1:SetTarget(c10113051.target)
	e1:SetOperation(c10113051.activate)
	c:RegisterEffect(e1)	
end
function c10113051.filter(c,tp)
	return c:IsFaceup() and c:GetLevel()>0 and Duel.IsExistingTarget(c10113051.filter2,tp,0,LOCATION_MZONE,1,c,c:GetLevel())
end
function c10113051.filter2(c,lv)
	return c:IsFaceup() and c:GetLevel()==lv
end
function c10113051.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c10113051.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g1=Duel.SelectMatchingCard(tp,c10113051.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	local g2=Duel.SelectMatchingCard(tp,c10113051.filter2,tp,0,LOCATION_MZONE,1,1,g1:GetFirst(),g1:GetFirst():GetLevel())
	g1:Merge(g2)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE)
end
function c10113051.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=2 then return end
	   Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	   local sg=g:Select(1-tp,1,1,nil)
	   Duel.HintSelection(sg)
	   Duel.SendtoGrave(sg,REASON_RULE)
end