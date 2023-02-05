--地 狱 恶 魔 的 科 研 工 作
local m=22348170
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22348170+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22348170.target)
	e1:SetOperation(c22348170.activate)
	c:RegisterEffect(e1)
	--apply effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348170,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,22349170)
	e2:SetCondition(c22348170.effcon)
	e2:SetTarget(c22348170.efftg)
	e2:SetOperation(c22348170.effop)
	c:RegisterEffect(e2)
	c22348170.SetCard_diyuemo=true   
end
function c22348170.cpfilter(c)
	return c.SetCard_diyuemo and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(22348170) and c:IsAbleToDeck() and c:CheckActivateEffect(false,true,false)~=nil
end
function c22348170.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(c22348170.cpfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c22348170.cpfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c22348170.activate(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	if not te:GetHandler():IsRelateToEffect(e) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	Duel.BreakEffect()
	Duel.SendtoDeck(te:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function c22348170.effcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler().SetCard_diyuemo
end
function c22348170.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c.SetCard_diyuemo and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove())
	then return false end
	local te=c.onfield_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0)
end
function c22348170.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if chk==0 then return (not (g:GetCount()==1 and g:GetFirst():IsCode(22348136)) and
	Duel.IsExistingMatchingCard(c22348170.efffilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,nil,e,tp,eg,ep,ev,re,r,rp))
	or((g:GetCount()==1 and g:GetFirst():IsCode(22348136)) and
	Duel.IsExistingMatchingCard(c22348170.efffilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,g,e,tp,eg,ep,ev,re,r,rp))
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_MZONE)
end
function c22348170.effop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if g:GetCount()==1 and g:GetFirst():IsCode(22348136) then
	local tg=Duel.SelectMatchingCard(tp,c22348170.efffilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,1,g,e,tp)
	local tc=tg:GetFirst()
	local te=tc.onfield_effect
	local op=te:GetOperation()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and op then op(e,tp,eg,ep,ev,re,r,rp) end
	else
	local tg=Duel.SelectMatchingCard(tp,c22348170.efffilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=tg:GetFirst()
	local te=tc.onfield_effect
	local op=te:GetOperation()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end

