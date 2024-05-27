--黄金帝 黄金国巫妖
local m=91060008
local cm=c91060008
function c91060008.initial_effect(c)
	aux.EnableChangeCode(c,95440946,LOCATION_MZONE+LOCATION_GRAVE)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.lcheck,3,3,nil)
	 local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m*2)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.activate2)
	c:RegisterEffect(e2)
end
function cm.lcheck(c)
	return  c:IsSetCard(0x1142,0x2142,0x143)
end
function cm.filter(c)
	return (c:IsSetCard(0x143) or c:IsSetCard(0x2142)) and c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and cm.filter(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler())
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.SSet(tp,tc)
end
function cm.filter2(c)
	return (c:IsSetCard(0x143) or c:IsSetCard(0x2142)) and c:IsType(TYPE_SPELL+TYPE_TRAP) 
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and cm.filter2(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter2,tp,LOCATION_SZONE,0,1,e:GetHandler()) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	Duel.SelectTarget(tp,cm.filter2,tp,LOCATION_SZONE,0,1,1,e:GetHandler())
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFaceup() then  
		return
	end
	Duel.ConfirmCards(tp,tc)
	if (tc:IsType(TYPE_SPELL) or tc:IsType(TYPE_TRAP)) and not tc:IsType(TYPE_CONTINUOUS) and not tc:IsType(TYPE_COUNTER) then
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		if not te then
			Duel.ChangePosition(tc,POS_FACEUP)
			if Duel.Destroy(tc,REASON_EFFECT)==0 then
				Duel.SendtoGrave(tc,REASON_RULE)
			end
		else
			local condition=te:GetCondition()
			local cost=te:GetCost()
			local target=te:GetTarget()
			local operation=te:GetOperation()
			if te:GetCode()==EVENT_FREE_CHAIN 
				and (not condition or condition(te,tep,eg,ep,ev,re,r,rp))
				and (not cost or cost(te,tep,eg,ep,ev,re,r,rp,0))
				and (not target or target(te,tep,eg,ep,ev,re,r,rp,0)) then
				Duel.ClearTargetCard()
				e:SetProperty(te:GetProperty())
				Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
				Duel.ChangePosition(tc,POS_FACEUP)
				if tc:GetType()==TYPE_TRAP then
					tc:CancelToGrave(false)
				end
				tc:CreateEffectRelation(te)
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
				if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				local tg=g:GetFirst()
				while tg do
					tg:CreateEffectRelation(te)
					tg=g:GetNext()
				end
				if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
				tc:ReleaseEffectRelation(te)
				tg=g:GetFirst()
				while tg do
					tg:ReleaseEffectRelation(te)
					tg=g:GetNext()
				end
			else
				if Duel.Destroy(tc,REASON_EFFECT)==0 then
					Duel.SendtoGrave(tc,REASON_RULE)
				end
			end
		end
	elseif tc:IsType(TYPE_TRAP) and not tc:IsType(TYPE_COUNTER) then
	local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	elseif (tc:IsType(TYPE_SPELL) and tc:IsType(TYPE_CONTINUOUS)) or tc:IsType(TYPE_COUNTER) then
	local g=Duel.SelectMatchingCard(tp,cm.fit2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil)
	if g:GetCount()>0 then
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT) end
	end
end
function cm.fit2(c)
return c:IsFaceup() and (c:IsSetCard(0x2142) or c:IsSetCard(0x143)) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end