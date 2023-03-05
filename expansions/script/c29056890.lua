--方舟骑士-海蒂
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,29065500,29065501)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+10000)
	e2:SetCost(cm.cos2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(Card.IsCode,1,nil,29065500,29056009)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end
--e2
function cm.cos2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK,0,nil):Filter(Card.IsSetCard,nil,0x87af)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	g=g:Select(tp,1,1,nil):GetFirst()
	Duel.ConfirmCards(1-tp,g)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	g:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
	e:SetLabelObject(g)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local tc=e:GetLabelObject()
	if tc and tc:GetFlagEffect(m)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(cm.op2con1)
		e1:SetOperation(cm.op2op1)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
		e2:SetCondition(cm.op2con2)
		e2:SetOperation(cm.op2op2)
		e2:SetLabel(0)
		tc:RegisterEffect(e2)
	end
end
function cm.op2con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and ep==1-tp
end
function cm.op2op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
function cm.op2con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.op2op2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	e:GetHandler():SetTurnCounter(ct+1)
	if ct==1 then cm.op2op1(e,tp,eg,ep,ev,re,r,rp)
	else e:SetLabel(1) end
end