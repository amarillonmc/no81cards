--小舰娘-小企业
function c25800031.initial_effect(c)
	--public
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25800031,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c25800031.spcon)
	e1:SetOperation(c25800031.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25800031,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_DECK)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetOperation(c25800031.lpop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(25800031,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_HAND)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCountLimit(1,25800031)
	e3:SetCondition(c25800031.thcon)
	e3:SetTarget(c25800031.sptg)
	e3:SetOperation(c25800031.spop)
	c:RegisterEffect(e3)
end
function c25800031.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPublic()
end
function c25800031.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e)  then return end
	local fid=c:GetFieldID()
	c:RegisterFlagEffect(25800031,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,66)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
-----2
function c25800031.cfilter(c,tp)
	return  c:GetControler()==1-tp and c:IsPreviousLocation(LOCATION_DECK+LOCATION_EXTRA)
end
function c25800031.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=eg:FilterCount(c25800031.cfilter,nil,tp)
	if  ct>0 and (c:IsFaceup() or c:IsPublic()) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(ct)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
----3
function c25800031.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,e:GetHandler(),1-tp)
end
function c25800031.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c25800031.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=c:GetLevel() 
	if x>12 then x=12 end
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(x*500)
	c:RegisterEffect(e2)
	local bg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local b1=bg:GetCount()>0
	if Duel.SelectYesNo(tp,aux.Stringid(25800031,2)) and c:IsPosition(POS_FACEUP_ATTACK) then
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		 local sg=bg:Select(tp,1,1,nil)
		 Duel.CalculateDamage(c,sg:GetFirst(),true)
	end
end
