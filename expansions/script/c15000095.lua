local m=15000095
local cm=_G["c"..m]
cm.name="闪刀姬-飏霁"
function cm.initial_effect(c)
	c:SetSPSummonOnce(15000095)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.linklimit)
	c:RegisterEffect(e1)
	--copy effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.cpcon)
	e2:SetTarget(cm.cptg)
	e2:SetOperation(cm.cpop)
	c:RegisterEffect(e2)
end
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x1115)
end
function cm.cfilter(c)
	return c:GetSequence()<5
end
function cm.wfilter(c,code)
	return c:GetOriginalCode()==code
end
function cm.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.cpfilter(c)
	return c:IsSetCard(0x115) and (c:GetType()==TYPE_SPELL or c:IsType(TYPE_QUICKPLAY)) and c:IsAbleToDeck() and c:CheckActivateEffect(false,true,false)~=nil
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(cm.cpfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
	local ag=Duel.GetMatchingGroup(cm.wfilter,tp,LOCATION_GRAVE,0,g:GetFirst(),g:GetFirst():GetCode())
	Group.Merge(ag,g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,ag,ag:GetCount(),0,0)
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	if not te:GetHandler():IsRelateToEffect(e) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	Duel.BreakEffect()
	local ag=Duel.GetMatchingGroup(cm.wfilter,tp,LOCATION_GRAVE,0,te:GetHandler(),te:GetHandler():GetCode())
	Group.Merge(ag,Group.FromCards(te:GetHandler()))
	Duel.SendtoDeck(ag,nil,2,REASON_EFFECT)
end