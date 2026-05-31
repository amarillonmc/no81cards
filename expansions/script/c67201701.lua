--异能环合 薄荷
function c67201701.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67201701,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,67201701)
	e1:SetCost(c67201701.cost)
	e1:SetTarget(c67201701.target)
	e1:SetOperation(c67201701.operation)
	c:RegisterEffect(e1)  
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67201701,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_HAND)
	--e4:SetCountLimit(1)
	e4:SetCondition(c67201701.setcon)
	e4:SetCost(c67201701.setcost)
	e4:SetTarget(c67201701.settg)
	e4:SetOperation(c67201701.setop)
	c:RegisterEffect(e4)  
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67201701,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,67201702)
	e2:SetCondition(c67201701.setcon1)
	e2:SetTarget(c67201701.settg1)
	e2:SetOperation(c67201701.setop1)
	c:RegisterEffect(e2) 
end
function c67201701.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c67201701.thfilter(c)
	return c:IsSetCard(0x567f) and c:IsAbleToHand()
end
function c67201701.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67201701.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67201701.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67201701.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c67201701.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc~=c and rc:IsSetCard(0x567f) and rc:IsControler(tp) and rc:IsAttribute(ATTRIBUTE_LIGHT)
end
function c67201701.cfilter(c,e,tp)
	return c:IsControler(tp) and c:IsFaceup() and Duel.GetMZoneCount(tp,c,tp)>1
end
function c67201701.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c67201701.cfilter,1,nil,e,tp) end
	local g=Duel.SelectReleaseGroup(tp,c67201701.cfilter,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
end
function c67201701.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,67201702,0x567f,TYPES_TOKEN_MONSTER,500,500,1,RACE_PSYCHO,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c67201701.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,67201702,0x567f,TYPES_TOKEN_MONSTER,500,500,1,RACE_PSYCHO,ATTRIBUTE_WIND) and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		local token=Duel.CreateToken(tp,67201702)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
--
function c67201701.setcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc~=c and rc:IsSetCard(0x567f) and rc:IsControler(tp) and rc:IsAttribute(ATTRIBUTE_FIRE)
end
function c67201701.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x567f) and c:IsAttribute(ATTRIBUTE_WIND+ATTRIBUTE_FIRE)
end
function c67201701.settg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c67201701.filter(chkc) end
	if chk==0 then return aux.bpcon() and Duel.IsExistingTarget(c67201701.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c67201701.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c67201701.setop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		--double battle damage
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
		e2:SetCondition(c67201701.damcon)
		e2:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c67201701.damcon(e)
	return e:GetHandler():GetBattleTarget()~=nil
end