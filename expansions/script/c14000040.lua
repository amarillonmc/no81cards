--悖论寄居·断崖
local m=14000040
local cm=_G["c"..m]
cm.named_with_Marsch=1
function cm.initial_effect(c)
	aux.AddCodeList(c,14000021)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--draw count
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(1,0)
	e2:SetValue(cm.drval)
	c:RegisterEffect(e2)
end
function cm.TM(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Marsch
end
function cm.setfilter(c,tp)
	return cm.TM(c) and c:IsSSetable() and not c:IsCode(m)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(14000021)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ct=ct-1 end
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		if Duel.SSet(tp,tc)~=0 then
			if Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				tc:RegisterEffect(e2)
			end
		end
	end
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
function cm.drfilter(c)
	return c:IsCode(m)
end
function cm.drval(e)
	local ct=Duel.GetMatchingGroupCount(cm.drfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return ct+1
end