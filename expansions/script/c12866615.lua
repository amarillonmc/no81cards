--对魔特异4课 早川秋
function c12866615.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,12866615)
	e1:SetTarget(c12866615.eqtg)
	e1:SetOperation(c12866615.eqop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--select
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,12866616)
	e3:SetCondition(c12866615.condition1)
	e3:SetCost(c12866615.cost)
	e3:SetTarget(c12866615.target)
	e3:SetOperation(c12866615.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(c12866615.condition2)
	c:RegisterEffect(e4)
end
function c12866615.eqfilter(c,tp)
	return c:IsRace(RACE_FIEND) and not c:IsSummonableCard() and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c12866615.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c12866615.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c12866615.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local tc=Duel.SelectMatchingCard(tp,c12866615.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,tp):GetFirst()
		if not Duel.Equip(tp,tc,c) then return end
		--level up
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_UPDATE_LEVEL)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e0:SetValue(tc:GetLevel())
		c:RegisterEffect(e0)
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(c)
		e1:SetValue(c12866615.eqlimit)
		tc:RegisterEffect(e1)
		--atk up
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1800)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
function c12866615.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c12866615.condition1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsHasEffect(12866650)
end
function c12866615.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsHasEffect(12866650)
end
function c12866615.spfilter(c,e,tp,code)
	return c:IsRace(RACE_FIEND) and not (c:IsSummonableCard() or c:IsCode(code))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12866615.thfilter(c,lv)
	return c:IsRace(RACE_FIEND) and not c:IsSummonableCard() and c:IsLevel(lv) and c:IsAbleToHand()
end
function c12866615.costfilter(c,e,tp,rc)
	return c:IsControler(tp) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsAbleToGraveAsCost() and
		Duel.IsExistingMatchingCard(c12866615.thfilter,tp,LOCATION_DECK,0,1,nil,rc:GetLevel()) or (
		Duel.IsExistingMatchingCard(c12866615.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetCode()) and
		Duel.GetMZoneCount(tp)>0)
end
function c12866615.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetEquipGroup():IsExists(c12866615.costfilter,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=c:GetEquipGroup():FilterSelect(tp,c12866615.costfilter,1,1,nil,e,tp,c)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c12866615.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function c12866615.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c12866615.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,tc:GetCode()) and Duel.GetMZoneCount(tp)>0
	local b2=Duel.IsExistingMatchingCard(c12866615.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetLevel())
	if not (b1 or b2) then return end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(12866615,1)},
		{b2,aux.Stringid(12866615,2)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c12866615.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc:GetCode())
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c12866615.thfilter,tp,LOCATION_DECK,0,1,1,nil,c:GetLevel())
		if #tg>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
