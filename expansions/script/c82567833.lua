function c82567833.initial_effect(c)
	c:SetUniqueOnField(1,0,aux.FilterBoolFunction(Card.IsCode,82567833),LOCATION_MZONE)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c82567833.sprfilter,nil,2,2,nil,nil)
	c:EnableReviveLimit()
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82567833,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c82567833.con)
	e4:SetOperation(c82567833.operation0)
	c:RegisterEffect(e4)
	--battle indes
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(82567833,1))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetCondition(c82567833.con)
	e5:SetOperation(c82567833.operation1)
	c:RegisterEffect(e5)
	--effect disable
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(82567833,2))
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCondition(c82567833.con)
	e7:SetOperation(c82567833.operation2)
	c:RegisterEffect(e7)
	--phantom Summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(82567833,3))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c82567833.sptg)
	e6:SetCost(c82567833.spcost)
	e6:SetOperation(c82567833.spop)
	c:RegisterEffect(e6)
	--revive 
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(82567833,5))
	e8:SetCategory(CATEGORY_TODECK)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_GRAVE)
	e8:SetCountLimit(1,82567833)
	e8:SetCost(c82567833.spcost2)
	e8:SetOperation(c82567833.spop2)
	c:RegisterEffect(e8)
end
function c82567833.sprfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) 
end
function c82567833.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType(SUMMON_TYPE_XYZ)
end
function c82567833.operation0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(82567833,5))
	c82567833.effect1(c)
end
function c82567833.effect1(c)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsCode,82567833,82567834))
	e6:SetReset(RESET_EVENT+RESETS_STANDARD)
	e6:SetValue(500)
	c:RegisterEffect(e6)
	 
end
function c82567833.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(82567833,6))
	c82567833.effect2(c)
end
function c82567833.effect2(c)
   local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,82567833,82567834))
		e1:SetValue(1)
		c:RegisterEffect(e1)
		 
end
function c82567833.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(82567833,7))	
	c82567833.effect3(c)
end
function c82567833.effect3(c)
local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82567833,4))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,c82567833)
	e3:SetTarget(c82567833.distg2)
	e3:SetOperation(c82567833.disop2)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e3)
end
function c82567833.disfilter1(c)
	return c:IsFaceup() and c:IsCode(82567833,82567834)
end
function c82567833.disfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c82567833.distg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local pm = Duel.GetMatchingGroupCount(c82567833.disfilter1,tp,LOCATION_MZONE,0,nil)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82567833.disfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectTarget(tp,c82567833.disfilter,tp,0,LOCATION_MZONE,1,pm,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c82567833.disop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	while tc and tc:IsRelateToEffect(e) do
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
end
function c82567833.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c82567833.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,82567834,0,0x4011,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c82567833.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,82567834,0,0x4011,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,82567834)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c82567833.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82567833.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
end
end