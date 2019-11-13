--IG-冠军艾瑞莉娅
function c9981566.initial_effect(c)
	 --xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c9981566.ovfilter,aux.Stringid(9981566,0))
	c:EnableReviveLimit()
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9981566.condition)
	e1:SetOperation(c9981566.regop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981566,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdocon)
	e2:SetTarget(c9981566.drtg)
	e2:SetOperation(c9981566.drop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981566.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
   --disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetDescription(aux.Stringid(9981566,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9981566)
	e2:SetCondition(c9981566.discon1)
	e2:SetCost(c9981566.discost)
	e2:SetTarget(c9981566.distg)
	e2:SetOperation(c9981566.disop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c9981566.discon2)
	c:RegisterEffect(e3)
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981566,3))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,99815660)
	e1:SetCondition(c9981566.atkcon)
	e1:SetCost(c9981566.atkcost)
	e1:SetOperation(c9981566.atkop)
	c:RegisterEffect(e1)
end
function c9981566.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981566,1))
end
function c9981566.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c9981566.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c9981566.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c9981566.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(9981566) and bit.band(sumtype,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c9981566.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9bce) and c:IsType(TYPE_XYZ) and not c:IsCode(9981566) and c:GetEquipGroup():IsExists(Card.IsType,1,nil,TYPE_EQUIP)
end
function c9981566.filter(c,ec)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c9981566.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9981566.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9981566.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c9981566.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c,true)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981566,1))
end
function c9981566.discon1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x9bce)
end
function c9981566.discon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x9bce)
end
function c9981566.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9981566.disfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c9981566.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9981566.disfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9981566.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9981566.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c9981566.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981566,1))
end
function c9981566.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if ph~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local tc=Duel.GetAttacker()
	return tc:IsControler(tp) and tc:IsRelateToBattle() and tc:IsSetCard(0x9bce) and tc:IsType(TYPE_XYZ) and Duel.GetAttackTarget()~=nil
end
function c9981566.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9981566.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsRelateToBattle() and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetAttack()*2)
		tc:RegisterEffect(e1)
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981566,1))
end