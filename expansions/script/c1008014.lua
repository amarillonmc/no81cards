--罪恶王冠 校条祭
function c1008014.initial_effect(c)
	--void
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1008014,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_QUICK_O)
	e1:SetCode(1008001)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c1008014.tg)
	e1:SetOperation(c1008014.op)
	c:RegisterEffect(e1)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1008014,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCountLimit(1,10080142)
	e5:SetTarget(c1008014.sptg)
	e5:SetOperation(c1008014.spop)
	c:RegisterEffect(e5)
end
function c1008014.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,1008016,0x320e,0x4011,0,2100,6,RACE_FAIRY,ATTRIBUTE_LIGHT)
		and e:GetHandler():IsLocation(LOCATION_MZONE) and e:GetHandler():IsFaceup() end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c1008014.vtg(e,c)
	local g=Duel.GetMatchingGroup(Card.IsCode,0,LOCATION_MZONE,LOCATION_MZONE,nil,1008016)
	if g:GetCount()<2 then return false end
	local maxs=g:GetMaxGroup(Card.GetSequence):GetFirst():GetSequence()
	local mins=g:GetMinGroup(Card.GetSequence):GetFirst():GetSequence()
	return c:GetSequence()>mins and c:GetSequence()<maxs and c:IsFaceup() and c:IsSetCard(0x320e)
end
function c1008014.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 or not c:IsRelateToEffect(e) then return end
	if not c:IsLocation(LOCATION_MZONE) or not c:IsFaceup() then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,1008016,0x320e,0x4011,0,2100,6,RACE_FAIRY,ATTRIBUTE_LIGHT) then
		c:RegisterFlagEffect(10080011,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(1008001,4))
		local token=Duel.CreateToken(tp,1008016)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
		c:SetCardTarget(token)
		local token2=Duel.CreateToken(tp,1008017)
		Duel.SpecialSummonStep(token2,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
		c:SetCardTarget(token2)
		Duel.SpecialSummonComplete()
		--indes
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c1008014.vtg)
		e1:SetValue(1)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		c:RegisterEffect(e2)
		--Destroy
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e2:SetCode(EVENT_LEAVE_FIELD)
		e2:SetOperation(c1008014.desop)
		c:RegisterEffect(e2,true)
		--Destroy2
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EVENT_LEAVE_FIELD)
		e3:SetCondition(c1008014.descon2)
		e3:SetOperation(c1008014.desop2)
		c:RegisterEffect(e3,true)
	end
end
function c1008014.desfilter(c,rc)
	return rc:IsHasCardTarget(c)
end
function c1008014.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1008014.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler())
	Duel.Destroy(g,REASON_RULE)
end
function c1008014.dfilter(c,sg)
	return sg:IsContains(c)
end
function c1008014.descon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetCardTargetCount()==0 then return false end
	return c:GetCardTarget():IsExists(c1008014.dfilter,1,nil,eg) and re and not re:GetHandler():IsSetCard(0x320e)
end
function c1008014.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_RULE)
end
function c1008014.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c1008014.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c1008014.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x320e)
end
function c1008014.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c1008014.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end