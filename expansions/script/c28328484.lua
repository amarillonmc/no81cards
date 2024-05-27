--第84届一等星讨论会！
function c28328484.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--field effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_DECK,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsOriginalSetCard,0x284))
	e1:SetValue(0x283)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x284))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_UPDATE_LEVEL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--XYZ support
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(28328484,0))
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,28328484)
	e5:SetTarget(c28328484.xyztg)
	e5:SetOperation(c28328484.xyzop)
	c:RegisterEffect(e5)
	--to hand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(28328484,1))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTarget(c28328484.thtg)
	e6:SetOperation(c28328484.thop)
	c:RegisterEffect(e6)
end
function c28328484.ofilter(c)
	return not c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c28328484.thfilter(c)
	return c:IsSetCard(0x283) and c:IsAbleToHand()
end
function c28328484.xfilter(c,tp)
	return c:GetMaterial():IsExists(c28328484.ofilter,3,nil) and c:IsSummonType(SUMMON_TYPE_XYZ) and c:GetSummonPlayer()==tp and c:IsFaceup() and ((c:IsRankAbove(8) and Duel.IsExistingMatchingCard(c28328484.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)) or (c:IsRankAbove(12) and Duel.IsPlayerCanDraw(tp,1)) or (c:IsRankAbove(16) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil)))
end
function c28328484.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c28328484.xfilter,1,nil,tp) end
	local g=eg:Filter(c28328484.xfilter,nil,tp)
	local tg=Group.CreateGroup()
	if #g==1 then
		tg:Merge(g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(28328484,2))
		cg=g:Select(tp,1,1,nil)
		tg:Merge(cg)
	end
	local ct=tg:GetFirst():GetRank()
	if ct>=8 and Duel.IsExistingMatchingCard(c28328484.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	end
	if ct>=12 and Duel.IsPlayerCanDraw(tp,1) then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
	if ct>=16 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,0)
	end
	e:SetLabel(ct)
end
function c28328484.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct>=8 and Duel.IsExistingMatchingCard(c28328484.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28328484,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28328484.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECTs)
		Duel.ConfirmCards(1-tp,tg)
	end
	if ct>=12 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(28328484,4)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if ct>=16 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28328484,5)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local gg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.SendtoGrave(gg,REASON_EFFECT)
	end
end
function c28328484.cfilter(c,re)
	return c:IsSetCard(0x284) and c:IsType(TYPE_MONSTER) and c:IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_XYZ) and c:IsPreviousLocation(LOCATION_OVERLAY) and c:IsLocation(LOCATION_GRAVE) and c:IsAbleToHand()
end
function c28328484.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c28328484.cfilter,nil,re)
	if chk==0 then return #g>0 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,nil)
end
function c28328484.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c28328484.cfilter,nil,re)
	local mg=g:Filter(Card.IsRelateToChain,nil)
	if #mg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local og=mg:Select(tp,1,1,nil)
		Duel.SendtoHand(og,nil,REASON_EFFECT)
	end
end
