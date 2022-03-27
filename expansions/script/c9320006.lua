--樱威刃·怒罗魂
function c9320006.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.EnableUnionAttribute(c,1)
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_PLANT),aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),true)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9320006,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9320006.eqtg)
	e1:SetOperation(c9320006.eqop)
	c:RegisterEffect(e1)
	--unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9320006,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c9320006.sptg)
	e2:SetOperation(c9320006.spop)
	c:RegisterEffect(e2)
	--attack all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetCondition(c9320006.immcon)
	e4:SetValue(c9320006.efilter)
	c:RegisterEffect(e4)
	--give effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c9320006.eftg)
	e5:SetLabelObject(e3)
	c:RegisterEffect(e5)
	--give effect 2
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetTarget(c9320006.eftg)
	e6:SetLabelObject(e4)
	c:RegisterEffect(e6)
	--equip 2
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(9320006,2))
	e7:SetCategory(CATEGORY_EQUIP)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e7:SetCountLimit(1,9320006)
	e7:SetCost(c9320006.spcost)
	e7:SetTarget(c9320006.eqtg2)
	e7:SetOperation(c9320006.eqop2)
	c:RegisterEffect(e7)
end
function c9320006.filter(c)
	local ct1,ct2=c:GetUnionCount()
	return c:IsFaceup() and ct2==0
end
function c9320006.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9320006.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(9320006)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c9320006.filter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c9320006.filter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	c:RegisterFlagEffect(9320006,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c9320006.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not c9320006.filter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	aux.SetUnionState(c)
end
function c9320006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(9320006)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(9320006,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c9320006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c9320006.immcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function c9320006.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and not c:IsOriginalCodeRule(9320006)
end
function c9320006.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
function c9320006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,2,c) 
				and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
				and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
				and c:CheckUniqueOnField(tp,LOCATION_SZONE) and not c:IsForbidden() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,2,2,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9320006.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9320006.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
		and c:CheckUniqueOnField(tp,LOCATION_SZONE) and not c:IsForbidden() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function c9320006.eqop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	if not c:CheckUniqueOnField(tp,LOCATION_SZONE) or c:IsForbidden() then return end
	if not Duel.Equip(tp,c,tc) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c9320006.eqlimit)
	c:RegisterEffect(e1)
end
function c9320006.eqlimit(e,c)
	return c==e:GetLabelObject()
end