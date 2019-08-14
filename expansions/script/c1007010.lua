--童话的怪物·桥的巨人
function c1007010.initial_effect(c)
	c:SetUniqueOnField(1,0,1007010)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,17010)
	e2:SetCondition(c1007010.con)
	e2:SetTarget(c1007010.target)
	e2:SetOperation(c1007010.activate)
	c:RegisterEffect(e2)
	--selfdes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetCondition(c1007010.descon)
	c:RegisterEffect(e7)
end
function c1007010.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xa20f)
end
function c1007010.con(e)
	return Duel.IsExistingMatchingCard(c1007010.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c1007010.target(e,tp,eg,ep,ev,re,r,rp,chk,m)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
		Duel.IsPlayerCanSpecialSummonMonster(tp,1007010,0,0x21,3000,3000,10,RACE_ROCK,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1007010.activate(e,tp,eg,ep,ev,re,r,rp,m)
	local c=nil
	if m then c=m else c=e:GetHandler() end
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,1007010,0,0x21,3000,3000,10,RACE_ROCK,ATTRIBUTE_EARTH) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
	c:AddMonsterAttributeComplete()
	--cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c1007010.imtg)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2,true)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3,true)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1007010,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+0x1c0)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c1007010.tdtg)
	e4:SetOperation(c1007010.tdop)
	c:RegisterEffect(e4,true)
	Duel.SpecialSummonComplete()
end
function c1007010.imtg(e,c)
	return c:IsSetCard(0x20f) and not c:IsCode(1007010)
end
function c1007010.tdfilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:IsDestructable()
end
function c1007010.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1007010.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1007010.tdfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c1007010.tdfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c1007010.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c1007010.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xa20f)
end
function c1007010.check()
	return Duel.IsExistingMatchingCard(c1007010.cfilter1,0,LOCATION_MZONE,0,1,nil)
end
function c1007010.descon(e)
	return not c1007010.check()
end