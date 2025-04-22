--绝 望 骑 士
local m=43990027
local cm=_G["c"..m]
function cm.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCost(c43990027.spcost)
	e1:SetCondition(c43990027.spcon)
	e1:SetTarget(c43990027.sptg)
	e1:SetOperation(c43990027.spop)
	c:RegisterEffect(e1)
	--ATTRIBUTEc
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c43990027.attcon)
	e2:SetOperation(c43990027.attop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c43990027.dkcon)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	--change effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_F)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c43990027.chcon)
	--e4:SetTarget(c43990027.chtg)
	e4:SetOperation(c43990027.chop)
	c:RegisterEffect(e4)
	
end
function c43990027.cfilter(c)
	return not c:IsPreviousLocation(LOCATION_MZONE) and c:IsType(TYPE_MONSTER)
end
function c43990027.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c43990027.cfilter,1,nil)
end
function c43990027.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	e:GetHandler():RegisterFlagEffect(43990027,RESET_CHAIN,0,1)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c43990027.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c43990027.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) or (c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_COST) and c:GetFlagEffect(43990027)~=0) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c43990027.attcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsAttribute(ATTRIBUTE_DARK) and not eg:IsContains(e:GetHandler()) and eg:IsExists(c43990027.cfilter,1,nil,tp)
end
function c43990027.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_DARK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c43990027.dkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c43990027.chcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsAttribute(ATTRIBUTE_DARK) and rp==1-tp
end
function c43990027.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) and Duel.IsPlayerCanDiscardDeck(1-tp,3) end
end
function c43990027.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c43990027.repop)
end
function c43990027.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
	Duel.DiscardDeck(1-tp,3,REASON_EFFECT)
end

