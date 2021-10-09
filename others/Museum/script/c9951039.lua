--Beast-Ⅲ/L-「万欲应体」·Kama
function c9951039.initial_effect(c)
	 c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
 --immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c9951039.efilter)
	c:RegisterEffect(e2)
 --atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9951039.atkval)
	c:RegisterEffect(e1)
  --set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951039,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(c9951039.settg)
	e2:SetOperation(c9951039.setop)
	c:RegisterEffect(e2)
 --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951039.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951039.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9951039,0))
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951039,2))
end
function c9951039.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c9951039.atkfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_LINK+TYPE_XYZ)
end
function c9951039.atkval(e,c)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c9951039.atkfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	return g:GetSum(Card.GetLevel)*300
end
function c9951039.setfilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function c9951039.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and c9951039.setfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9951039.setfilter,tp,0,LOCATION_GRAVE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c9951039.setfilter,tp,0,LOCATION_GRAVE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c9951039.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1,true)
	end
Duel.Hint(HINT_SOUND,0,aux.Stringid(9951039,1))
end
