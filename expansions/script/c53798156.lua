if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	--Synchro Summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(id)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_ADJUST)
		ge0:SetOperation(s.geop)
		Duel.RegisterEffect(ge0,0)
	end
	SNNM.ActivatedAsSpellorTrapCheck(c)
end
function s.geop(e,tp,eg,ep,ev,re,r,rp)
	--Debug.Message(1111)
	if not s.Iyo_Check then
	--[[Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	local tk=Duel.CreateToken(1,55144522)
	Duel.SendtoGrave(tk,REASON_EFFECT)
	tk=Duel.CreateToken(1,11429811)
	Duel.SendtoGrave(tk,REASON_EFFECT)--]]
		s.Iyo_Check=true
		s.OAe={}
		s.CAe={}
		s.GAe={}
		s.AdAe={}
		s.AcAe={}
	end
	--[[local wdc=true
	while wdc do
		wdc=false
		for k,v in pairs(s.OAe) do if not v then table.remove(s.OAe,k) s.CAe[k]:Reset() s.GAe[k]:Reset() s.AdAe[k]:Reset() s.AcAe[k]:Reset() table.remove(s.CAe,k) table.remove(s.GAe,k) table.remove(s.AdAe,k) table.remove(s.AcAe,k) res=true break end end
	end--]]
	local g=Duel.GetMatchingGroup(function(c)return c:IsType(TYPE_TRAP) and c:GetActivateEffect()end,0,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local ct=0
	for tc in aux.Next(g) do
		local le={tc:GetActivateEffect()}
		for i,v in pairs(le) do
			if v:GetRange()&0x2~=0 and not SNNM.IsInTable(v,s.OAe) then
			table.insert(s.OAe,v)
			local ctype=tc:GetType()
			local e1=v:Clone()
			local cd=v:GetCode()
			local pr1,pr2=v:GetProperty()
			if cd==EVENT_FREE_CHAIN or cd==EVENT_SUMMON or cd==EVENT_FLIP_SUMMON or cd==EVENT_SPSUMMON or cd==EVENT_CHAINING then
				if ctype&(TYPE_TRAP+TYPE_QUICKPLAY)~=0 then e1:SetType(EFFECT_TYPE_QUICK_O) else e1:SetType(EFFECT_TYPE_IGNITION) e1:SetCode(0) end
				e1:SetProperty(pr1|EFFECT_FLAG_BOTH_SIDE,pr2)
				table.insert(s.GAe,Effect.GlobalEffect())
			else
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
				e1:SetCode(0x160000000+id+cd+ct*100000)
				e1:SetCondition(aux.TRUE)
				local con=v:GetCondition()
				local tg=v:GetTarget()
				if not con then con=aux.TRUE end
				if not tg then tg=aux.TRUE end
				e1:SetTarget(s.chtg(tg))
				local ge1=Effect.CreateEffect(tc)
				ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				ge1:SetCode(cd)
				ge1:SetOperation(s.check(ct,con,tg))
				Duel.RegisterEffect(ge1,0)
				e1:SetProperty(pr1|EFFECT_FLAG_EVENT_PLAYER,pr2)
				ct=ct+1
				table.insert(s.GAe,ge1)
			end
			e1:SetRange(LOCATION_GRAVE)
			tc:RegisterEffect(e1,true)
			table.insert(s.CAe,e1)
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_ADJUST)
			e2:SetRange(LOCATION_GRAVE)
			e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetLabelObject(e1)
			e2:SetOperation(SNNM.AASTadjustop(ctype))
			tc:RegisterEffect(e2,true)
			table.insert(s.AdAe,e2)
			local e3=Effect.CreateEffect(tc)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_ACTIVATE_COST)
			e3:SetRange(LOCATION_GRAVE)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e3:SetTargetRange(1,1)
			e3:SetLabelObject(e1)
			e3:SetTarget(SNNM.AASTactarget)
			e3:SetCost(s.costchk(ctype))
			e3:SetOperation(SNNM.AdvancedActOp(ctype,s.costop))
			tc:RegisterEffect(e3,true)
			table.insert(s.AcAe,e3)
			end
		end
	end
end
function s.chtg(tg)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				if chkc then return tg(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
				if chk==0 then return true end
				tg(e,tp,eg,ep,ev,re,r,rp,1)
			end
end
function s.check(i,con,tg)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				if con(e,0,eg,ep,ev,re,r,rp) and tg(e,0,eg,ep,ev,re,r,rp,0) then Duel.RaiseEvent(eg,0x160000000+id+e:GetCode()+i*100000,re,r,rp,0,0) end
				if con(e,1,eg,ep,ev,re,r,rp) and tg(e,1,eg,ep,ev,re,r,rp,0) then Duel.RaiseEvent(eg,0x160000000+id+e:GetCode()+i*100000,re,r,rp,1,0) end
			end
end
function s.costchk(ctype)
	return  function(e,te_or_c,tp)
				local p=1-e:GetHandler():GetControler()
				return (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or ctype&TYPE_FIELD~=0) and tp==p and Duel.IsPlayerAffectedByEffect(p,id)
			end
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetValue(LOCATION_REMOVED)
	e:GetHandler():RegisterEffect(e1,true)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function s.rfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsReleasableByEffect() and c:IsAbleToGrave() and not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function s.tgfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToGrave()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and (b1 or b2) end
end
--Refer to [Source 1]: Burying (Redirect logic)
function s.redirect_fun(c,e,tp,eg,ep,ev,re,r,rp)
	local a=e:GetHandler()
	local e3=Effect.CreateEffect(a)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TO_DECK_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e3:SetValue(LOCATION_GRAVE)
	c:RegisterEffect(e3,true)
end
--Refer to [Source 6]: General Probe (Held effect definition)
function s.aclimit(e,re,tp)
	return re:GetHandler()==e:GetHandler() and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.rfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	
	--Apply redirect to send to opponent's GY via Deck [Source 1]
	s.redirect_fun(tc,e,tp,eg,ep,ev,re,r,rp)
	
	--SendtoDeck with REASON_RELEASE to simulate Tribute [Source 1]
	--1-tp sends to opponent's Deck, which redirects to opponent's GY
	if Duel.SendtoDeck(tc,1-tp,2,REASON_EFFECT+REASON_RELEASE)>0 and tc:IsLocation(LOCATION_GRAVE) then
		--Effects negated [Source 5]
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e2)
		
		--Neither player can activate effects held by that card
		--Using EFFECT_CANNOT_ACTIVATE with range and filter to exclude EFFECT_TYPE_ACTIVATE
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetRange(LOCATION_GRAVE)
		e3:SetTargetRange(1,1)
		e3:SetValue(s.aclimit)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3,true)
		
		--Select Option [Source 2]
		local b1=Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
		local b2=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(id,1))
		elseif b2 then
			op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
		else
			return
		end
		
		if op==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
			if sg:GetCount()>0 then
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
			if dg:GetCount()>0 then
				Duel.HintSelection(dg)
				Duel.Destroy(dg,REASON_EFFECT)
			end
		end
	end
end