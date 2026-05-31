--「这只是战术性撤退！」
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.tdfilter(c)
	return c:IsAbleToDeck()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e and e:GetHandler()
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_ONFIELD,0,nil)
	if c then
		g:RemoveCard(c)
	end
	if chk==0 then return g:GetCount()>0 end
	local ct=g:GetCount()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*1200)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*1200)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e and e:GetHandler()
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_ONFIELD,0,nil)
	if c then
		g:RemoveCard(c)
	end
	if g:GetCount()==0 then return end
	local ct=aux.PlaceCardsOnDeckBottom(tp,g,REASON_EFFECT)
	if ct>0 then
		Duel.Recover(tp,ct*1200,REASON_EFFECT)
		if ct>=5 then
			Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
		end
	end
end
