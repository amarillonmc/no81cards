--幽玄龙景＊太白蚀昴
local cm,m=GetID()
function cm.initial_effect(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--spirit return
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(cm.SpiritReturnReg)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+m)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.sumcon)
	e3:SetTarget(cm.sumtg)
	e3:SetOperation(cm.sumop)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local g=Group.CreateGroup()
		g:KeepAlive()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetLabel(m)
		ge1:SetLabelObject(g)
		ge1:SetOperation(cm.MergedDelayEventCheck1)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetOperation(cm.MergedDelayEventCheck2)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge2:Clone()
		ge3:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(ge3,0)
	end
end
s.has_text_type=TYPE_SPIRIT
function cm.MergedDelayEventCheck1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnCount()<=0 or not eg then return end
	local c=e:GetHandler()
	local eg2=eg:Filter(cm.cfilter,nil)
	local g=e:GetLabelObject()
	g:Merge(eg2)
	--if c:IsLocation(LOCATION_MZONE) and c:IsFaceup() then c:RegisterFlagEffect(m-1,RESET_EVENT+RESETS_STANDARD,0,1) end
	if (Duel.GetCurrentChain()==0 or (Duel.GetCurrentChain()==1 and (Duel.CheckEvent(EVENT_CHAIN_SOLVED) or Duel.CheckEvent(EVENT_CHAIN_NEGATED)))) and #g>0 then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+e:GetLabel(),re,r,rp,ep,ev)
		g:Clear()
	end
end
function cm.MergedDelayEventCheck2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if Duel.GetCurrentChain()==1 and #g>0 then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+e:GetLabel(),re,r,rp,ep,ev)
		g:Clear()
	end
end
function cm.cfilter(c)
	return c:IsPublic() or (not c:IsReason(REASON_DRAW) and not c:IsStatus(STATUS_TO_HAND_WITHOUT_CONFIRM) and (c:IsPreviousLocation(LOCATION_DECK) or c:IsPreviousPosition(POS_FACEUP)))
end
function cm.filter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsAbleToHand()
end
function cm.SpiritReturnReg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc then return end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0xd6e0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(Auxiliary.SpiritReturnConditionForced)
	e1:SetTarget(Auxiliary.SpiritReturnTargetForced)
	e1:SetOperation(Auxiliary.SpiritReturnOperation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(Auxiliary.SpiritReturnConditionOptional)
	e2:SetTarget(Auxiliary.SpiritReturnTargetOptional)
	c:RegisterEffect(e2)
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return #eg>0
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
	local tc=eg:GetFirst()
	while tc do
		local code,code2=tc:GetCode()
		Duel.Hint(HINT_CARD,0,code)
		if code2 then Duel.Hint(HINT_CARD,0,code2) end
		tc=eg:GetNext()
	end
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tab={}
	local tc=eg:GetFirst()
	while tc do
		local code,code2=tc:GetCode()
		tab[code]=true
		--Duel.Hint(HINT_CARD,0,code)
		--negate
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetLabel(code)
		e2:SetOperation(cm.disop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		if code2 then
			tab[code2]=true
			Duel.Hint(HINT_CARD,0,code2)
			--negate
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetLabel(code2)
			e2:SetOperation(cm.disop)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
		tc=eg:GetNext()
	end
end
function cm.smfilter(c)
	return c:IsSummonable(true,nil) or c:IsMSetable(true,nil)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	local op=re:GetOperation() or aux.TRUE
	if re:GetHandler():IsCode(e:GetLabel()) and Duel.IsChainDisablable(ev) and #g>0 and Duel.SelectEffectYesNo(tp,re:GetHandler(),aux.Stringid(m,1)) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		g=g:Select(tp,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			local s1=tc:IsSummonable(true,nil)
			local s2=tc:IsMSetable(true,nil)
			if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
				Duel.Summon(tp,tc,true,nil)
				if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
					cm.repop(e,tp,eg,ep,ev,re,r,rp)
				end
				--re:SetOperation(cm.repop(op,e,c,tp,ev))
			else
				Duel.MSet(tp,tc,true,nil)
				if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
					cm.repop2(e,tp,eg,ep,ev,re,r,rp)
				end
				--re:SetOperation(cm.repop2(op,e,c,tp,ev))
			end
		end
	end
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetCurrentChain())
	e1:SetCondition(cm.rscon)
	e1:SetOperation(cm.rsop(re))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_NEGATED)
	Duel.RegisterEffect(e2,tp)
	e1:SetLabelObject(e2)
	e2:SetLabelObject(e1)
	re:GetHandler():CreateEffectRelation(e1)
	re:GetHandler():CreateEffectRelation(e2)
end
function cm.repop2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MSET)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetCurrentChain())
	e1:SetCondition(cm.rscon)
	e1:SetOperation(cm.rsop(re))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	re:GetHandler():CreateEffectRelation(e1)
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==e:GetLabel()-1
end
function cm.rsop(re)
	return function(e,tp,eg,ep,ev,re2,r,rp)
				--if re:GetHandler():IsRelateToEffect(e) then Duel.Destroy(re:GetHandler(),REASON_EFFECT) end
				local te=e:GetLabelObject()
				if te and aux.GetValueType(te)=="Effect" then te:Reset() end
			end
end
--[[function cm.repop(op,re,rc,rtp,tev)
	return function(e,tp,eg,ep,ev,re,r,rp)
				e:SetOperation(op)
				local e1=Effect.CreateEffect(rc)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_SUMMON_SUCCESS)
				e1:SetCountLimit(1)
				e1:SetLabel(Duel.GetCurrentChain())
				e1:SetCondition(cm.rscon)
				e1:SetOperation(cm.rsop(e,tp,eg,ep,ev,re,r,rp,op,tev))
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,rtp)
				local e2=e1:Clone()
				e2:SetCode(EVENT_SUMMON_NEGATED)
				Duel.RegisterEffect(e2,rtp)
			end
end
function cm.repop2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MSET)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetCurrentChain())
	e1:SetCondition(cm.rscon)
	e1:SetOperation(cm.rsop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==e:GetLabel()-1
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp,op,tev)
	return function(se)
				local c=e:GetHandler()
				if Duel.NegateEffect(tev) then
					if c:IsRelateToEffect(e) then Duel.Destroy(c,REASON_EFFECT) end
				else
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_CUSTOM+m)
					e1:SetCountLimit(1)
					e1:SetOperation(cm.reop(e,tp,eg,ep,ev,re,r,rp,op))
					e1:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e1,tp)
					Duel.RaiseEvent(c,EVENT_CUSTOM+m,e,0,0,0,0)
				end
			end
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp,op)
	return function(se)
				op(e,tp,eg,ep,ev,re,r,rp)
			end
end-]]