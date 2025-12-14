--团团圆圆 蹦蹦团子
function c62501166.initial_effect(c)
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c62501166.splimit)
	c:RegisterEffect(e0)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c62501166.sprcon)
	e1:SetOperation(c62501166.sprop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c62501166.reptg)
	e2:SetValue(c62501166.repval)
	e2:SetOperation(c62501166.repop)
	c:RegisterEffect(e2)
	--tango remove
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c62501166.rmop)
	c:RegisterEffect(e3)
end
function c62501166.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or se:GetHandler():IsSetCard(0xea1)
end
function c62501166.sprfilter(c)
	return (c:IsLevel(1) or c:IsRank(1) or c:IsLink(1)) and c:IsReleasable(REASON_SPSUMMON)
end
function c62501166.sprcheck(g,p)
	return Duel.GetLocationCountFromEx(p,p,g,TYPE_SYNCHRO)>0 and g:FilterCount(Card.IsType,nil,TYPE_TUNER)==1
end
function c62501166.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c62501166.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c62501166.sprcheck,3,3,tp)
end
function c62501166.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c62501166.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,c62501166.sprcheck,false,3,3,tp)
	Duel.Release(sg,REASON_COST)
end
function c62501166.repfilter(c,tp)
	return c:IsSetCard(0xea1) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup() and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c62501166.tdfilter(c)
	return (c:IsOnField() or c:IsSetCard(0xea1) and c:IsFaceup()) and c:IsAbleToDeck()
end
function c62501166.gcheck(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)==1
end
function c62501166.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c62501166.tdfilter,tp,LOCATION_ONFIELD+LOCATION_REMOVED,LOCATION_ONFIELD,eg)
	if chk==0 then return g:CheckSubGroup(c62501166.gcheck,2,3) and eg:IsExists(c62501166.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c62501166.repval(e,c)
	return c62501166.repfilter(c,e:GetHandlerPlayer())
end
function c62501166.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c62501166.tdfilter,tp,LOCATION_ONFIELD+LOCATION_REMOVED,LOCATION_ONFIELD,eg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,c62501166.gcheck,false,2,3)
	Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
function c62501166.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
