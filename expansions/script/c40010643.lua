--银刺奇术
local m=40010643
local cm=_G["c"..m]
cm.named_with_SilverThorn=1
function cm.SilverThorn(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_SilverThorn
end
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Effect 2 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,m+1)
	e4:SetCondition(cm.con)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(cm.tg)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
end
cm.toss_dice=true
--Effect 1
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function cm.x(c)
	return c:IsFaceup() and cm.SilverThorn(c) and c:GetOverlayCount()>0
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local d1,d2,d3=Duel.TossDice(tp,3)
	local xyz=0
	local xg=Duel.GetMatchingGroup(cm.x,tp,LOCATION_MZONE,0,nil)
	local tc=xg:GetFirst()
	while tc do
		if tc:GetOverlayCount()>0 then
			xyz=xyz+tc:GetOverlayCount()
		end
		tc=xg:GetNext()
	end
	if xyz>0 then
		local ct=xyz+(d1+d2+d3)
		if ct>12 then
			cm.skipop(e,tp)
		end   
	else
		local ct=d1+d2+d3
		if ct>12 then
			cm.skipop(e,tp)
		end  
	end
end
function cm.skipop(e,tp)
	local ph=Duel.GetCurrentPhase()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	if Duel.GetTurnPlayer()~=tp and ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(cm.skipcon)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_OPPO_TURN,1)
	end
	Duel.RegisterEffect(e1,tp)
end
function cm.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
--Effect 2
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.fff(c)
	return cm.SilverThorn(c) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.fff,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.fff,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
