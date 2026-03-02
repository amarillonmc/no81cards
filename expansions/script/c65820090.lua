--源于黑影 暗箱
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+65820000)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetTarget(s.rdtg)
	e2:SetOperation(s.rdop)
	c:RegisterEffect(e2)
end

function s.filter(c)
	return c:IsSetCard(0x3a32) and c:IsAbleToHand() and (c:IsLocation(LOCATION_DECK) or c:IsLocation(LOCATION_REMOVED) and c:IsFacedown())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)~=0 then return end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_REMOVED,0,0,99,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		local ct=g:GetCount()
		if Duel.IsExistingMatchingCard(Card.IsOriginalCodeRule,tp,LOCATION_HAND,0,ct,nil,id) then
			Duel.ShuffleHand(tp)
			local g1=Duel.SelectMatchingCard(tp,Card.IsOriginalCodeRule,tp,LOCATION_HAND,0,ct,ct,nil,id)
			Duel.ConfirmCards(1-tp,g1)
		else
			local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
			if g1:GetCount()>0 then
				Duel.ConfirmCards(1-tp,g1)
			end
			local WIN_REASON_TRUE_EXODIA = 0x3a32
			Duel.Win(1-tp,WIN_REASON_TRUE_EXODIA)
		end
	end
end


function s.filter1(c)
	return c:IsCode(id) and c:IsFaceupEx() and c:IsAbleToDeck()
end
function s.rdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then return Duel.GetFlagEffect(tp,id+1)==0 and #g>0 and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.rdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id+1)~=0 then return end
	Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,0)
	local g=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if #g==0 then return end
	local dg=g:Select(tp,1,#g,nil)
	if #dg==0 then return end
	Duel.ConfirmCards(1-tp,dg)
	local ct=Duel.SendtoDeck(dg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if ct==0 then return false end
	Duel.BreakEffect()
	Duel.Draw(tp,ct,REASON_EFFECT)
end 