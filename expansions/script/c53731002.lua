local m=53731002
local cm=_G["c"..m]
cm.name="圣堂狂喑护教者"
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.sumcost)
	e1:SetTarget(cm.sumtg)
	e1:SetOperation(cm.sumop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,m+50)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function cm.sumfilter(c)
	return (c:IsRace(RACE_FIEND) or c:IsType(TYPE_NORMAL)) and c:IsSummonable(true,nil)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc then Duel.Summon(tp,tc,true,nil) end
end
function cm.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function cm.setfilter(c)
	return c:IsSetCard(0x9533) and c:GetType()&0x82==0x82 and c:IsSSetable()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.thfilter(chkc) end
	if chk==0 then return c:IsAbleToHand() and Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),Duel.GetFirstTarget()
	local hg=Duel.GetMatchingGroup(function(c)return c:IsLevelAbove(1) and c:IsType(TYPE_NORMAL)end,tp,LOCATION_HAND,0,nil)
	cm.lvop(hg,c,3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) cm.lvop(eg:Filter(function(c)return c:IsLevelAbove(1) and c:IsType(TYPE_NORMAL)end,nil),c,3) end)
	Duel.RegisterEffect(e2,tp)
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local rg=Group.FromCards(c,tc)
	if Duel.SendtoHand(rg,nil,REASON_EFFECT)~=0 and rg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then Duel.SSet(tp,g:GetFirst()) end
	end
end
function cm.lvop(g,c,ct)
	for lvc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(ct)
		e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		lvc:RegisterEffect(e1)
	end
end
