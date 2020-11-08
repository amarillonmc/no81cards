--拉特兰·近卫干员-芳汀
function c79029332.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x4901),2,2)   
	--change damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c79029332.damcon)
	e1:SetOperation(c79029332.damop)
	c:RegisterEffect(e1) 
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,79029332)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c79029332.spcost)
	e2:SetTarget(c79029332.sptg)
	e2:SetOperation(c79029332.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(c79029332.spcon2)
	c:RegisterEffect(e3)
end
function c79029332.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c79029332.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Debug.Message("已经警告过各位了哦。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029332,0))
	--reflect damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_REFLECT_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetValue(aux.TRUE)
	Duel.RegisterEffect(e3,tp)
end
function c79029332.filter(c,e,tp,zone,zone2)
	return c:IsSetCard(0xa900) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp,zone2))
end
function c79029332.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c79029332.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone()
	local zone2=e:GetHandler():GetLinkedZone(1-tp)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0) and Duel.IsExistingMatchingCard(c79029332.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp,zone,zone2) end
	Debug.Message("欢迎，我在等各位。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029332,1))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029332.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp,zone,zone2)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)	 
end
function c79029332.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone()
	local zone2=e:GetHandler():GetLinkedZone(1-tp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local s1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
	local s2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp,zone2)
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,0)
	if s1 and s2 then op=Duel.SelectOption(tp,aux.Stringid(79029332,2),aux.Stringid(79029332,3))
	elseif s1 then op=Duel.SelectOption(tp,aux.Stringid(79029332,2))
	elseif s2 then op=Duel.SelectOption(tp,aux.Stringid(79029332,3))+1
	else return end
	if op==0 then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	else Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP,zone2) end
end
function c79029332.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroupCount()>0
end





