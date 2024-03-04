--魔导飞行队巡逻指令
local cm,m=GetID()
function cm.initial_effect(c)
	if not PNFL_PROPHECY_FLIGHT_CHECK then
		dofile("expansions/script/c11451851.lua")
		pnfl_prophecy_flight_initial(c)
	end
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_HAND)
	e2:SetOperation(cm.dsop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		cm.column=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	if not PNFL_MOVE_DELAY_CHECK then
		PNFL_MOVE_DELAY_CHECK=true
		local _Equip=Duel.Equip
		Duel.Equip=function(p,c,...)
			c:RegisterFlagEffect(11451848,RESET_CHAIN,0,1)
			local res=_Equip(p,c,...)
			c:ResetFlagEffect(11451848)
			return res
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		--e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCondition(cm.descon)
		e1:SetOperation(cm.desop2)
		Duel.RegisterEffect(e1,0)
		local e2=e1:Clone()
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(e2,0)
		local e3=e1:Clone()
		e3:SetCode(EVENT_MOVE)
		Duel.RegisterEffect(e3,0)
		local e4=e1:Clone()
		e4:SetCode(EVENT_CHAINING)
		e4:SetCondition(cm.descon3)
		e4:SetOperation(cm.desop3)
		Duel.RegisterEffect(e4,0)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_CANNOT_SUMMON)
		e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e5:SetTargetRange(1,1)
		e5:SetTarget(cm.costchk)
		Duel.RegisterEffect(e5,0)
	end
end
function cm.costchk(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_DUAL)~=SUMMON_TYPE_DUAL then return false end
	if c:GetFlagEffect(11451848)==0 then c:RegisterFlagEffect(11451848,RESET_EVENT+RESETS_STANDARD,0,1) end
	return false
end
function cm.filter12(c,e)
	if not (c:IsOnField() and (c:IsFacedown() or c:IsStatus(STATUS_EFFECT_ENABLED) or c:GetFlagEffect(11451848)>0)) then return false end
	if e:GetCode()==EVENT_MOVE then
		local b1,g1=Duel.CheckEvent(EVENT_SUMMON_SUCCESS,true)
		local b2,g2=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
		return (not b1 or not g1:IsContains(c)) and (not b2 or not g2:IsContains(c)) --and not c:IsPreviousLocation(LOCATION_ONFIELD)
	end
	return not (e:GetCode()==EVENT_SUMMON_SUCCESS and c:GetFlagEffect(11451848)>0)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	if 1==0 and eg:GetFirst():IsCode(m-3) and e:GetCode()==EVENT_MOVE then
		local c=eg:GetFirst()
		Debug.Message(cm.filter12(c,e))
		Debug.Message(not (c:IsOnField() and (c:IsFacedown() or c:IsStatus(STATUS_EFFECT_ENABLED))))
		Debug.Message(Duel.CheckEvent(EVENT_SUMMON_SUCCESS,true))
		Debug.Message(Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true))
		Debug.Message(not c:IsPreviousLocation(LOCATION_ONFIELD))
		Debug.Message(not (e:GetCode()==EVENT_SUMMON_SUCCESS and c:GetFlagEffect(11451848)>0))
	end
	return eg:IsExists(cm.filter12,1,nil,e)
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+11451848,re,r,rp,ep,ev)
end
function cm.descon3(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():GetFieldID()==re:GetHandler():GetRealFieldID()
end
function cm.desop3(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_ACTIVATING)
	--e1:SetCondition(function() return Duel.GetCurrentChain()==1 end)
	e1:SetOperation(function(e) Duel.RaiseEvent(eg,EVENT_CUSTOM+11451848,re,r,rp,ep,ev) end)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,0)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	--Duel.RegisterEffect(e2,0)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not re:IsHasCategory(CATEGORY_COIN) then return end
	local se=Effect.CreateEffect(e:GetHandler())
	se:SetType(EFFECT_TYPE_SINGLE)
	se:SetCode(0x20000000+m)
	se:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	se:SetReset(RESET_PHASE+PHASE_END,2)
	rc:RegisterEffect(se,true)
	--rc:RegisterFlagEffect(m,RESET_PHASE+PHASE_END,0,2)
	se:SetLabelObject(re)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetLabel(ev)
	e2:SetReset(RESET_CHAIN)
	e2:SetOperation(cm.resetop)
	Duel.RegisterEffect(e2,0)
end
function cm.resetop(e,tp,eg,ep,ev,re,r,rp)
	if ev==e:GetLabel() then re:GetHandler():ResetFlagEffect(m) end
end
function cm.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:GetHandler():IsSetCard(0x6e) or not c:IsSSetable() or cm.column~=0 or Duel.GetFlagEffect(tp,m)>0 then return end
	if Duel.SelectEffectYesNo(tp,c) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.SSet(tp,c,tp,true)
		c:RegisterFlagEffect(m-11,RESET_CHAIN,0,1)
		cm.thop(e,tp,eg,ep,ev,re,r,rp)
	end
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)>0 then return end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local fd=Duel.SelectField(tp,2,LOCATION_SZONE,0,~0x1f00)
	for i=0,4 do
		if fd&(1<<(8+i))>0 then
			local fd1=1<<(8+i)
			Duel.Hint(HINT_ZONE,tp,fd1)
			local fd2=fd
			if fd>=1<<16 then fd2=fd1>>16 else fd2=fd1<<16 end
			Duel.Hint(HINT_ZONE,1-tp,fd2)
			local cid=i+1
			if tp==1 then cid=5-i end
			cm.column=cm.column|(1<<cid)
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(m,i))
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e3:SetCode(EVENT_MOVE)
			e3:SetLabel(i)
			e3:SetCountLimit(1)
			e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
			e3:SetCondition(cm.thcon2)
			e3:SetTarget(cm.thtg2)
			e3:SetOperation(cm.thop2)
			Duel.RegisterEffect(e3,tp)
			local e4=e3:Clone()
			e4:SetType(EFFECT_TYPE_QUICK_F)
			e4:SetCode(EVENT_CUSTOM+11451848)
			e4:SetCondition(cm.thcon3)
			Duel.RegisterEffect(e4,tp)
			e3:SetLabelObject(e4)
			e4:SetLabelObject(e3)
		end
	end
end
function cm.clfilter(c,tp,i)
	return aux.GetColumn(c,tp)==i and not c:IsStatus(STATUS_SUMMONING) and c:GetFlagEffect(m-11)==0
end
function cm.clfilter2(c,tp,i)
	return aux.GetColumn(c,tp)==i
end
function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local i=e:GetLabel()
	local ng=Duel.GetMatchingGroup(cm.clfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,i)
	local res=#Group.__band(ng,eg)>0
	if res then
		local cid=i+1
		if tp==1 then cid=5-i end
		local cl=cm.column
		cm.column=cm.column&~(1<<cid)
		if cl~=0 and cm.column==0 then
			if SetCardData then
				Duel.Hint(24,0,aux.Stringid(m,8))
			else
				Debug.Message("「巡逻」最终目标确认！")
			end
		end
	end
	return res
end
function cm.thcon3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ((c:IsLocation(LOCATION_ONFIELD+LOCATION_REMOVED) and c:IsFacedown()) or c:GetOverlayTarget()) and cm.thcon2(e,tp,eg,ep,ev,re,r,rp)
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return true end
	local te=e:GetLabelObject()
	e:SetTarget(aux.FALSE)
	te:SetTarget(aux.FALSE)
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local ng=Duel.GetMatchingGroup(cm.clfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,e:GetLabel())
	local ag=ng:Filter(Card.IsCanBeEffectTarget,e)
	if #ag>0 then Duel.SetTargetCard(ag) end
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g then return end
	g=g:Filter(Card.IsRelateToEffect,nil,e)
	if #g==0 then return end
	g:KeepAlive()
	g:ForEach(Card.RegisterFlagEffect,m-10,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,10))
	for tc in aux.Next(g) do
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_SINGLE)
		ge2:SetCode(EFFECT_IMMUNE_EFFECT)
		ge2:SetRange(0x1c)
		ge2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		ge2:SetLabelObject(g)
		ge2:SetOwnerPlayer(tp)
		ge2:SetValue(cm.chkval)
		ge2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		tc:RegisterEffect(ge2,true)
	end
end
function cm.shfilter(c)
	return c:GetFlagEffect(m)>0
end
function cm.chkval(e,te)
	if e:GetHandler():GetFlagEffect(m-10)>0 and te and te:GetHandler() and not te:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) and (te:GetCode()<0x10000 or te:IsHasType(EFFECT_TYPE_ACTIONS)) then
		local tp=e:GetOwnerPlayer()
		local g=e:GetLabelObject()
		g:ForEach(Card.ResetFlagEffect,m-10)
		if SetCardData then
			Duel.Hint(24,0,aux.Stringid(m,7))
		else
			Debug.Message("「巡逻」任务完成！")
		end
		local e3=Effect.CreateEffect(e:GetOwner())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_ADJUST)
		e3:SetCondition(function() return not pnfl_adjusting end) --error.
		e3:SetOperation(cm.tdop)
		Duel.RegisterEffect(e3,tp)
	end
	return false
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	if pnfl_adjusting then return end
	pnfl_adjusting=true
	Duel.Hint(HINT_CARD,0,m)
	local sg=Duel.GetMatchingGroup(cm.shfilter,tp,0xff,0xff,nil)
	if #sg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,5))
	local tc=sg:Select(tp,1,1,nil):GetFirst()
	Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
	local eset={tc:IsHasEffect(0x20000000+m)}
	local te=eset[1]:GetLabelObject()
	if #eset>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,6))
		local ct=Duel.AnnounceNumber(tp,table.unpack(aux.idx_table,1,#eset))
		te=eset[ct]:GetLabelObject()
	end
	local tg=te:GetTarget() or aux.TRUE
	local op=te:GetOperation() or aux.TRUE
	tg(e,tp,eg,ep,ev,re,r,rp,1)
	op(e,tp,eg,ep,ev,re,r,rp) --recursive!!!
	e:Reset()
	pnfl_adjusting=false
end