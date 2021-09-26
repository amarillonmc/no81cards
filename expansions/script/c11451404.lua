--幻旅传说·破晓
--21.04.10
local m=11451404
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_MSET)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge3:SetCondition(cm.checkcon)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge3:Clone()
		ge4:SetCode(EVENT_CHANGE_POS)
		Duel.RegisterEffect(ge4,0)
	end
end
cm.traveler_saga=true
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFacedown,1,nil)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,m+5,RESET_PHASE+PHASE_END,0,1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m+5)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SSET)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_TURN_SET)
	Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetTarget(cm.splimit)
	Duel.RegisterEffect(e4,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return sumpos&POS_FACEDOWN>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct+1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct+1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(Card.IsFacedown,p,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if Duel.Draw(p,ct+1,REASON_EFFECT)>0 and ct>0 then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_HAND,0,nil)
		if #g==0 then return end
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:Select(p,ct,ct,nil)
		Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
		ct=Duel.GetOperatedGroup():FilterCount(Card.IsControler,nil,p)
		Duel.SortDecktop(p,p,ct)
		for i=1,ct do
			local mg=Duel.GetDecktopGroup(p,1)
			Duel.MoveSequence(mg:GetFirst(),1)
		end
	end
end