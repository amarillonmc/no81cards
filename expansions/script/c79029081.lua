--莱茵生命·辅助干员-麦哲伦
function c79029081.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()
	--Remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c79029081.lzcon)
	e1:SetTarget(c79029081.lztg)
	e1:SetOperation(c79029081.lzop)
	c:RegisterEffect(e1)  
	--token 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029081,0))
	e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,79029081)
	e2:SetCondition(c79029081.thcon)
	e2:SetTarget(c79029081.thtg)
	e2:SetOperation(c79029081.thop)
	c:RegisterEffect(e2) 
	--token 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029081,1))
	e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,79029081)
	e2:SetCondition(c79029081.thcon1)
	e2:SetTarget(c79029081.thtg1)
	e2:SetOperation(c79029081.thop1)
	c:RegisterEffect(e2)
	--token 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029081,2))
	e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,79029081)
	e2:SetCondition(c79029081.thcon2)
	e2:SetTarget(c79029081.thtg2)
	e2:SetOperation(c79029081.thop2)
	c:RegisterEffect(e2)  
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c79029081.icon1)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e4)
	--cannot target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetCondition(c79029081.icon2)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
	--pierce
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_PIERCE)
	e6:SetCondition(c79029081.icon2)
	c:RegisterEffect(e6)
	--atk up 
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetCondition(c79029081.icon3)
	e7:SetValue(2000)
	c:RegisterEffect(e7)
end
function c79029081.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,79029082)
end
function c79029081.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,79029083)
end
function c79029081.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,79029084)
end
function c79029081.lzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c79029081.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c79029081.lzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if e:GetHandler():IsRelateToEffect(e) and g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
		if tg:GetCount()>0 then
			Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c79029081.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,79029082,0,0x4011,2000,0,6,RACE_CYBERSE,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c79029081.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,79029082,0,0x4011,2000,0,6,RACE_CYBERSE,ATTRIBUTE_WATER) then return end
	local token=Duel.CreateToken(tp,79029082)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c79029081.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,79029082,0,0x4011,0,2000,6,RACE_CYBERSE,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c79029081.thop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,79029083,0,0x4011,0,2000,6,RACE_CYBERSE,ATTRIBUTE_WATER) then return end
	local token=Duel.CreateToken(tp,79029083)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c79029081.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,79029084,0,0x4011,3000,1000,6,RACE_CYBERSE,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c79029081.thop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,79029084,0,0x4011,3000,1000,6,RACE_CYBERSE,ATTRIBUTE_WATER) then return end
	local token=Duel.CreateToken(tp,79029084)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c79029081.icon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,79029083)
end
function c79029081.icon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,79029082)
end
function c79029081.icon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,79029084)
end
function c79029081.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,79029083)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1099,3,REASON_COST) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
		and tg end
	return Duel.SelectEffectYesNo(tp,c,79029096)
end
function c79029081.desop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.RemoveCounter(tp,1,0,0x1099,3,REASON_COST)
end

