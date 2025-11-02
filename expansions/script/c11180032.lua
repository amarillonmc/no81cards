--幻殇·双子·光暗之龙
function c11180032.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,11180032+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(c11180032.sprcon)
	e0:SetTarget(c11180032.sprtg)
	e0:SetOperation(c11180032.sprop)
	c:RegisterEffect(e0)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	e2:SetValue(c11180032.tnval)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c11180032.damcon2)
	e3:SetOperation(c11180032.damop2)
	c:RegisterEffect(e3)
end
function c11180032.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function c11180032.damcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c11180032.cfilter,1,nil,1-tp)
end
function c11180032.damop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,11180032)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end
function c11180032.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end
function c11180032.sprfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3450,0x6450) and c:IsAbleToDeckAsCost()
end
function c11180032.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11180032.sprfilter,tp,LOCATION_REMOVED,0,2,nil)
end
function c11180032.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c11180032.sprfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,2,2,nil)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c11180032.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_SPSUMMON)
	g:DeleteGroup()
end