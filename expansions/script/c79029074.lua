--莱茵生命·辅助干员-梅尔
function c79029074.initial_effect(c)
	 --pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79029074.splimit)
	c:RegisterEffect(e2)
	--token  
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,79029074)
	e3:SetTarget(c79029074.thtg)
	e3:SetOperation(c79029074.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4) 
	--p effect
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_PZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(c79029074.xtg)
	e6:SetValue(1000)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
	--add setname 
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_PZONE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetCode(EFFECT_ADD_SETCODE)
	e8:SetTarget(c79029074.xtg)
	e8:SetValue(0x1907)
	c:RegisterEffect(e8) 
	--atk 
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_UPDATE_ATTACK)
	e9:SetValue(c79029074.atkval)
	c:RegisterEffect(e9)
	--SpecialSummon
	local e10=Effect.CreateEffect(c)
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCountLimit(1,19029074)
	e10:SetCondition(c79029074.spcon1)
	e10:SetCost(c79029074.spcost)
	e10:SetTarget(c79029074.sptg)
	e10:SetOperation(c79029074.spop)
	c:RegisterEffect(e10)
	local e11=e10:Clone()
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetHintTiming(0,TIMING_END_PHASE)
	e11:SetCondition(c79029074.spcon2)
	c:RegisterEffect(e11)
end
function c79029074.xtg(e,c)
	return c:IsType(TYPE_TOKEN)
end
function c79029074.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c79029074.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,79029075,0,0x4011,500,800,1,RACE_CYBERSE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c79029074.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,79029075,0,0x4011,500,800,1,RACE_CYBERSE,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,79029075)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	Debug.Message("咪波们，该上场咯！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029074,0))
end
function c79029074.atkfilter(c)
	return c:IsFaceup() and c:IsCode(79029075)
end
function c79029074.atkval(e,c)
	return Duel.GetMatchingGroupCount(c79029074.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)*1000
end
function c79029074.rlfil(c)
	return c:IsReleasable() and c:IsCode(79029075)
end
function c79029074.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,2,nil,0x1907)
end
function c79029074.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,2,nil,0x1907)
end
function c79029074.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029074.rlfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c79029074.rlfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Release(g,REASON_COST)
	Debug.Message("去吧，咪波三号！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029074,1))
	e:SetLabelObject(g:GetFirst())
end
function c79029074.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x1907) 
end
function c79029074.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029074.spfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_PZONE)
end
function c79029074.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c79029074.spfil,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_PZONE,0,nil,e,tp)
	if g:GetCount()<=0 then return end
	local sg=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end 









