--威迫诈返
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--instant(chain)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(cm.condition3)
	e4:SetTarget(cm.target3)
	e4:SetOperation(cm.activate3)
	c:RegisterEffect(e4)
end
function cm.condition3(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) and rp~=tp
end
function cm.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND,0,1,nil,TYPE_MONSTER) end
end
function cm.activate3(e,tp,eg,ep,ev,re,r,rp)
	local val=Duel.SelectOption(1-tp,aux.Stringid(m,0),aux.Stringid(m,1))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetOperation(cm.ctop)
	e1:SetLabel(ev)
	e1:SetValue(val)
	e1:Reset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	if ev~=e:GetLabel() then return end
	local val=e:GetValue()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	if val==0 then
		e1:SetOperation(cm.thop)
	else
		e1:SetOperation(cm.tdop)
	end
	e1:Reset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetCountLimit(1)
	e2:SetLabelObject(e1)
	e2:SetOperation(cm.rsop)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
	e:Reset()
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Reset()
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	local _,max1=g:GetMaxGroup(Card.GetLevel)
	local _,max2=g:GetMaxGroup(Card.GetRank)
	local _,max3=g:GetMaxGroup(Card.GetLink)
	local max=math.max(max1,max2,max3)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND,0,1,1,nil,TYPE_MONSTER)
	if #sg==0 then return end
	Duel.ConfirmCards(1-tp,sg)
	if sg:GetFirst():GetLevel()>max then
		g:Merge(sg)
		g=g:Filter(Card.IsAbleToDeck,nil)
		if #g==0 then return end
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		Duel.Draw(tp,ct,REASON_EFFECT)
	else
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end