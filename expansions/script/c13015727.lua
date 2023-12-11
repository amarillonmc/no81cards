--深海回音
local m=13015727
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)	
	--change attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.atktg)
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsSetCard(0xe01) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local dg=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			dg=dg:Select(tp,1,1,nil)
			Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
			e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e1:SetCountLimit(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
			e1:SetCondition(cm.thcon)
			e1:SetOperation(cm.thop)
			e1:SetLabel(0)
			c:RegisterEffect(e1)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.tgfilter(c)
	return c:IsFacedown() and c:IsAbleToGrave()
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	e:GetHandler():SetTurnCounter(ct+1)
	if ct==1 then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	else e:SetLabel(1) end
end
function cm.aclimit(e,c)
   return not (c:IsRace(RACE_AQUA) and c:IsAttribute(ATTRIBUTE_WATER))
end
--atk 
function cm.atkfilter(c)
	return c:IsRace(RACE_AQUA) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup()
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,cm.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local tg,val=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil):GetMaxGroup(Card.GetAttack)
		Duel.HintSelection(g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(val+1)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end




