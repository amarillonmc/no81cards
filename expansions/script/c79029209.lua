--生于黑夜的反叛者
function c79029209.initial_effect(c)
	--sp
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029209+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(c79029209.sptg)
	e1:SetOperation(c79029209.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c79029209.tdcon)
	e2:SetOperation(c79029209.tdop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,79029207))
	e3:SetValue(c79029209.efilter)
	c:RegisterEffect(e3)
end 
function c79029209.spfil(c,e,tp)
	return c:IsCode(79029207) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,true)
end
function c79029209.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029209.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetMZoneCount(tp,c)>1 end
	local g=Duel.SelectMatchingCard(tp,c79029209.spfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
end
function c79029209.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local a1=Duel.CreateToken(tp,97383507)
	local a2=Duel.CreateToken(tp,12744567)
	local g=Group.FromCards(a1,a2)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetMZoneCount(tp,c)<2 then return false end
	Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	Duel.Overlay(tc,g)
	Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,true,true,POS_FACEUP_ATTACK)
	Debug.Message("看起来，这儿多了很多东西，也少了很多人。")
end
function c79029209.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():GetReasonEffect():GetHandler():IsCode(79029207) 
	and e:GetHandler():GetFlagEffect(79029209)==0
end
function c79029209.tdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then 
	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	Duel.ConfirmCards(tp,g)
	local tc=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_DECK,1,1,nil)
	Duel.SendtoDeck(tc,1-tp,0,REASON_EFFECT)
	Debug.Message("我数到三，你们还有投降的机会，三~")
	e:GetHandler():RegisterFlagEffect(79029209,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end 
end
function c79029209.efilter(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler()
end





