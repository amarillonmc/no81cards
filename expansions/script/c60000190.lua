--启圣泯厄
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60000179)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--battle indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetCondition(cm.condition)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
end
function cm.thfil(c)
	return c:IsCode(60000179) and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.thfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCounter(e:GetHandlerPlayer(),LOCATION_MZONE,0,0x62a)>=4
end
function cm.filter(c)
	return aux.IsCodeListed(c,60000179) and c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,nil)
	if #g<3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:Select(tp,3,3,nil)
	local tg=Group.CreateGroup()
	for tc in aux.Next(sg) do
		g:RemoveCard(tc)
		tg:AddCard(tc)
		local pg=g:Filter(Card.IsCode,nil,tc:GetCode())
		if #pg~=0 then
			g:Sub(pg)
			tg:Merge(pg)
		end
	end
	if Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)~=0 then
		local num=#Duel.GetOperatedGroup()
		if num>=3 then Duel.Draw(tp,1,REASON_EFFECT) end
		if num>=6 then
			local gg=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
			if #gg~=0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local rgg=gg:Select(tp,1,math.min(num,#gg),nil)
				Duel.Remove(rgg,POS_FACEUP,REASON_EFFECT)
			end
		end
		if num>=9 then
			local fg=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
			if #fg~=0 then Duel.Remove(fg,POS_FACEUP,REASON_EFFECT) end
		end
	end
end



