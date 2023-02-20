--《倒吊人》·罗弗拉德
local m=60001233
local cm=_G["c"..m]
cm.name="《倒吊人》·罗弗拉德"
sr_blackcode={announce_filter={true,OPCODE_ISSETCARD}}
function cm.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(cm.retreg)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_FLIP_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(cm.retreg)
	c:RegisterEffect(e3)
end
function cm.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(aux.SpiritReturnConditionForced)
	e1:SetTarget(cm.rettg)
	e1:SetOperation(cm.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(aux.SpiritReturnConditionOptional)
	c:RegisterEffect(e2)
end
function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
			return true
		else
			return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SendtoDeck(g1,nil,2,REASON_RULE)
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local g2s=g2:GetFirst()
	while g2s do
		Duel.Remove(g2s,POS_FACEDOWN,REASON_EFFECT)
		g2s=g2:GetNext()		
	end		
	local g=Duel.GetMatchingGroup(cm.fil,tp,0,LOCATION_DECK,nil)
	for i=0,9 do
		local gm=g:GetFirst():GetCode()
		local tc=Duel.CreateToken(tp,gm)
		Duel.SendtoDeck(tc,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
		g:RemoveCard(g:GetFirst())
	end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	e3:SetCondition(cm.retcon)
	e3:SetOperation(cm.retop2)
	e3:SetLabel(Duel.GetTurnCount())
	Duel.RegisterEffect(e3,p)
	--draw
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DRAW)
	e2:SetCondition(cm.drcon)
	e2:SetOperation(cm.drop)
	Duel.RegisterEffect(e2,p)
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp,tc)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function cm.retop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.fil,tp,0,LOCATION_HAND,nil)
	local hx=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	for i=1,hx do
		local gm=g:GetFirst():GetCode()
		local tc=Duel.CreateToken(tp,gm)
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		g:RemoveCard(g:GetFirst())
	end
end
function cm.fil(c)
	return true
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then 
		Duel.Win(tp,WIN_REASON_THEHANGEDMAN)
	end
end








