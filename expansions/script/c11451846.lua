--英豪冠军 复仇剑王
local cm,m=GetID()
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),4,2)--,cm.ovfilter,aux.Stringid(m,0))
	c:EnableReviveLimit()
	--xyzlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--must attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e3:SetValue(cm.atklimit)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(cm.efilter)
	c:RegisterEffect(e4)
	--battled
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BATTLED)
	e5:SetOperation(cm.atop)
	c:RegisterEffect(e5)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e4:SetLabelObject(g)
	e5:SetLabelObject(g)
	--activate
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetHintTiming(0x11e0)
	e6:SetCost(cm.cost)
	e6:SetTarget(cm.target)
	e6:SetOperation(cm.operation)
	c:RegisterEffect(e6)
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsRankBelow(4) and c:IsType(TYPE_XYZ)
end
function cm.atklimit(e,c)
	return c==e:GetHandler()
end
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and not (e:GetHandler():GetFlagEffect(m)>0 and e:GetLabelObject():IsContains(te:GetHandler()) and te:GetHandler():GetFlagEffect(m+1)>0)
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc then
		if c:GetFlagEffect(m)==0 then
			c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
			e:GetLabelObject():Clear()
		end
		e:GetLabelObject():AddCard(bc)
		bc:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end

function cm.filter(c,tp)
	return c:IsSetCard(0x6f) and c:IsType(TYPE_TRAP) and ((c:CheckActivateEffect(false,false,false)~=nil and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsType(TYPE_CONTINUOUS)) or (c:IsType(TYPE_CONTINUOUS) and c:GetActivateEffect():IsActivatable(tp)) or c:IsAbleToHand())
end
function cm.costfilter(c)
	return c:IsSetCard(0x6f) and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,c,tp)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.costfilter,tp,LOCATION_DECK,0,nil)
	if e:GetHandler():IsType(TYPE_XYZ) then
		local g2=e:GetHandler():GetOverlayGroup():Filter(cm.costfilter,nil)
		g:Merge(g2)
	end
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return #g>0
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(tg,REASON_COST)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local _IsHasType=Effect.IsHasType
	local _GetCurrentChain=Duel.GetCurrentChain
	Effect.IsHasType=function(e,typ) return typ==EFFECT_TYPE_ACTIVATE or _IsHasType(e,typ&~EFFECT_TYPE_ACTIVATE) end
	Duel.GetCurrentChain=function() return _GetCurrentChain()-1 end
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g>0 then
		local tc=g:GetFirst()
		if tc:IsType(TYPE_CONTINUOUS) then
			if not tc:GetActivateEffect():IsActivatable(tp) or Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(tp,tc)
			else
				local te=tc:GetActivateEffect()
				Duel.DisableShuffleCheck()
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				te:UseCountLimit(tp,1,true)
				local tep=tc:GetControler()
				local cost=te:GetCost()
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			end
		else
			if not (tc:CheckActivateEffect(false,false,false)~=nil and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(tp,tc)
			else
				Duel.DisableShuffleCheck()
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
				local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,false,true)
				te:UseCountLimit(tp,1,true)
				local cost=te:GetCost()
				local target=te:GetTarget()
				local operation=te:GetOperation()
				e:SetCategory(te:GetCategory())
				e:SetProperty(te:GetProperty())
				Duel.ClearTargetCard()
				tc:CreateEffectRelation(te)
				if cost then cost(te,tp,ceg,cep,cev,cre,cr,crp,1) end
				if not tc:IsHasEffect(EFFECT_REMAIN_FIELD) then tc:CancelToGrave(false) end
				if target then target(te,tp,ceg,cep,cev,cre,cr,crp,1) end
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				if g then
					for fc in aux.Next(g) do
						fc:CreateEffectRelation(te)
					end
				end
				if operation then operation(te,tp,ceg,cep,cev,cre,cr,crp) end
				tc:ReleaseEffectRelation(te)
				if g then
					for fc in aux.Next(g) do
						fc:ReleaseEffectRelation(te)
					end
				end
			end
		end
	end
	Effect.IsHasType=_IsHasType
	Duel.GetCurrentChain=_GetCurrentChain
end