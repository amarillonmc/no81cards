--电磁充雷
local m=40011623
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,75347539,42901635,4628897)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.descon1)
	e1:SetTarget(cm.destg1)
	e1:SetOperation(cm.desop1)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.descon2)
	e2:SetTarget(cm.destg2)
	e2:SetOperation(cm.desop2)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.descon3)
	e3:SetTarget(cm.destg3)
	e3:SetOperation(cm.desop3)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,3))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,m+1)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
end
function cm.cfilter1(c)
	return c:IsFaceup() and c:IsCode(75347539) and c:IsLevelAbove(5)
end
function cm.descon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function cm.desop1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
function cm.cfilter2(c)
	return c:IsFaceup() and c:IsCode(42901635) and c:IsLevelAbove(5)
end
function cm.descon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_SZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
function cm.cfilter3(c)
	return c:IsFaceup() and c:IsCode(4628897) and c:IsLevelAbove(5)
end
function cm.descon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter3,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.destg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function cm.desop3(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
function cm.egfilter(c)
	return c:IsSetCard(0x2066,0xe9) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(cm.egfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.thfilter(c)
	return (aux.IsCodeListed(c,75347539,42901635) or c:IsCode(12262393)) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.egfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
		if tc:GetOriginalLevel()==8 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if tg:GetCount()>0 then
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tg)
			end
		end
	end
end