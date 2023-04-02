--永夏的花海
require("expansions/script/c9910950")
function c9910970.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c9910970.activate)
	c:RegisterEffect(e1)
	--synchro summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910970,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,9910970)
	e2:SetCondition(c9910970.thcon)
	e2:SetTarget(c9910970.thtg)
	e2:SetOperation(c9910970.thop)
	c:RegisterEffect(e2)
	--level
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,9910981)
	e3:SetCost(c9910970.lvcost)
	e3:SetTarget(c9910970.lvtg)
	e3:SetOperation(c9910970.lvop)
	c:RegisterEffect(e3)
end
function c9910970.activate(e,tp,eg,ep,ev,re,r,rp)
	QutryYx.ExtraEffectSelect(e,tp,false)
end
function c9910970.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x5954) and c:IsSummonLocation(LOCATION_DECK+LOCATION_EXTRA) and c:IsSummonPlayer(tp)
end
function c9910970.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910970.cfilter,1,nil,tp)
end
function c9910970.thfilter(c)
	return c:IsSetCard(0x5954) and c:IsAbleToHand() and not c:IsCode(9910970)
end
function c9910970.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(QutryYx.Filter0,tp,LOCATION_REMOVED,0,3,nil)
		and Duel.IsExistingMatchingCard(c9910970.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910970.thop(e,tp,eg,ep,ev,re,r,rp)
	if QutryYx.ToDeck(tp,3) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c9910970.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c9910970.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost(POS_FACEDOWN) end
	Duel.HintSelection(Group.FromCards(c))
	Duel.Remove(c,POS_FACEDOWN,REASON_COST)
end
function c9910970.lvfilter(c)
	return c:IsSetCard(0x5954) and c:IsFaceup() and c:IsLevelAbove(1)
end
function c9910970.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9910970.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910970.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c9910970.lvfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9910970.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local lv=Duel.AnnounceNumber(tp,1,2,3)
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(lv)
		tc:RegisterEffect(e1)
	end
end
