--夜刀神十香 月夜礼服
function c33400303.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c33400303.matfilter,1,1)
	--copy effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,33400303)
	e1:SetTarget(c33400303.cptg)
	e1:SetOperation(c33400303.cpop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MINIATURE_GARDEN_GIRL)
	e2:SetValue(1)
	e2:SetTarget(function(e,c)
		return c:IsSetCard(0x341)
	end)
	c:RegisterEffect(e2)
end
function c33400303.matfilter(c)
	return  c:IsLinkType(TYPE_MONSTER) and c:IsSetCard(0x5341)
end
function c33400303.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0x341) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end
function c33400303.cpfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL)  and c:IsSetCard(0x5341) and c:CheckActivateEffect(false,true,false)~=nil
end
function c33400303.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(c33400303.cpfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c33400303.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function c33400303.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	if not te:GetHandler():IsRelateToEffect(e) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
