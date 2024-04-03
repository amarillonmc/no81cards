--黄金帝 黄金国巫妖
local m=91060008
local cm=c91060008
function c91060008.initial_effect(c)
	aux.EnableChangeCode(c,95440946,LOCATION_MZONE+LOCATION_GRAVE)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.lcheck,3)
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
	return c:IsSetCard(0x1142) or c:IsSetCard(0x143)  or c:IsSetCard(0x2142)
end
function cm.filter(c)
	return c:IsSetCard(0x143) and c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
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
		if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
			c:CancelToGrave()
			Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
		return
	end
	Duel.ConfirmCards(tp,tc)
	if tc:IsType(TYPE_TRAP) and tc:IsType(TYPE_CONTINUOUS) and tc:IsSetCard(0x143) then
	local code=tc:GetOriginalCode()
		local g=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0xff,0,nil,code)
		local te=tc:CheckActivateEffect(true,true,false)
		local op=te:GetOperation()
		for hc in aux.Next(g) do
			local pro1,pro2=te:GetProperty()
			local e1=te:Clone()
			e1:SetProperty(pro1|EFFECT_FLAG_SET_AVAILABLE,pro2)
			e1:SetCountLimit(1,code+321+EFFECT_COUNT_CODE_OATH)
			e1:SetOperation(function(ce,ctp,ceg,cep,cev,cre,cr,crp)
							op(ce,ctp,ceg,cep,cev,cre,cr,crp) 
							e1:Reset()
							end)
			hc:RegisterEffect(e1)
		end
		Duel.AdjustAll()
	Debug.Message("服务器中暂时无法直接发动「黄金乡」永续陷阱卡，改为增加1次发动次数，并且可以在覆盖的回合发动")
	  local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
	elseif tc:IsType(TYPE_TRAP+TYPE_SPELL) and not  tc:IsSetCard(0x143) then
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		if not te then
			Duel.ChangePosition(tc,POS_FACEUP)
			Duel.Destroy(tc,REASON_EFFECT)
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
					tc:CancelToGrave(false)
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
				Duel.Destroy(tc,REASON_EFFECT)
			end
		end
	end   
end