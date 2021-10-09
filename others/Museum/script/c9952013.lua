--混沌No.101 寂静荣誉暗黑骑士-源数之门
function c9952013.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,4,c9952013.ovfilter,aux.Stringid(9952013,0))
	c:EnableReviveLimit()
 --material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9952013,2))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c9952013.target)
	e1:SetOperation(c9952013.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9952013,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c9952013.spcon)
	e2:SetTarget(c9952013.sptg)
	e2:SetOperation(c9952013.spop)
	c:RegisterEffect(e2)
 --atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9952013,3))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9952013)
	e2:SetCost(c9952013.atkcost)
	e2:SetCondition(c9952013.atkcon)
	e2:SetTarget(c9952013.atktg)
	e2:SetOperation(c9952013.atkop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9952013.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9952013.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9952013,4))
end
c9952013.xyz_number=101
function c9952013.ovfilter(c)
	return c:IsFaceup() and c:IsCode(48739166)
end
function c9952013.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9952013.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=a:GetBattleTarget()
	if a:IsControler(1-tp) then a,d=d,a end
	return a and a:IsFaceup() and a:IsRelateToBattle()
		and d and d:IsFaceup() and d:IsRelateToBattle()
		and d:GetAttack()>0 and a:GetControler()~=d:GetControler()
end
function c9952013.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) 
end
function c9952013.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9952013.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c9952013.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9952013.atkfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(tc:GetAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c9952013.filter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsCanOverlay()
end
function c9952013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c9952013.filter(chkc) end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingTarget(c9952013.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,c9952013.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c9952013.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c9952013.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetOverlayCount()>0
end
function c9952013.filter2(c)
	return c:IsSetCard(0x48) and c:IsType(TYPE_XYZ) and not c:IsCode(9952013)
end
function c9952013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c9952013.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	local rec=e:GetHandler():GetBaseAttack()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c9952013.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c9952013.filter2,tp,LOCATION_GRAVE,0,1,nil) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Recover(p,d,REASON_EFFECT)
	end
end
