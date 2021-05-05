--柩机之龙 巴比宗德
function c40009691.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c40009691.condition)
	c:RegisterEffect(e1) 
	--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009691,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c40009691.spcon)
	e2:SetCost(c40009691.spcost)
	e2:SetTarget(c40009691.sptg)
	e2:SetOperation(c40009691.spop)
	c:RegisterEffect(e2) 
	--To hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40009691,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,40009691)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c40009691.thtg)
	e4:SetOperation(c40009691.thop)
	c:RegisterEffect(e4)
	local e3=e4:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c40009691.xyzcon2)
	c:RegisterEffect(e3) 
end
function c40009691.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x1f17)
end
function c40009691.condition(e,c)
	if c==nil then return true end
	return Duel.GetMZoneCount(c:GetControler())>0
		and not Duel.IsExistingMatchingCard(c40009691.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c40009691.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSetCard(0x1f17)
end
function c40009691.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c40009691.spfilter(c,e,tp)
	return c:IsSetCard(0x1f17) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c40009691.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c40009691.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c40009691.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40009691.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c40009691.xyzcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil) or Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,LOCATION_FZONE,0,nil)
end
function c40009691.xyzcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_FZONE,1,nil)
end
function c40009691.thfilter(c)
	return c:IsSetCard(0x1f17) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(40009691)
end
function c40009691.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c40009691.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40009691.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c40009691.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c40009691.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end