--无限暗影 拉比艾尔
local m=11561046
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,6007213,32491822,69890967)
	aux.EnableChangeCode(c,11561046,LOCATION_MZONE+LOCATION_GRAVE)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,11571046)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c11561046.thtg)
	e1:SetOperation(c11561046.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11561046)
	e2:SetCost(c11561046.spcost)
	e2:SetTarget(c11561046.sptarget)
	e2:SetOperation(c11561046.spoperation)
	c:RegisterEffect(e2)
end
	
function c11561046.thfilter(c)
	return (c:IsCode(6007213,32491822,69890967) or (aux.IsCodeListed(c,6007213) or aux.IsCodeListed(c,32491822) or aux.IsCodeListed(c,69890967))) and not c:IsCode(11561046) and c:IsAbleToHand()
end
function c11561046.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11561046.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11561046.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11561046.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c11561046.gcheck(g,e,tp)
	return g:IsContains(e:GetHandler()) and Duel.GetMZoneCount(tp,g)>0
end
function c11561046.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return g:CheckSubGroup(c11561046.gcheck,3,3,e,tp) end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,c11561046.gcheck,false,3,3,e,tp)
	Duel.Release(sg,REASON_COST)
end
function c11561046.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCode(6007213,32491822,69890967) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c11561046.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11561046.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c11561046.spoperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11561046.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
