--传输机块 三头USB龙
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x14b),2,2)
	--copy effect
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_TODECK)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCountLimit(1,id)
	e0:SetTarget(s.cptg)
	e0:SetOperation(s.cpop)
	c:RegisterEffect(e0)
	--atk gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(s.atkcon)
	e1:SetTarget(s.atktg)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
	--immune
	local e2=e1:Clone()
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	--atk gain2
	local e3=e1:Clone()
	e3:SetCondition(s.atkcon2)
	e3:SetTarget(s.atktg2)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	--immune
	local e4=e3:Clone()
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(s.efilter2)
	c:RegisterEffect(e4)
end
function s.cpfilter(c)
	return (c:GetType()==TYPE_SPELL or c:IsType(TYPE_QUICKPLAY)) and c:IsSetCard(0x14b) and c:IsAbleToDeck() and c:CheckActivateEffect(false,true,false)~=nil
end
function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(s.cpfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
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
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	if not te:GetHandler():IsRelateToEffect(e) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	Duel.BreakEffect()
	Duel.SendtoDeck(te:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function s.atkcon(e)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function s.atktg(e,c)
	local g=e:GetHandler():GetMutualLinkedGroup()
	return c:IsSetCard(0x14b) and c:IsType(TYPE_LINK) and g:IsContains(c)
end
function s.efilter(e,te)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() then return false end
	local tc=te:GetOwner()
	return not te:IsActiveType(TYPE_MONSTER) or not te:GetActivateLocation()==LOCATION_MZONE or not tc or not tc:IsLinkState()
end
function s.atkcon2(e)
	return true
end
function s.atktg2(e,c)
	local g=e:GetHandler():GetMutualLinkedGroup()
	return c:IsSetCard(0x14b) and c:IsType(TYPE_LINK) and (#g<=0 or not g:IsContains(c))
end
function s.efilter2(e,te)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() then return false end
	local tc=te:GetOwner()
	return te:IsActiveType(TYPE_MONSTER) and te:GetActivateLocation()==LOCATION_MZONE and tc and tc:IsLinkState()
end
