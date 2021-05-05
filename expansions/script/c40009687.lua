--柩机之兵 卢奇斯
function c40009687.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c40009687.condition)
	c:RegisterEffect(e1) 
	--Gains Effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCountLimit(1,40009688)
	e2:SetCondition(c40009687.efcon)
	e2:SetOperation(c40009687.efop)
	c:RegisterEffect(e2) 
	--overlay
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009687,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,40009687)
	e3:SetCondition(c40009687.ovcon1)
	e3:SetCost(c40009687.cost)
	e3:SetTarget(c40009687.sptg2)
	e3:SetOperation(c40009687.spop2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(c40009687.ovcon2)
	c:RegisterEffect(e4)
end
function c40009687.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x1f17)
end
function c40009687.condition(e,c)
	if c==nil then return true end
	return Duel.GetMZoneCount(c:GetControler())>0
		and not Duel.IsExistingMatchingCard(c40009687.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c40009687.efcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_XYZ and c:GetReasonCard():IsSetCard(0x1f17)
end
function c40009687.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009687,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c40009687.thtg)
	e1:SetOperation(c40009687.thop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function c40009687.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1f17) and c:IsAbleToHand() and not c:IsCode(40009687)
end
function c40009687.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009687.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40009687.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40009687.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c40009687.ovcfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_FIELD)
end
function c40009687.ovcfilter2(c)
	return c:IsFaceup() and (c:IsSetCard(0x1f17) or c:IsCode(18161786))
end
function c40009687.ovcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c40009687.ovcfilter1,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil) and not Duel.IsExistingMatchingCard(c40009687.ovcfilter2,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c40009687.ovcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c40009687.ovcfilter2,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c40009687.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c40009687.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c40009687.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

