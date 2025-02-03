--亚刻·灼日装甲
function c36700146.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddMaterialCodeList(c,36700109)
	aux.AddFusionProcFunFunRep(c,c36700146.mfilter1,c36700146.mfilter2,1,63,true)
	aux.AddContactFusionProcedure(c,c36700146.sprfilter,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,aux.tdcfop(c))
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c36700146.splimit)
	c:RegisterEffect(e0)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c36700146.val)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsOriginalSetCard,0xc22))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
	--effect gain
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e5:SetCondition(c36700146.efcon)
	e5:SetOperation(c36700146.efop)
	c:RegisterEffect(e5)
	--to hand
	local e6=Effect.CreateEffect(c)
	e6:SetHintTiming(TIMING_DAMAGE_STEP)
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,36700146)
	e6:SetCondition(c36700146.thcon)
	--e6:SetTarget(c36700146.thtg)
	e6:SetOperation(c36700146.thop)
	c:RegisterEffect(e6)
c36700146.material_setcode=0xc22
end
function c36700146.mfilter1(c)
	return c:IsFusionCode(36700109) or c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH) and c:GetBaseDefense()==1000
end
function c36700146.mfilter2(c)
	return c:IsAttackBelow(2000)
end
function c36700146.sprfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost() and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function c36700146.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0xc22)
end
function c36700146.atkfilter(c)
	return c:IsSetCard(0xc22) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx()
end
function c36700146.val(e,c)
	return Duel.GetMatchingGroupCount(c36700146.atkfilter,c:GetControler(),0x30,0,nil)*500
end
function c36700146.efcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_FUSION)~=0
end
function c36700146.efop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	if not rc:IsType(TYPE_EFFECT) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e1,true)
	end
	local e2=Effect.CreateEffect(rc)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsOriginalSetCard,0xc22))
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e2,true)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	rc:RegisterEffect(e3,true)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_PIERCE)
	rc:RegisterEffect(e4,true)
end
function c36700146.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	return ph==PHASE_DAMAGE and (c==Duel.GetAttacker() or c==Duel.GetAttackTarget())
		and not Duel.IsDamageCalculated()
end
function c36700146.thfilter(c,loc)
	return c:IsLocation(loc) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c36700146.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	local g=cg:Filter(Card.IsControler,nil,1-tp)
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if #g==0 then return end
	local check=false
	if g:FilterCount(Card.IsAbleToHand,nil)==#g and (g:FilterCount(Card.IsAbleToRemove,nil)~=#g or Duel.SelectOption(tp,1190,1192)==0) then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		if g:FilterCount(c36700146.thfilter,nil,LOCATION_HAND)~=0 then check=true end
	else
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		if g:FilterCount(c36700146.thfilter,nil,LOCATION_REMOVED)~=0 then check=true end
	end
	if not check then
		Duel.Damage(1-tp,c:GetBaseAttack(),REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
