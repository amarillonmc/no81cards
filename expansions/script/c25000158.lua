--创世安魂曲
local m=25000158
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
 --activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(cm.cost2)
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	local hg=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,hg:GetCount(),nil)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local tg=Duel.GetOperatedGroup()
			for tc in aux.Next(tg) do
				tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			end  
				tg:KeepAlive() 
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(m,2))
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetLabelObject(tg)
				e1:SetCountLimit(1)
				e1:SetOperation(cm.retop)
				Duel.RegisterEffect(e1,tp)
	end
end
function cm.retfilter(c)
	return c:GetFlagEffect(m)~=0
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()   
	local sg=g:Filter(cm.retfilter,nil)
	g:DeleteGroup()
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end
function cm.thfilter(c)
	return c:IsRace(RACE_WYRM) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.thcon2)
	e1:SetOperation(cm.thop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function cm.cfilter(c)
	return c:IsRace(RACE_WYRM) and c:IsAbleToRemoveAsCost()
end
function cm.check(g,rs)
	if g:IsExists(Card.IsCode,1,nil,25000157) then return true end
	local ct=g:FilterCount(Card.IsRace,nil,RACE_WYRM)
	return ct>0 and ct<=rs
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	local hg=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,c)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,c)
	local hs=hg:GetCount()
	local rs=rg:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=hg:SelectSubGroup(tp,cm.check,false,1,hs,rs)
	local ss=Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
	local tg=Duel.GetOperatedGroup()
	local ts=tg:FilterCount(Card.IsRace,nil,RACE_WYRM)
	tg:KeepAlive()
	if ss~=0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tg)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
		if tg:IsExists(Card.IsCode,1,nil,25000157) then
			e:SetLabel(64)
		else
			e:SetLabel(ts)
		end
	end
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ss=e:GetLabel()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if ss==64 then 
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,LOCATION_ONFIELD)
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,ss,0,LOCATION_ONFIELD)
	end
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local ss=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	local gc=g:GetCount()
	if ss==64 and gc>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	elseif ss<=gc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,ss,ss,nil)
		Duel.HintSelection(rg)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end






