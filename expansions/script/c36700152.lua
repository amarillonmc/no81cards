--共战 双重螺旋光刃
function c36700152.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddMaterialCodeList(c,36700109)
	aux.AddFusionProcFunFunRep(c,c36700152.mfilter1,c36700152.mfilter2,1,63,true)
	aux.AddContactFusionProcedure(c,c36700152.sprfilter,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,aux.tdcfop(c))
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c36700152.splimit)
	c:RegisterEffect(e0)
	--remove when chaining
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1192)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,36700152)
	e1:SetCondition(c36700152.rmcon)
	e1:SetTarget(c36700152.rmtg)
	e1:SetOperation(c36700152.rmop)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(c36700152.efcon)
	e2:SetOperation(c36700152.efop)
	c:RegisterEffect(e2)
	--atk change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(36700152,0))
	e3:SetHintTiming(TIMING_MAIN_END)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,36700152)
	e3:SetCondition(c36700152.atkcon)
	e3:SetTarget(c36700152.atktg)
	e3:SetOperation(c36700152.atkop)
	c:RegisterEffect(e3)
c36700152.material_setcode=0xc22
end
function c36700152.mfilter1(c)
	return c:IsFusionCode(36700109) or c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH) and c:GetBaseDefense()==1000
end
function c36700152.mfilter2(c)
	return c:IsAttackBelow(2000) and c:IsDefenseBelow(2000)
end
function c36700152.sprfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost() and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function c36700152.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function c36700152.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_DECK,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
end
function c36700152.rmop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
	local g=Duel.GetDecktopGroup(1-tp,1)
	Duel.DisableShuffleCheck()
	local c=e:GetHandler()
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c36700152.efcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_FUSION)~=0
end
function c36700152.efop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	if not rc:IsType(TYPE_EFFECT) then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_ADD_TYPE)
		e0:SetValue(TYPE_EFFECT)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e0,true)
	end
	--remove
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(1192)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,36700152)
	e1:SetCondition(c36700152.rmcon)
	e1:SetTarget(c36700152.rmtg)
	e1:SetOperation(c36700152.rmop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end
function c36700152.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c36700152.atkfilter(c)
	return c:IsFaceup() and not c:IsSetCard(0xc22) and c:GetAttack()>0
end
function c36700152.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c36700152.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c36700152.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tg=Group.CreateGroup()
	for tc in aux.Next(g) do
		if c36700152.atkfilter(tc) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			if not tc:IsAttack(0) then tg:AddCard(tc) end
		end
	end
	local rg=tg:Filter(Card.IsControler,nil,1-tp)
	if #g-#tg>0 and #rg>0 then
		Duel.BreakEffect()
		Duel.SendtoHand(rg,nil,REASON_RULE)
	end
end
