--刻刻帝女神 十一之弹·Yud·Aleph
function c9980190.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x6bc8),4,2,nil,99)
	c:EnableReviveLimit()
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c9980190.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	 --search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980190,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9980190)
	e2:SetCost(c9980190.thcost)
	e2:SetTarget(c9980190.thtg)
	e2:SetOperation(c9980190.thop)
	c:RegisterEffect(e2)
	--multi attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e2:SetValue(c9980190.raval)
	c:RegisterEffect(e2)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980190,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9980190)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9980190.tktg)
	e2:SetOperation(c9980190.tkop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980190.sumsuc)
	c:RegisterEffect(e8)
end
function c9980190.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980190,0))
end
function c9980190.atkval(e,c)
	return c:GetOverlayCount()*300
end
function c9980190.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9980190.thfilter(c)
	return c:IsSetCard(0x6bc8) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c9980190.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9980190.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9980190.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9980190.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9980190.raval(e,c)
	return e:GetHandler():GetOverlayCount()
end
function c9980190.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9980195,0x6bc8,0x4011,1300,1300,4,RACE_FAIRY,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c9980190.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,9980195,0x6bc8,0x4011,1300,1300,4,RACE_FAIRY,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,26326542)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end