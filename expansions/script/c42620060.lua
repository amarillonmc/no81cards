--新年祈愿 若狭悠里
local m=42620060
local cm=_G["c"..m]

function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
    --adjust
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    c:RegisterEffect(e2)
    --pzone
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_BOTH_SIDE)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCountLimit(1)
    e3:SetCost(cm.pcost)
    e3:SetTarget(cm.ptg)
    e3:SetOperation(cm.pop)
    c:RegisterEffect(e3)
end

function cm.tgfilter(c,tp)
	return c:IsFaceup() and c:IsAbleToRemove(tp,POS_FACEDOWN)
end

function cm.tgtfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(cm.tgfilter,tp,0,LOCATION_EXTRA,nil,tp)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_REMOVED,nil)
	local g3=Duel.GetMatchingGroup(cm.tgtfilter,tp,LOCATION_GRAVE,0,nil)
    local g4=Duel.GetMatchingGroup(cm.tgtfilter,tp,0,LOCATION_GRAVE,nil)
	if chk==0 then return #g1>0 or #g2>0 or (Duel.CheckLPCost(tp,Duel.GetLP(tp)-10) and #g3>0 and #g4>0) end
	g3:Merge(g4)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,1,nil,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,3,nil,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g3,1,nil,nil)
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(cm.tgfilter,tp,0,LOCATION_EXTRA,nil,tp)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_REMOVED,nil)
	local g3=Duel.GetMatchingGroup(cm.tgtfilter,tp,LOCATION_GRAVE,0,nil)
    local g4=Duel.GetMatchingGroup(cm.tgtfilter,tp,0,LOCATION_GRAVE,nil)
	local off=1
	local ops={}
	local opval={}
	if #g1>0 then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if #g2>0 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if Duel.CheckLPCost(tp,Duel.GetLP(tp)-10) and #g3>0 and #g4>0 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=3
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,0,LOCATION_EXTRA,1,1,nil,tp)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		end
	elseif opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_REMOVED,1,3,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	elseif opval[op]==3 then
        Duel.PayLPCost(tp,Duel.GetLP(tp)-10)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.tgtfilter,tp,LOCATION_GRAVE,0,1,1,nil)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tg=Duel.SelectMatchingCard(1-tp,cm.tgtfilter,tp,0,LOCATION_GRAVE,1,1,nil)
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.SendtoHand(tg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
        Duel.ConfirmCards(tp,tg)
        Duel.ShuffleHand(tp)
        Duel.ShuffleHand(1-tp)
	end
end

function cm.pcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2023) end
	Duel.PayLPCost(tp,2023)
end

function cm.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,2023)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end

function cm.pop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Recover(1-tp,2023,REASON_EFFECT)
	Duel.Draw(tp,1,REASON_EFFECT)
    Duel.Draw(1-tp,1,REASON_EFFECT)
end