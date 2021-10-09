--深海电脑乐土·热情迷唇-究极重击
function c9951089.initial_effect(c)
   --spirit return
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	 --cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
 --chain attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(c9951089.atcon)
	e2:SetOperation(c9951089.atop)
	c:RegisterEffect(e2)
 --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951089,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c9951089.spcon)
	e2:SetTarget(c9951089.sptg)
	e2:SetOperation(c9951089.spop)
	c:RegisterEffect(e2)
 --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951089.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951089.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951089,0))
end
function c9951089.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c9951089.ctfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c9951089.spfilter(c,e,tp)
	return c:IsSetCard(0x5ba8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9951089.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9951089.ctfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c9951089.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c9951089.spop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c9951089.ctfilter,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(c9951089.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	local ct=5
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	ct=math.min(ct,g1:GetCount(),(Duel.GetLocationCount(tp,LOCATION_MZONE)))
	if ct>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g2:Select(tp,1,ct,nil)
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9951089.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER) and c:IsChainAttackable(2,true) and c:IsStatus(STATUS_OPPO_BATTLE)
end
function c9951089.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToBattle() then return end
	Duel.ChainAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e1)
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951089,0))
end