--方舟骑士团-因陀罗
function c29023199.initial_effect(c)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29023199,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,29023199)
	e1:SetTarget(c29023199.thtg)
	e1:SetOperation(c29023199.thop)
	c:RegisterEffect(e1)	
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	c29023199.summon_effect=e1   
	--Equip or SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,29023200)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(c29023199.tg)
	e3:SetOperation(c29023199.op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetRange(LOCATION_HAND)
	e4:SetTarget(c29023199.eqtg)
	e4:SetOperation(c29023199.eqop)
	c:RegisterEffect(e4)
	--NegateAttack
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(29023199,5))
	e5:SetCode(EVENT_BE_BATTLE_TARGET)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCountLimit(1)
	e5:SetOperation(c29023199.neop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(29023199,6))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_BE_BATTLE_TARGET)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c29023199.necon)
	e6:SetOperation(c29023199.neop)
	c:RegisterEffect(e6)
end
--e1
function c29023199.thfilter(c)
	return c:IsSetCard(0x87af) and c:IsType(TYPE_MONSTER)and c:IsType(TYPE_UNION) and c:IsAbleToHand()
end
function c29023199.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29023199.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29023199.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29023199.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--e3
function c29023199.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x87af)
end
function c29023199.spfilter(c,e,tp)
	return c:GetEquipTarget()==e:GetHandler() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x87af)
end
function c29023199.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c29023199.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) 
	local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():CheckUniqueOnField(tp) and Duel.IsExistingMatchingCard(c29023199.filter,tp,LOCATION_MZONE,0,1,e:GetHandler())
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE)
end
function c29023199.op(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c29023199.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) 
	local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():CheckUniqueOnField(tp) and Duel.IsExistingMatchingCard(c29023199.filter,tp,LOCATION_MZONE,0,1,e:GetHandler())
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(29023199,1),aux.Stringid(29023199,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(29023199,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(29023199,2))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c29023199.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c29023199.filter,tp,LOCATION_MZONE,0,1,1,aux.ExceptThisCard(e),tp)
	local tc=g:GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsControler(1-tp) or tc:IsFacedown() or not c:CheckUniqueOnField(tp) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c29023199.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
	end
end
function c29023199.eqlimit(e,c)
	return c==e:GetLabelObject()
end
--e4
function c29023199.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and e:GetHandler():CheckUniqueOnField(tp)
		and Duel.IsExistingTarget(c29023199.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c29023199.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c29023199.filter,tp,LOCATION_MZONE,0,1,1,aux.ExceptThisCard(e),tp)
	local tc=g:GetFirst()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsControler(1-tp) or tc:IsFacedown() or not c:CheckUniqueOnField(tp) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c29023199.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
end
--e5
function c29023199.necon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local ec=e:GetHandler():GetEquipTarget()
	local at=Duel.GetAttacker()
	return tc==ec and at
end
function c29023199.neop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(29023199,3)) then
		Duel.Hint(HINT_CARD,0,29023199)
		Duel.NegateAttack()
	end
end