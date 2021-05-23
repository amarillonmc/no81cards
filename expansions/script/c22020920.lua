--人理之基 玛丽·安托瓦内特
function c22020920.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(aux.bfgcost)
	e1:SetCountLimit(1,22020920)
	e1:SetTarget(c22020920.target)
	e1:SetOperation(c22020920.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c22020920.filter(c,e)
	return c:IsFaceup() and c:IsSetCard(0xff1) and c:IsCanBeEffectTarget(e) and Duel.IsExistingMatchingCard(c22020920.filter2,tp,LOCATION_DECK,0,1,nil,c:GetCode(),e,tp)
end
function c22020920.filter2(c,code,e,tp)
	return aux.IsCodeListed(c,code) and c:IsAbleToHand() and c:IsSetCard(0x3ff1)
end
function c22020920.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) end
	if chk==0 then return eg:IsExists(c22020920.filter,1,nil,e) end
	if eg:GetCount()==1 then
		Duel.SetTargetCard(eg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=eg:FilterSelect(tp,c22020920.filter,1,1,nil,e)
		Duel.SetTargetCard(g)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c22020920.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c22020920.filter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode(),e,tp)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end