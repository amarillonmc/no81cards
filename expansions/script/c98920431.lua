--贵血鬼 吸血鬼
function c98920431.initial_effect(c)
	 c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,7,2,nil,nil,99)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c98920431.lvtg)
	e1:SetValue(c98920431.lvval)
	c:RegisterEffect(e1)
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c98920431.actcon)
	e1:SetValue(c98920431.aclimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920431,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,98920431)
	e2:SetTarget(c98920431.sptg)
	e2:SetOperation(c98920431.spop)
	c:RegisterEffect(e2)
	 --search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920431,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,98920431)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c98920431.thcost)
	e3:SetTarget(c98920431.thtg)
	e3:SetOperation(c98920431.thop)
	c:RegisterEffect(e3)
end
function c98920431.lvtg(e,c)
	return c:IsLevelAbove(1) and c:GetOwner()~=e:GetHandlerPlayer()
end
function c98920431.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 7
	else return lv end
end
function c98920431.actcon(e)
	return Duel.IsExistingMatchingCard(Card.IsRace,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,e:GetHandler(),RACE_ZOMBIE)
end
function c98920431.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end
function c98920431.spfilter(c,e,tp)
	return c:IsControler(1-tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920431.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c98920431.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c98920431.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c98920431.spfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c98920431.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local atk=tc:GetAttack()
		local lp=tp:GetLP()
		Duel.SetLP(tp,lp-atk)
	end
end
function c98920431.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98920431.thfilter(c)
	return c:IsSetCard(0x8e) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c98920431.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920431.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920431.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920431.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end