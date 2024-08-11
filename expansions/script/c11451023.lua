--幽玄龙景＊龙尾伏辰
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
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e3:SetOperation(cm.sumop)
	c:RegisterEffect(e3)
end
function cm.filter(c)
	return (c:IsOnField() and aux.NegateAnyFilter(c)) or (c:IsLocation(LOCATION_GRAVE) and not c:IsDisabled())
end
function cm.SpiritReturnReg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil):GetFirst()
	if not tc then return end
	--tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
	if tc:IsOnField() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2,true)
	if tc:IsType(TYPE_TRAPMONSTER) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3,true)
	end
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
function cm.smfilter(c)
	return c:IsSummonable(true,nil) or c:IsMSetable(true,nil)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	local dg=Duel.GetMatchingGroup(function(c) return c:IsFacedown() and c:IsAbleToHand() end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if #g>0 and #dg>0 and ((c:IsLocation(LOCATION_HAND) and loc==LOCATION_HAND and Duel.SelectEffectYesNo(tp,re:GetHandler(),aux.Stringid(m,0))) or (c:IsOnField() and loc&LOCATION_ONFIELD>0 and Duel.SelectEffectYesNo(tp,re:GetHandler(),aux.Stringid(m,0)))) then
		Duel.Hint(HINT_CARD,0,m)
		if c:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,c) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		g=g:Select(tp,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			local s1=tc:IsSummonable(true,nil)
			local s2=tc:IsMSetable(true,nil)
			if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
				Duel.Summon(tp,tc,true,nil)
				local g=Group.CreateGroup()
				Duel.ChangeTargetCard(ev,g)
				Duel.ChangeChainOperation(ev,cm.repop)
			else
				Duel.MSet(tp,tc,true,nil)
				local g=Group.CreateGroup()
				Duel.ChangeTargetCard(ev,g)
				Duel.ChangeChainOperation(ev,cm.repop2)
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
	e1:SetOperation(cm.rsop(e))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_NEGATED)
	Duel.RegisterEffect(e2,tp)
	e1:SetLabelObject(e2)
	e2:SetLabelObject(e1)
end
function cm.repop2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MSET)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetCurrentChain())
	e1:SetCondition(cm.rscon)
	e1:SetOperation(cm.rsop(e))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==e:GetLabel()-1
end
function cm.rsop(se)
	return function(e,tp,eg,ep,ev,re,r,rp)
				local _IsActivated=Effect.IsActivated
				local _GetType=Effect.GetType
				local _IsHasType=Effect.IsHasType
				Effect.IsActivated=function(te) return te==e or _IsActivated(te) end
				Effect.GetType=function(te) if te==e then return _GetType(se) else return _GetType(te) end end
				Effect.IsHasType=function(te,typ) return te:GetType()&typ>0 end
				local g=Duel.GetMatchingGroup(function(c) return c:IsFacedown() and c:IsAbleToHand() end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Effect.IsActivated=_IsActivated
				Effect.GetType=_GetType
				Effect.IsHasType=_IsHasType
				local te=e:GetLabelObject()
				if te and aux.GetValueType(te)=="Effect" then te:Reset() end
			end
end