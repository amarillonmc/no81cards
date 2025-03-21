--英龙骑-赤枪龙
function c46250010.initial_effect(c)
	c:SetSPSummonOnce(46250010)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c46250010.lfilter,1,1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c46250010.sumcon)
	e1:SetTarget(c46250010.sumtg)
	e1:SetOperation(c46250010.sumop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c46250010.atkval)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c46250010.spcon)
	e5:SetCost(c46250010.spcost)
	e5:SetTarget(c46250010.sptg)
	e5:SetOperation(c46250010.spop)
	c:RegisterEffect(e5)
end
function c46250010.lfilter(c)
	return c:IsLinkSetCard(0x1fc0)
end
function c46250010.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c46250010.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetMaterial():GetFirst()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsLocation(LOCATION_GRAVE) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,tc,1,0,0)
end
function c46250010.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	local c=e:GetHandler()
	local tc=c:GetMaterial():GetFirst()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsLocation(LOCATION_GRAVE) then
		if not Duel.Equip(tp,tc,c,true) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c46250010.eqlimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
		e2:SetRange(LOCATION_SZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(c46250010.matval)
		tc:RegisterEffect(e2)
	end
end
function c46250010.eqlimit(e,c)
	return e:GetOwner()==c
end
function c46250010.matval(e,c,mg)
	return c:IsRace(RACE_WYRM) and c:IsControler(e:GetHandlerPlayer()),true
end
function c46250010.atkval(e,c)
	return Group.GetSum(c:GetEquipGroup():Filter(Card.IsSetCard,nil,0x1fc0),Card.GetTextAttack)
end
function c46250010.spcon(e,tp,eg,ep,ev,re,r,rp)
	local eg=e:GetHandler():GetEquipGroup()
	return eg and eg:IsExists(Card.IsSetCard,1,nil,0x1fc0)
end
function c46250010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c46250010.thfilter(c)
	return c:IsSetCard(0x1fc0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c46250010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c46250010.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,0,1,tp,LOCATION_DECK)
end
function c46250010.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c46250010.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end

local re=Card.IsSetCard
Card.IsSetCard=function(c,name)
	if name==0xfc0 and c:IsCode(35089369) then return true end
	return re(c,name)
end
