--墨菲定律
--21.08.05
local cm,m=GetID()
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tptg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
	local e5=e1:Clone()
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetRange(LOCATION_DECK)
	e5:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e5:SetCost(cm.cost)
	c:RegisterEffect(e5)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_DECK)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(cm.actarget)
	e4:SetOperation(cm.costop)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		cm.activate_sequence={}
		local _GetActivateLocation=Effect.GetActivateLocation
		local _GetActivateSequence=Effect.GetActivateSequence
		local _NegateActivation=Duel.NegateActivation
		function Effect.GetActivateLocation(e)
			if e:GetDescription()==aux.Stringid(m,0) then
				return _GetActivateLocation(e)
			end
			return _GetActivateLocation(e)
		end
		function Effect.GetActivateSequence(e)
			if e:GetDescription()==aux.Stringid(m,0) then
				return cm.activate_sequence[e]
			end
			return _GetActivateSequence(e)
		end
		function Duel.NegateActivation(ev)
			local re=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
			local res=_NegateActivation(ev)
			if res and aux.GetValueType(re)=="Effect" then
				local rc=re:GetHandler()
				if rc and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) and re:GetDescription()==aux.Stringid(m,0) then
					rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
				end
			end
			return res
		end
	end
end
function cm.actarget(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler()
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	cm.activate_sequence[te]=c:GetSequence()
	c:CreateEffectRelation(te)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(cm.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function cm.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost() and (c:IsAttack(0) or c:IsDefense(0))
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return ft>0 and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	cm.tpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.drcon1)
	e1:SetOperation(cm.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e10=e1:Clone()
	e10:SetCode(EVENT_SUMMON_SUCCESS)
	Duel.RegisterEffect(e10,tp)
	--sp_summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e20=e2:Clone()
	e20:SetCode(EVENT_SUMMON_SUCCESS)
	--Duel.RegisterEffect(e20,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(cm.drcon2)
	e3:SetOperation(cm.drop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function cm.filter(c)
	return c:IsSetCard(0x12e) and c:IsFaceup() --and c:IsPreviousLocation(LOCATION_HAND)
end
function cm.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil) and not Duel.IsChainSolving() --(e:GetCode()==EVENT_SUMMON_SUCCESS or not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function cm.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil) and Duel.IsChainSolving() --and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.drcon2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (bit.band(loc,LOCATION_MZONE)~=0 and rc:IsSetCard(0x12e)) or Duel.GetFlagEffect(tp,m)>0
end
function cm.drop2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local n=Duel.GetFlagEffect(tp,m)
	Duel.ResetFlagEffect(tp,m)
	if bit.band(loc,LOCATION_MZONE)~=0 and rc:IsSetCard(0x12e) then n=n+1 end
	Duel.Draw(tp,n,REASON_EFFECT)
end
function cm.drcon3(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return bit.band(loc,LOCATION_MZONE)~=0 and rc:IsSetCard(0x12e)
end
function cm.filter2(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_MONSTER)
end
function cm.tpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.tptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK,0,nil):GetClassCount(Card.GetCode)>=4 end
end
function cm.tpop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		aux.GCheckAdditional=aux.dncheck
		local rg=g:SelectSubGroup(tp,aux.TRUE,false,4,#g)
		aux.GCheckAdditional=nil
		Duel.ConfirmCards(1-tp,rg)
		Duel.ShuffleDeck(tp)
		local tg=rg:GetMinGroup(Card.GetSequence)
		while tg and #tg>0 do
			local tc=tg:GetFirst()
			Duel.MoveSequence(tc,0)
			rg:RemoveCard(tc)
			tg=rg:GetMinGroup(Card.GetSequence)
		end
	end
end