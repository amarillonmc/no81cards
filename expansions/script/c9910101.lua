--战车道少女·西住美穗
dofile("expansions/script/c9910100.lua")
function c9910101.initial_effect(c)
	--special summon
	QutryZcd.SelfSpsummonEffect(c,0,true,nil,true,nil,true,nil)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_MOVE)
	e2:SetCountLimit(1,9910102)
	e2:SetCondition(c9910101.thcon)
	e2:SetTarget(c9910101.thtg)
	e2:SetOperation(c9910101.thop)
	c:RegisterEffect(e2)
end
function c9910101.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_XYZ) and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c9910101.thfilter(c)
	return c:IsSetCard(0x9958) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c9910101.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9910101.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return #g>0 and g:CheckSubGroup(aux.gfcheck,2,2,Card.IsType,TYPE_SPELL,TYPE_TRAP) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c9910101.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910101.thfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsType,TYPE_SPELL,TYPE_TRAP)
	if sg and #sg==2 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
