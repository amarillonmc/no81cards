--地 狱 恶 魔 古 老 的 别 西 卜
local m=43990011
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c43990011.tfilter,aux.FilterBoolFunction(Card.IsSetCard,0x45),1)
	c:EnableReviveLimit()
	--apply effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43990011,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c43990011.efftg)
	e2:SetOperation(c43990011.effop)
	c:RegisterEffect(e2)
	c43990011.SetCard_diyuemo=true   
	
end
function c43990011.tfilter(c)
	return c:IsCode(43990010)
end
function c43990011.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c.SetCard_diyuemo and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck())
	then return false end
	local te=c.onfield_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c43990011.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED,0)
	if chk==0 then return (not (g:GetCount()==1 and (g:GetFirst():IsCode(22348138) or g:GetFirst():IsCode(43990010))) and
	Duel.IsExistingMatchingCard(c43990011.efffilter,tp,LOCATION_REMOVED,0,1,nil,e,tp,eg,ep,ev,re,r,rp))
	or((g:GetCount()==1 and (g:GetFirst():IsCode(22348138) or g:GetFirst():IsCode(43990010))) and
	Duel.IsExistingMatchingCard(c43990011.efffilter,tp,LOCATION_REMOVED,0,1,g,e,tp,eg,ep,ev,re,r,rp))
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_MZONE)
end
function c43990011.effop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	if g:GetCount()==1 and (g:GetFirst():IsCode(22348138) or g:GetFirst():IsCode(43990010)) then
	local tg=Duel.SelectMatchingCard(tp,c43990011.efffilter,tp,LOCATION_REMOVED,0,1,1,g,e,tp)
	local tc=tg:GetFirst()
	local te=tc.onfield_effect
	local op=te:GetOperation()
	if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and op then op(e,tp,eg,ep,ev,re,r,rp) end
	else
	local tg=Duel.SelectMatchingCard(tp,c43990011.efffilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	local tc=tg:GetFirst()
	local te=tc.onfield_effect
	local op=te:GetOperation()
	if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end


