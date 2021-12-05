--Restful Sepialife
--Scripted by:XGlitchy30
local id=33720032
local s=_G["c"..tostring(id)]
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END and Duel.GetTurnPlayer()==1-tp
end
function s.filter(c)
	return c:IsSetCard(0x144e) and c:IsPublic() and c:IsAbleToDeck()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_HAND,1,nil) end
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_HAND,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function s.cfilter(c,p)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(p)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_HAND,nil)
	if #g>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
		local ct=Duel.GetOperatedGroup():FilterCount(s.cfilter,nil,tp)
		if ct>0 then
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			local dam=ct*1000
			local n=math.floor(dam/500)
			if Duel.IsPlayerCanDiscardDeck(1-tp,1) and Duel.SelectYesNo(1-tp,aux.Stringid(id,1)) then
				local tab={}
				for i=1,n do
					table.insert(tab,i)
				end
				local val=Duel.AnnounceNumber(1-tp,table.unpack(tab))
				local rd=Duel.DiscardDeck(1-tp,val,REASON_EFFECT)
				dam=dam-rd*500
				if Duel.IsPlayerCanDiscardDeck(tp,rd) and Duel.SelectYesNo(1-tp,aux.Stringid(id,1)) then
					Duel.DiscardDeck(tp,rd,REASON_EFFECT)
				end
			end
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end