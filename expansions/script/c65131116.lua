--秘计螺旋 战吼\
local s,id,o=GetID()
function s.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e2:SetDescription(aux.Stringid(id,1))
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(s.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
function s.handcon(e)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)
	local sg=g:Filter(Card.IsFaceup,nil)
	return sg:GetCount()<=0
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if Duel.Draw(tp,1,REASON_EFFECT) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
		end
	end 
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetCondition(s.necon)
	e1:SetOperation(s.neop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.necon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActivated() and rp~=tp
end
function s.neop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetLabel(rp)
	e1:SetLabelObject(re)
	e1:SetCondition(s.tgcon)
	e1:SetOperation(s.tgop) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return re and e:GetLabelObject() and re==e:GetLabelObject()
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetLabel()
	local te=e:GetLabelObject()
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
	local tc=Duel.GetOperatedGroup():GetFirst()
	if tc then
		if tc:IsType(bit.band(te:GetActiveType(),0x7)) then
			Duel.NegateEffect(te)
		end
	end
end
function s.setfilter(c)
	return c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_HAND,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		local dc=g:GetFirst()
		Duel.SSet(tp,dc,tp,false)
	end
end