--决行预兆
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60000163)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.xyztg)
	e1:SetOperation(cm.xyzop)
	c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,LOCATION_MZONE,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,LOCATION_MZONE,0,1,1,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function cm.filter(c)
	return aux.IsCodeListed(c,60000163) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:GetType()~=TYPE_SPELL and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsPlayerCanDraw(tp,1)
			and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3
			and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

function cm.xyzfil(c,code)
	return c:IsCode(code)
end
function cm.mfil(c)
	return c:IsCode(60000169) and c:IsFaceup() and c:GetOverlayCount()==0
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tf=true
	for i=1,3 do
		if not Duel.IsExistingMatchingCard(cm.xyzfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil,m+i) then
			tf=false
		end
	end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.mfil,tp,LOCATION_MZONE,0,1,nil) and tf end
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tf=true
	for i=1,3 do
		if not Duel.IsExistingMatchingCard(cm.xyzfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil,m+i) then
			tf=false
		end
	end
	local g=Duel.GetMatchingGroup(cm.mfil,tp,LOCATION_MZONE,0,nil)
	if not tf or not #g==0 then return end
	local xyzg=Group.CreateGroup()
	for i=1,3 do
		local gg=Duel.GetMatchingGroup(cm.xyzfil,tp,LOCATION_GRAVE,0,nil,m+i)
		local dg=Duel.GetMatchingGroup(cm.xyzfil,tp,LOCATION_DECK,0,nil,m+i)
		if #gg>=2 then xyzg:Merge(gg:RandomSelect(tp,2))
		else 
			if #gg~=0 then xyzg:Merge(gg) end
			xyzg:Merge(dg:RandomSelect(tp,2-#gg))
		end
	end
	if #xyzg~=6 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if Duel.Overlay(tc,xyzg)~=0 then 
		Duel.SendtoHand(c,nil,REASON_EFFECT) 
		Duel.ShuffleHand() 
	end
end









