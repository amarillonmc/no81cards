if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetOperation(s.sumop)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_PHASE+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.ctcon)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,4))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_MOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCondition(s.sdcon)
	e3:SetTarget(s.sdtg)
	e3:SetOperation(s.sdop)
	c:RegisterEffect(e3)
	s.self_destroy_effect=e3
	if not s.global_check then
		s.global_check=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_ADJUST)
		ge0:SetOperation(s.geop)
		Duel.RegisterEffect(ge0,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(s.adjust)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)~=0
end
function s.ctfilter(c)
	return c:GetOriginalType()&TYPE_MONSTER~=0 and c:GetBaseAttack()==0 and c:IsFaceup()
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and s.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.ctfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	Duel.SelectTarget(tp,s.ctfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EFFECT_DESTROY_REPLACE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetTarget(s.reptg)
		e1:SetOperation(s.repop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	end
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BATTLE_START)
		e2:SetOperation(s.desop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
	end
end
function s.repfilter(c)
	return c:IsAbleToDeck() and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
--[[function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and Duel.IsExistingMatchingCard(s.repfilter,tp,LOCATION_HAND,0,1,c) end
	if Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,s.repfilter,tp,LOCATION_HAND,0,1,1,c)
		Duel.SetTargetCard(g)
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_EFFECT+REASON_REPLACE)
end]]--
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc and tc:IsRelateToBattle() then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function s.desfilter(c,s,tp)
	return math.abs(c:GetSequence()-s)==1 and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function s.sdcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(s.desfilter,1,nil,e:GetHandler():GetSequence(),tp)
end
function s.sdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.sdop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffectLabel(tp,id)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+id,re,r,rp,ep,ev)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetOperation(s.trop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	Duel.SetFlagEffectLabel(tp,id,ct+1)
	if e:GetHandler():IsRelateToEffect(e) then Duel.Destroy(e:GetHandler(),REASON_EFFECT) end
end
function s.trop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(e:GetOwner(),EVENT_CUSTOM+id,re,r,rp,ep,ev)
end
function s.geop(e,tp,eg,ep,ev,re,r,rp)
	if not s.Atori_Check then
		s.Atori_Check=true
		Duel.RegisterFlagEffect(0,id,0,0,0,0)
		Duel.RegisterFlagEffect(1,id,0,0,0,0)
		s.OAe={}
		s.EvadeAe={}
		s.AcAe={}
		Atori_GetActivateEffect=Card.GetActivateEffect
		Card.GetActivateEffect=function(ac)
			local le={Atori_GetActivateEffect(ac)}
			local res=true
			while res do
				res=false
				for k,v in pairs(le) do if SNNM.IsInTable(v,s.EvadeAe) then table.remove(le,k) res=true break end end
			end
			return table.unpack(le)
		end
		Atori_CheckActivateEffect=Card.CheckActivateEffect
		Card.CheckActivateEffect=function(ac,...)
			local le={Atori_CheckActivateEffect(ac,...)}
			local res=true
			while res do
				res=false
				for k,v in pairs(le) do if SNNM.IsInTable(v,s.EvadeAe) then table.remove(le,k) res=true break end end
			end
			return table.unpack(le)
		end
	end
	--[[local wdc=true
	while wdc do
		wdc=false
		for k,v in pairs(s.OAe) do
			if not v then
				local re1=s.EvadeAe[k]
				local re2=s.AcAe[k]
				table.remove(s.OAe,k)
				table.remove(s.EvadeAe,k)
				table.remove(s.AcAe,k)
				re1:Reset()
				re2:Reset()
				res=true
				break
			end
		end
	end--]]
	local g=Duel.GetMatchingGroup(function(c)return c:IsType(TYPE_TRAP) and c:GetActivateEffect() and c:IsSetCard(0x5534)end,0,LOCATION_DECK,LOCATION_DECK,nil)
	for tc in aux.Next(g) do
		local le={tc:GetActivateEffect()}
		--if ADIMI_GetActivateEffect then le={ADIMI_GetActivateEffect(tc)} end
		for i,v in pairs(le) do
			--if tc:IsCode(53766012) then Debug.Message(i) end
			if not SNNM.IsInTable(v,s.OAe) then
--Debug.Message(v:GetFieldID())
			table.insert(s.OAe,v)
			local e1=v:Clone()
			e1:SetRange(LOCATION_DECK)
			e1:SetHintTiming(TIMING_CHAIN_END)
			tc:RegisterEffect(e1,true)
			table.insert(s.EvadeAe,e1)
			local e2=SNNM.Act(tc,e1)
			e2:SetRange(LOCATION_DECK)
			e2:SetCost(s.costchk)
			e2:SetOperation(s.costop)
			tc:RegisterEffect(e2,true)
			table.insert(s.AcAe,e2)
			end
		end
	end
	--table.insert(s.OAe,Effect.GlobalEffect())
--local oae=s.OAe
--Debug.Message(#oae)
	--e:Reset()
end
function s.cfilter(c,code)
	return c:IsCode(code) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function s.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffectLabel(tp,id)
	return ct>0 and Duel.CheckEvent(EVENT_CUSTOM+id) and not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,e:GetHandler(),e:GetHandler():GetCode())
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffectLabel(tp,id)
	Duel.SetFlagEffectLabel(tp,id,ct-1)
	SNNM.BaseActOp(e,tp,eg,ep,ev,re,r,rp)
end
function s.adjust(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckEvent(EVENT_CUSTOM+id) then return end
	Duel.SetFlagEffectLabel(0,id,0)
	Duel.SetFlagEffectLabel(1,id,0)
end
