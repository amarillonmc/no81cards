local m=15004028
local cm=_G["c"..m]
cm.name="带去希望的鸟"
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,cm.synfilter,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(cm.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.cgcon)
	e3:SetOperation(cm.cgop)
	c:RegisterEffect(e3)
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(cm.spcon)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
end
function cm.synfilter(c)
	return c:IsLevelAbove(5)
end
function cm.indtg(e,c)
	return ((c:IsSetCard(0x6f30) and c:IsType(TYPE_MONSTER)) or (c:IsCode(15004020)))
end
function cm.cgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.cgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_DARK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and bit.band(c:GetPreviousAttributeOnField(),ATTRIBUTE_DARK)~=0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsPlayerCanSpecialSummonMonster(tp,e:GetHandler():GetCode(),nil,e:GetHandler():GetType(),e:GetHandler():GetAttack(),e:GetHandler():GetDefense(),e:GetHandler():GetLevel(),e:GetHandler():GetRace(),ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,e:GetHandler():GetCode(),nil,e:GetHandler():GetType(),e:GetHandler():GetAttack(),e:GetHandler():GetDefense(),e:GetHandler():GetLevel(),e:GetHandler():GetRace(),ATTRIBUTE_DARK) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_DARK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_DISABLE)
	c:RegisterEffect(e1)
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		if c:IsFaceup() then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e2:SetValue(LOCATION_DECKBOT)
			c:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
			e3:SetType(EFFECT_TYPE_QUICK_O)
			e3:SetCode(EVENT_CHAINING)
			e3:SetRange(LOCATION_MZONE)
			e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
			e3:SetCountLimit(1,15004028)
			e3:SetCondition(cm.condition)
			e3:SetTarget(cm.target)
			e3:SetOperation(cm.activate)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e3)
		end
		Duel.SpecialSummonComplete()
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	return re:IsActiveType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToDeck() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoDeck(re:GetHandler(),nil,2,REASON_EFFECT)
	end
end