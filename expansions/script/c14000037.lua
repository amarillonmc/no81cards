--悖论寄居·高塔
local m=14000037
local cm=_G["c"..m]
cm.named_with_Marsch=1
function cm.initial_effect(c)
	aux.AddCodeList(c,14000021)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--returncard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	--e2:SetCode(EVENT_FREE_CHAIN)
	--e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
end
function cm.TM(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Marsch
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end
function cm.setfilter(c,tp)
	return c:IsType(TYPE_QUICKPLAY) and c:IsFaceup() and c:IsSSetable() --and not c:IsCode(m)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ct=ct-1 end
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,tp) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		Duel.SSet(tp,tc)
	end
end
function cm.tdfilter(c,check)
	return (check or cm.TM(c)) and not c:IsForbidden()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function cm.nmfilter(c)
	return c:IsFaceup() and c:IsCode(14000021)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local chk1=Duel.IsExistingMatchingCard(cm.nmfilter,tp,LOCATION_ONFIELD,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_DECK,0,nil,chk1)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_DECK,0,1,1,nil,chk1)
		local tc=g:GetFirst()
		if tc then
			Duel.Hint(HINT_CARD,0,m)
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,0)
		end
	end
end