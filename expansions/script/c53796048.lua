local m=53796048
local cm=_G["c"..m]
cm.name="任意坠落"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
end
function cm.chainfilter(re,tp,cid)
	return re:GetActivateLocation()~=LOCATION_GRAVE
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return math.abs(Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)-Duel.GetFieldGroupCount(tp,0,LOCATION_DECK))<4
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,PLAYER_ALL,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,PLAYER_ALL,1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local res=0
	while math.abs(Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)-Duel.GetFieldGroupCount(tp,0,LOCATION_DECK))<5 and (Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)~=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK) or res==0) do
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 or Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then break end
		if res==0 then res=res+1 else Duel.BreakEffect() end
		local d1,d2=Duel.TossDice(tp,1,1)
		Duel.ConfirmDecktop(tp,d1)
		Duel.ConfirmDecktop(1-tp,d2)
		local g1=Duel.GetDecktopGroup(tp,d1):Filter(Card.IsAbleToGrave,nil)
		local g2=Duel.GetDecktopGroup(1-tp,d2):Filter(Card.IsAbleToGrave,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg1,sg2=Group.CreateGroup(),Group.CreateGroup()
		if g1:GetCount()>0 then sg1=g1:Select(tp,1,#g1,nil) end
		if g2:GetCount()>0 then sg2=g2:Select(1-tp,1,#g2,nil) end
		local sg=Group.__add(sg1,sg2)
		if sg:GetCount()>0 then
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REVEAL)
		end
		d1,d2=d1-#sg1,d2-#sg2
		if d1>0 then
			Duel.SortDecktop(tp,tp,d1)
			for i=1,d1 do
				local mg1=Duel.GetDecktopGroup(tp,1)
				Duel.MoveSequence(mg1:GetFirst(),1)
			end
		end
		if d2>0 then
			Duel.SortDecktop(1-tp,1-tp,d2)
			for i=1,d2 do
				local mg2=Duel.GetDecktopGroup(1-tp,1)
				Duel.MoveSequence(mg2:GetFirst(),1)
			end
		end
	end
end
