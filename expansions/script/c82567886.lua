--方舟骑士·寻理者军团 梅尔
function c82567886.initial_effect(c)
	--mibo Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetDescription(aux.Stringid(82567886,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,82567886)
	e1:SetTarget(c82567886.sptg)
	e1:SetOperation(c82567886.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetDescription(aux.Stringid(82567886,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,82567886)
	e2:SetHintTiming(0,TIMING_BATTLE_START+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_MAIN_END+TIMING_SUMMON+TIMING_SPSUMMON+TIMINGS_CHECK_MONSTER)
	e2:SetCondition(c82567886.spcon)
	e2:SetTarget(c82567886.sptg)
	e2:SetOperation(c82567886.spop)
	c:RegisterEffect(e2)
	--mibo BOOM
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetDescription(aux.Stringid(82567886,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,82567887)
	e3:SetTarget(c82567886.destg)
	e3:SetOperation(c82567886.desop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e4:SetDescription(aux.Stringid(82567886,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,82567887)
	e4:SetHintTiming(0,TIMING_BATTLE_START+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_MAIN_END+TIMING_SUMMON+TIMING_SPSUMMON+TIMINGS_CHECK_MONSTER)
	e4:SetCondition(c82567886.spcon)
	e4:SetTarget(c82567886.destg)
	e4:SetOperation(c82567886.desop)
	c:RegisterEffect(e4)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82567886,2))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,82567888)
	e3:SetTarget(c82567886.cttg)
	e3:SetOperation(c82567886.ctop)
	c:RegisterEffect(e3)
end
function c82567886.myfilter(c)
	return c:IsCode(82567886) and c:IsFaceup()
end
function c82567886.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,82567887,0,0x4011,600,600,3,RACE_MACHINE,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c82567886.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,82567887,0,0x4011,600,600,3,RACE_MACHINE,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE,1-tp) or not e:GetHandler():IsRelateToEffect(e) then return end
	local token=Duel.CreateToken(tp,82567887)
	if Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)~=0 then
	local g=Duel.GetOperatedGroup()
	local mb=g:GetFirst()
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(1)
		mb:RegisterEffect(e3)
		 local e7=Effect.CreateEffect(e:GetHandler())
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e7:SetValue(1)
		mb:RegisterEffect(e7)
		 local e8=Effect.CreateEffect(e:GetHandler())
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e8:SetValue(1)
		mb:RegisterEffect(e8)
		 local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CANNOT_ATTACK)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
		e4:SetValue(1)
		mb:RegisterEffect(e4)
		local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_SELF_DESTROY)
	e5:SetCondition(c82567886.sdcon)
	mb:RegisterEffect(e5)
end
end
function c82567886.sdcon(e)
	return not Duel.IsExistingMatchingCard(c82567886.myfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c82567886.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and aux.bpcon()
end
function c82567886.desfilter(c)
	return c:IsFaceup() and c:IsCode(82567887)
end
function c82567886.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82567886.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c82567886.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c82567886.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c82567886.desfilter,tp,0,LOCATION_MZONE,nil)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
	Duel.Damage(1-tp,g:GetCount()*400,REASON_EFFECT)
end
end
function c82567886.adfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x825)
end
function c82567886.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc:IsCanAddCounter(0x5825,2) end
	if chk==0 then return Duel.IsExistingTarget(c82567886.adfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c82567886.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82567886.adfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x5825,1)
end
function c82567886.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c82567886.desfilter,tp,0,LOCATION_MZONE,nil)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(tp)
  then  tc:AddCounter(0x5825,ct)
	end
end