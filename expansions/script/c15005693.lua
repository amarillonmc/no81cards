local m=15005693
local cm=_G["c"..m]
cm.name="在指针与心停摆的时间终末"
function cm.initial_effect(c)
	--spsummon from Deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
end
function cm.tfilter(c,e,tp)
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetOriginalCodeRule()) and c:IsReleasable()
end
function cm.filter(c,e,tp,...)
	return c:IsSetCard(0xaf3f) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and (#{...}==0 or not c:IsCode(...))
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetReleaseGroup(tp,true):Filter(cm.tfilter,e:GetHandler(),e,tp)
	if chk==0 then return #g1>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g1:Select(tp,1,1,nil)
	local tc=rg:GetFirst()
	aux.UseExtraReleaseCount(rg,tp)
	e:SetLabel(tc:GetOriginalCodeRule())
	Duel.Release(tc,REASON_COST)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() and e:GetLabel() and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetLabel())
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
	end
end