--狂风戈
local m=40009253
local cm=_G["c"..m]
cm.named_with_BLASTER=1
function cm.BLASTERBlade(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_BLASTERBlade
end
function cm.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)  
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.drtg)
	e3:SetOperation(cm.drop)
	c:RegisterEffect(e3)  
end
function cm.BLASTER(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_BLASTER
end
function cm.BlackChains(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_BlackChains
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.filter(c)
	return cm.BlackChains(c) and c:IsType(TYPE_CONTINUOUS+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.tgfilter(c)
	return (cm.BLASTERBlade(c) and c:IsFaceup())
end
function cm.aspfilter(c,e,tp)
	return c:IsCode(40009249) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if not Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_MZONE,0,1,nil) then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			local sg=Duel.GetMatchingGroup(cm.aspfilter,tp,LOCATION_HAND,0,nil,e,tp)
			if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=sg:Select(tp,1,1,nil)
				Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.Draw(tp,1,REASON_EFFECT)
	 Duel.Draw(1-tp,1,REASON_EFFECT)
			Duel.ShuffleHand(tp)
			Duel.ShuffleHand(1-tp)
end
