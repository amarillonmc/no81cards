--人理之基 克莱尔小姐
function c22022920.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22022920,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,22022920)
	e1:SetCondition(c22022920.eqcon)
	e1:SetTarget(c22022920.eqtg)
	e1:SetOperation(c22022920.eqop)
	c:RegisterEffect(e1)
	--Untargetable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22022920,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,22022921)
	e5:SetCondition(c22022920.spcon)
	e5:SetCost(c22022920.spcost)
	e5:SetTarget(c22022920.sptg)
	e5:SetOperation(c22022920.spop)
	c:RegisterEffect(e5)
	--special summon eq
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22022920,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1,22022921)
	e6:SetCondition(c22022920.spcon1)
	e6:SetCost(c22022920.spcost)
	e6:SetTarget(c22022920.sptg)
	e6:SetOperation(c22022920.spop)
	c:RegisterEffect(e6)
end
function c22022920.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return not (r==REASON_RULE)
end
function c22022920.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff1)
end
function c22022920.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22022920.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and e:GetHandler():CheckUniqueOnField(tp)
		and Duel.IsExistingTarget(c22022920.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c22022920.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if e:GetHandler():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
		Duel.SelectOption(tp,aux.Stringid(22022920,2))
	end
end
function c22022920.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsControler(1-tp) or tc:IsFacedown() or not tc:IsRelateToEffect(e) or not c:CheckUniqueOnField(tp) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c22022920.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
end
function c22022920.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c22022920.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c22022920.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c22022920.filter(c,e,tp)
	return not c:IsCode(22022920) and c:IsSetCard(0xff1) and c:IsCanBeSpecialSummoned(e,SUMMON_VALUE_GLADIATOR,tp,false,false)
end
function c22022920.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c22022920.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SelectOption(tp,aux.Stringid(22022920,3))
end
function c22022920.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22022920.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_VALUE_GLADIATOR,tp,tp,false,false,POS_FACEUP)
		tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD+RESET_DISABLE,0,0)
		Duel.SelectOption(tp,aux.Stringid(22022920,4))
	end
end
function c22022920.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetEquipTarget()
end