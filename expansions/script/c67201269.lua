--翠帘开幕的彼方
function c67201269.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67201269,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67201270)
	e1:SetTarget(c67201269.target)
	e1:SetOperation(c67201269.activate)
	c:RegisterEffect(e1)
	 --disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67201269,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,67201269)
	e3:SetCondition(c67201269.stcon)
	e3:SetTarget(c67201269.sttg)
	e3:SetOperation(c67201269.stop)
	c:RegisterEffect(e3)	 
end
function c67201269.filter(c,e,tp)
	return c:IsFaceupEx() and c:IsSetCard(0xa67b) and Duel.IsExistingMatchingCard(c67201269.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute())
end
function c67201269.thfilter(c,att)
	return c:IsSetCard(0xa67b) and not c:IsAttribute(att) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c67201269.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c67201269.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c67201269.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c67201269.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67201269.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local att=tc:GetAttribute()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c67201269.thfilter,tp,LOCATION_DECK,0,1,1,nil,att)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
--
function c67201269.disfilter(c,tp)
	return c:IsSetCard(0xa67b) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE+LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceupEx()
end
function c67201269.stcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c67201269.disfilter,1,nil,tp)
end
function c67201269.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c67201269.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end