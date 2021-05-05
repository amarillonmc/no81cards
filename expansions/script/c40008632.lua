--星光体魔术师
function c40008632.initial_effect(c)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008632,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c40008632.target)
	e1:SetOperation(c40008632.activate)
	c:RegisterEffect(e1) 
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40008632,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,40008632)
	e3:SetCondition(c40008632.condition)
	e3:SetTarget(c40008632.thtg)
	e3:SetOperation(c40008632.thop)
	c:RegisterEffect(e3)   
end
function c40008632.cfilter(c)
	local lv=c:GetLevel()
	return c:IsFaceup() and lv~=0 and lv~=c:GetOriginalLevel() 
end
function c40008632.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c40008632.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c40008632.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xf10) and c:GetLevel()>0
end
function c40008632.filter2(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c40008632.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c40008632.filter1(chkc) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(c40008632.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c40008632.filter2,tp,LOCATION_MZONE,0,2,nil) and Duel.IsExistingTarget(c40008632.thfilter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SelectTarget(tp,c40008632.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c40008632.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(c40008632.filter2,tp,LOCATION_MZONE,0,tc)
		local lc=g:GetFirst()
		local lv=tc:GetLevel()*2
		while lc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			lc:RegisterEffect(e1)
			lc=g:GetNext()
			Duel.BreakEffect()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
	   end
   end
end
function c40008632.thfilter(c)
	return c:IsSetCard(0xf10) and not c:IsCode(40008632) and c:IsAbleToHand()
end
function c40008632.thfilter1(c)
	return c:IsSetCard(0xf10) and c:IsAbleToHand()
end
function c40008632.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008632.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40008632.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40008632.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end