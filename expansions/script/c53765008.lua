if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local m=53765008
local cm=_G["c"..m]
cm.name="枷狱首席执行官 路西法"
cm.AD_Ht=true
function cm.initial_effect(c)
	SNNM.AllEffectReset(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	c:RegisterEffect(e1)
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1_1:SetCode(53765098)
	e1_1:SetRange(LOCATION_HAND)
	e1_1:SetLabelObject(e1)
	c:RegisterEffect(e1_1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetLabelObject(e1)
	e2:SetOperation(cm.adjustop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetTargetRange(1,1)
	e3:SetLabelObject(e1)
	e3:SetTarget(cm.actarget)
	e3:SetCost(cm.costchk)
	e3:SetOperation(cm.costop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(53765000)
	e4:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(53765000)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(1,0)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsSummonLocation,LOCATION_SZONE))
	e6:SetValue(cm.atkval)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetValue(cm.efilter)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetCode(m)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(1,0)
	e9:SetValue(cm.imuval)
	c:RegisterEffect(e9)
	e8:SetLabelObject(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_ADJUST)
	e10:SetRange(LOCATION_MZONE)
	e10:SetLabelObject(e8)
	e10:SetOperation(cm.imuct)
	c:RegisterEffect(e10)
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(m,3))
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e11:SetCode(EVENT_PHASE+PHASE_END)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1)
	e11:SetTarget(cm.pltg)
	e11:SetOperation(cm.plop)
	c:RegisterEffect(e11)
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ex:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ex:SetCode(EVENT_MOVE)
	ex:SetOperation(cm.mvhint)
	c:RegisterEffect(ex)
	if not cm.global_check then
		cm.global_check=true
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_ADJUST)
		ge3:SetOperation(cm.mvcount)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge3:Clone()
		Duel.RegisterEffect(ge4,1)
	end
	if not AD_Helltaker_Check then
		AD_Helltaker_Check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(cm.mvop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
		cm[1]=Card.GetActivateEffect
		Card.GetActivateEffect=function(ac)
			local le={cm[1](ac)}
			local xe={ac:IsHasEffect(53765098)}
			local ae=nil
			for _,v in pairs(xe) do ae=v:GetLabelObject() end
			if ae then
				le={ae}
				local xe1=cm.regi(ac,ae)
			end
			return table.unpack(le)
		end
		cm[2]=Card.IsType
		Card.IsType=function(rc,type)
			local res=cm[2](rc,type)
			if type&(TYPE_TRAP+TYPE_CONTINUOUS)~=0 and rc:IsHasEffect(53765099) then return true else return res end
		end
		cm[3]=Card.GetType
		Card.GetType=function(rc)
			if rc:IsHasEffect(53765099) then return TYPE_TRAP+TYPE_CONTINUOUS else return cm[3](rc) end
		end
		cm[4]=Effect.IsHasType
		Effect.IsHasType=function(re,type)
			local res=cm[4](re,type)
			local rc=re:GetHandler()
			local xe={rc:IsHasEffect(53765099)}
			local b=false
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true end end
			if b then
				if type&EFFECT_TYPE_ACTIVATE~=0 then return true else return false end
			else return res end
		end
		cm[5]=Effect.GetType
		Effect.GetType=function(re)
			local rc=re:GetHandler()
			local xe={rc:IsHasEffect(53765099)}
			local b=false
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true end end
			if b then return EFFECT_TYPE_ACTIVATE else return cm[5](re) end
		end
		cm[6]=Effect.IsActiveType
		Effect.IsActiveType=function(re,type)
			local res=cm[6](re,type)
			local rc=re:GetHandler()
			local xe={rc:IsHasEffect(53765099)}
			local b=false
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true end end
			if b then
				if type&(TYPE_TRAP+TYPE_CONTINUOUS)~=0 then return true else return false end
			else return res end
		end
		cm[7]=Effect.GetActiveType
		Effect.GetActiveType=function(re)
			local rc=re:GetHandler()
			local xe={rc:IsHasEffect(53765099)}
			local b=false
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true end end
			if b then return 0x20004 else return cm[7](re) end
		end
		cm[8]=Duel.MoveToField
		Duel.MoveToField=function(sc,mp,tp,dest,pos,bool,zone)
			local czone=zone or 0xff
			if ad_ht_fr then czone=ad_ht_fr end
			return cm[8](sc,mp,tp,dest,pos,bool,czone)
		end
		cm[9]=Duel.GetLocationCount
		Duel.GetLocationCount=function(tp,loc,...)
			local ct=cm[9](tp,loc,...)
			if ad_ht_zc then ct=ct+ad_ht_zc end
			return ct
		end
		cm[10]=Effect.IsActivatable
		Effect.IsActivatable=function(re,tp,...)
			local res=cm[10](re,tp,...)
			if cm[9](tp,LOCATION_SZONE)<1 and ad_ht_ac_ignz then
				local b=true
				local pe={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)}
				for _,v in pairs(pe) do
					local val=v:GetValue()
					if aux.GetValueType(val)=="number" or val(v,re,tp) then b=false end
				end
				return b
			else return res end
		end
	end
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local c=te:GetHandler()
	local xe={c:IsHasEffect(53765099)}
	for _,v in pairs(xe) do v:Reset() end
	local p=te:GetHandlerPlayer()
	local pe={Duel.IsPlayerAffectedByEffect(p,EFFECT_CANNOT_ACTIVATE)}
	local ae={Duel.IsPlayerAffectedByEffect(p,EFFECT_ACTIVATE_COST)}
	local t1,t2={},{}
	for _,v in pairs(pe) do
		local val=v:GetValue()
		if aux.GetValueType(val)=="number" or val(v,te,p) then
			table.insert(t1,v)
			table.insert(t2,1)
		end
	end
	for _,v in pairs(ae) do
		local cost=v:GetCost()
		if not v:GetLabelObject() and cost and not cost(v,te,p) then
			local tg=v:GetTarget()
			if not tg or tg(v,te,p) then
				table.insert(t1,v)
				table.insert(t2,2)
			end
		end
	end
	local xe1=cm.regi(c,te)
	local t3,t4={},{}
	for _,v in pairs(pe) do
		local val=v:GetValue()
		if aux.GetValueType(val)=="number" or val(v,te,p) then
			table.insert(t3,v)
			table.insert(t4,1)
		end
	end
	for _,v in pairs(ae) do
		local cost=v:GetCost()
		if not v:GetLabelObject() and cost and not cost(v,te,p) then
			local tg=v:GetTarget()
			if not tg or tg(v,te,p) then
				table.insert(t3,v)
				table.insert(t4,2)
			end
		end
	end
	xe1:Reset()
	local ret1,ret2={},{}
	for k,v1 in pairs(t1) do
		local equal=false
		for _,v2 in pairs(t3) do
			if v1==v2 then
				equal=true
				break
			end
		end
		if not equal then
			table.insert(ret1,v1)
			table.insert(ret2,t2[k])
		end
	end
	local ret3,ret4={},{}
	for k,v1 in pairs(t3) do
		local equal=false
		for _,v2 in pairs(t1) do
			if v1==v2 then
				equal=true
				break
			end
		end
		if not equal then
			table.insert(ret3,v1)
			table.insert(ret4,t4[k])
		end
	end
	for k,v in pairs(ret1) do
		if ret2[k]==1 then
			local val=v:GetValue()
			if aux.GetValueType(val)=="number" then val=aux.TRUE end
			if val(v,te,p) then
				v:SetValue(cm.chval(val,false,te))
			end
		end
		if ret2[k]==2 then
			local cost=v:GetCost()
			if not v:GetLabelObject() and cost and not cost(v,te,p) then
				local tg=v:GetTarget()
				if not tg then
					v:SetTarget(cm.chtg(aux.TRUE,false,te))
				elseif tg(v,te,p) then
					v:SetTarget(cm.chtg(tg,false,te))
				end
			end
		end
	end
	local xe1=cm.regi(c,te)
	for k,v in pairs(ret3) do
		if ret4[k]==1 then
			local val=v:GetValue()
			if aux.GetValueType(val)=="number" then val=aux.TRUE end
			if val(v,te,p) then
				v:SetValue(cm.chval(val,true,te))
			end
		end
		if ret4[k]==2 then
			local cost=v:GetCost()
			if not v:GetLabelObject() and cost and not cost(v,te,p) then
				local tg=v:GetTarget()
				if not tg then
					v:SetTarget(cm.chtg(aux.TRUE,true,te))
				elseif tg(v,te,p) then
					v:SetTarget(cm.chtg(tg,true,te))
				end
			end
		end
	end
	xe1:Reset()
end
function cm.bchval(_val,te)
	return function(e,re,...)
				if re==te then return false end
				return _val(e,re,...)
			end
end
function cm.chval(_val,res,te)
	return function(e,re,...)
				if re==te then return res end
				return _val(e,re,...)
			end
end
function cm.chtg(_tg,res,te)
	return function(e,re,...)
				if re==te then return res end
				return _tg(e,re,...)
			end
end
function cm.actarget(e,te,tp)
	return te:GetHandler()==e:GetHandler() and te==e:GetLabelObject()
end
function cm.costchk(e,te,tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local c=te:GetHandler()
	local xe1=cm.regi(c,te)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_TYPE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(0x20004)
	c:RegisterEffect(e0,true)
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:CreateEffectRelation(te)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ev==ev0 end)
	e1:SetOperation(cm.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	e3:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetReset(RESET_CHAIN)
	c:RegisterEffect(e3)
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVING and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
		rc:CancelToGrave(false)
	end
	local xe={rc:IsHasEffect(53765099)}
	for _,v in pairs(xe) do if v:GetLabelObject()==re then v:Reset() end end
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0xff,0,nil)
	for c in aux.Next(g) do
		local rse={c:IsHasEffect(53765050)}
		for _,v in pairs(rse) do
			if v:GetLabelObject():GetLabelObject() then v:GetLabelObject():GetLabelObject():Reset() end
			if v:GetLabelObject() then v:GetLabelObject():Reset() end
			v:Reset()
		end
	end
	if not Duel.IsPlayerAffectedByEffect(tp,53765000) then return end
	g=Duel.GetMatchingGroup(function(c)return c:GetActivateEffect() and not c:GetActivateEffect():IsActiveType(TYPE_FIELD)end,tp,LOCATION_HAND,0,nil)
	for c in aux.Next(g) do
		local le={c:GetActivateEffect()}
		for _,te in pairs(le) do
			if te:GetRange()==0x10a or te:GetRange()==0xa or te:GetRange()==0x2 then
				local e1=te:Clone()
				e1:SetDescription(aux.Stringid(m,1))
				if te:GetCode()==EVENT_FREE_CHAIN then
					if te:IsActiveType(TYPE_TRAP+TYPE_QUICKPLAY) then e1:SetType(EFFECT_TYPE_QUICK_O) else e1:SetType(EFFECT_TYPE_IGNITION) end
				elseif te:GetCode()==EVENT_CHAINING then e1:SetType(EFFECT_TYPE_QUICK_O) elseif te:GetCode() then e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) end
				e1:SetRange(LOCATION_HAND)
				local pro,pro2=te:GetProperty()
				e1:SetProperty(pro|EFFECT_FLAG_UNCOPYABLE,pro2)
				c:RegisterEffect(e1,true)
				local pe={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)}
				for _,v in pairs(pe) do
					local val=v:GetValue()
					if aux.GetValueType(val)=="number" then val=aux.TRUE end
					v:SetValue(cm.bchval(val,e1))
				end
				local zone=0xff
				if te:IsActiveType(TYPE_PENDULUM) then zone=0x11 end
				if te:IsHasProperty(EFFECT_FLAG_LIMIT_ZONE) then
					zone=te:GetValue()
					if aux.GetValueType(zone)=="function" then zone=zone(te,tp,eg,ep,ev,re,r,rp) end
				end
				local fcheck=false
				local fe={Duel.IsPlayerAffectedByEffect(0,53765050)}
				for _,v in pairs(fe) do
					local ae=v:GetLabelObject()
					if ae:GetLabelObject() and ae:GetLabelObject()==te and ae:GetCode() and ae:GetCode()==EFFECT_ACTIVATE_COST and ae:GetRange()&LOCATION_HAND~=0 then
						fcheck=true
						local e2=ae:Clone()
						e2:SetLabelObject(e1)
						e2:SetTarget(cm.actarget)
						local cost=ae:GetCost()
						if not cost then cost=aux.TRUE end
						e2:SetCost(cm.faccost(cost,te,zone))
						local op=ae:GetOperation()
						e2:SetOperation(cm.fcostop(op,zone))
						c:RegisterEffect(e2,true)
						local ex=Effect.CreateEffect(c)
						ex:SetType(EFFECT_TYPE_SINGLE)
						ex:SetCode(53765050)
						ex:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
						ex:SetLabelObject(e2)
						c:RegisterEffect(ex,true)
					end
				end
				if not fcheck then
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_FIELD)
					e2:SetCode(EFFECT_ACTIVATE_COST)
					e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetRange(LOCATION_HAND)
					e2:SetTargetRange(1,0)
					e2:SetTarget(cm.actarget)
					e2:SetCost(cm.faccost(aux.TRUE,te,zone))
					e2:SetOperation(cm.fcostop(cm.mvcostop,zone))
					e2:SetLabelObject(e1)
					c:RegisterEffect(e2,true)
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(53765050)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
					e3:SetLabelObject(e2)
					c:RegisterEffect(e3,true)
				end
			end
		end
	end
end
function cm.faccost(_cost,fe,zone)
	return function(e,te,tp)
				ad_ht_zc=1
				ad_ht_ac_ignz=true
				if not fe:IsActivatable(tp) then
					ad_ht_zc=nil
					ad_ht_ac_ignz=nil
					return false
				end
				ad_ht_ac_ignz=nil
				local c=e:GetHandler()
				local xe={c:IsHasEffect(53765099)}
				for _,v in pairs(xe) do v:Reset() end
				if c:IsType(TYPE_QUICKPLAY) and Duel.GetTurnPlayer()~=tp and not c:IsHasEffect(EFFECT_QP_ACT_IN_NTPHAND) then return false end
				if c:IsType(TYPE_TRAP) and not c:IsHasEffect(EFFECT_TRAP_ACT_IN_HAND) then return false end
				if not c:CheckUniqueOnField(tp) then return false end
				if not Duel.IsExistingMatchingCard(cm.mvfilter,tp,LOCATION_SZONE,0,1,nil,e,tp,zone) then
					ad_ht_zc=nil
					return false
				end
				local res=false
				if _cost(e,te,tp) then res=true end
				ad_ht_zc=nil
				return res
			end
end
function cm.fcostop(_op,zone)
	return function(e,tp,eg,ep,ev,re,r,rp)
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
				local tc=Duel.SelectMatchingCard(tp,cm.mvfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp,zone):GetFirst()
				local seq=tc:GetSequence()
				if seq>0 and Duel.CheckLocation(tp,LOCATION_SZONE,seq-1) then Duel.MoveSequence(tc,seq-1) else Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,1<<seq) end
				ad_ht_fr=1<<seq
				_op(e,tp,teg,tep,tev,tre,tr,trp)
				ad_ht_fr=nil
			end
end
function cm.mvfilter(c,e,tp,zone)
	local seq=c:GetSequence()
	return c:IsHasEffect(53765000) and ((seq>0 and Duel.CheckLocation(tp,LOCATION_SZONE,seq-1)) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,1<<seq)) and (1<<seq)&zone~=0
end
function cm.mvcostop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local c=te:GetHandler()
	local xe1=cm.regi(c,te)
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	c:CreateEffectRelation(te)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ev==ev0 end)
	e1:SetOperation(cm.mvrsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
	ad_ht_fr=nil
end
function cm.mvrsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local xe={rc:IsHasEffect(53765099)}
	for _,v in pairs(xe) do v:Reset() end
	if e:GetCode()==EVENT_CHAIN_SOLVING and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
		if not rc:IsType(TYPE_CONTINUOUS+TYPE_EQUIP+TYPE_PENDULUM) and not rc:IsHasEffect(EFFECT_REMAIN_FIELD) then rc:CancelToGrave(false) end
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
		rc:CancelToGrave(false)
	end
	if re then re:Reset() end
end
function cm.regi(c,e)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(53765099)
	e1:SetLabelObject(e)
	c:RegisterEffect(e1,true)
	return e1
end
function cm.mvhint(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsLocation(LOCATION_SZONE) and c:IsPreviousLocation(LOCATION_SZONE) and (c:GetPreviousSequence()~=c:GetSequence() or c:GetPreviousControler()~=c:GetControler())) then return end
	local flag=c:GetFlagEffectLabel(m+50)
	if flag then
		flag=flag+1
		c:ResetFlagEffect(m+50)
		c:RegisterFlagEffect(m+50,RESET_EVENT+0x7e0000,EFFECT_FLAG_CLIENT_HINT,1,flag,aux.Stringid(53765000,flag-1))
	else c:RegisterFlagEffect(m+50,RESET_EVENT+0x7e0000,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(53765000,0)) end
end
function cm.atkval(e,c)
	local flag=e:GetHandler():GetFlagEffectLabel(m+50) or 0
	return flag*500
end
function cm.imuval(e,c)
	return e:GetHandler():GetFlagEffectLabel(m+50) or 0
end
function cm.imuct(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NOT(Card.IsImmuneToEffect),tp,LOCATION_MZONE,0,nil,e:GetLabelObject())
	local re=e:GetLabelObject():GetLabelObject()
	for tc in aux.Next(g) do
		local pe={Duel.IsPlayerAffectedByEffect(tp,m)}
		local ct=0
		for _,v1 in pairs(pe) do
			local val=v1:GetValue()
			local ct3=0
			if v1==re then ct3=val(v1,tc) end
			local ce={tc:IsHasEffect(m)}
			local ct1=0
			for _,v2 in pairs(ce) do
				if v2:GetLabelObject()==v1 then ct1=v2:GetLabel() end
			end
			local ct2=ct3-ct1
			ct=math.max(ct,ct2)
		end
		tc:ResetFlagEffect(m)
		if ct>0 then tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,ct+5)) end
	end
end
function cm.efilter(e,te,c)
	local tp=e:GetHandlerPlayer()
	if te:GetHandlerPlayer()==tp or not te:IsActivated() or Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)&LOCATION_ONFIELD==0 then return false end
	local re=e:GetLabelObject()
	local ct=0
	local pe={Duel.IsPlayerAffectedByEffect(tp,m)}
	for _,v in pairs(pe) do
		local val=v:GetValue()
		if v==re then ct=val(v,c) end
	end
	if ct<1 then return false end
	local ce={c:IsHasEffect(m)}
	local res=true
	for _,v in pairs(ce) do
		if v:GetLabelObject()==re and v:GetLabel()>=ct then res=false end
	end
	if not res then return false end
	for _,v1 in pairs(pe) do
		local ce={c:IsHasEffect(m)}
		local flag=0
		for _,v2 in pairs(ce) do
			if v2:GetLabelObject()==v1 then
				flag=v2:GetLabel()
				v2:Reset()
			end
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(m)
		e1:SetLabel(flag+1)
		e1:SetLabelObject(v1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
	end
	return true
end
function cm.mvcount(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_MZONE,0,nil,m)
	local adjust=false
	for tc in aux.Next(g) do
		local ce={tc:IsHasEffect(m)}
		for _,v1 in pairs(ce) do
			local re=v1:GetLabelObject()
			local pe={Duel.IsPlayerAffectedByEffect(tp,m)}
			local res=false
			for _,v2 in pairs(pe) do if v2==re then res=true end end
			if not res then
				adjust=true
				tc:ResetFlagEffect(m)
				v1:Reset()
			end
		end
	end
	if adjust then Duel.Readjust() end
end
function cm.plfilter(c)
	return c:IsSetCard(0xc530) and c:IsType(TYPE_MONSTER) and not c:IsForbidden() and not Duel.IsExistingMatchingCard(function(c,cd)return c:IsFaceup() and c:IsCode(cd)end,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,c:GetCode())
end
function cm.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.plfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cm.opfilter(c)
	local seq,loc=c:GetSequence(),0
	if c:IsLocation(LOCATION_MZONE) then loc=LOCATION_MZONE else loc=LOCATION_SZONE end
	return ((seq<5 and ((seq>0 and Duel.CheckLocation(tp,loc,seq-1)) or (seq<4 and Duel.CheckLocation(tp,loc,seq+1)))) or c:IsAbleToHand()) and not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function cm.plop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,cm.plfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		if Duel.IsExistingMatchingCard(cm.opfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			local sg=Duel.SelectMatchingCard(tp,cm.opfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
			Duel.HintSelection(sg)
			local sc=sg:GetFirst()
			local seq,loc=sc:GetSequence(),0
			if sc:IsLocation(LOCATION_MZONE) then loc=LOCATION_MZONE else loc=LOCATION_SZONE end
			if ((seq>0 and Duel.CheckLocation(tp,loc,seq-1)) or (seq<4 and Duel.CheckLocation(tp,loc,seq+1))) and (not sc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(m,5))) then
				local flag=0
				local ct=(sc:IsLocation(LOCATION_MZONE) and 0) or 8
				if seq>0 and Duel.CheckLocation(tp,loc,seq-1) then flag=bit.replace(flag,0x1,seq-1+ct) end
				if seq<4 and Duel.CheckLocation(tp,loc,seq+1) then flag=bit.replace(flag,0x1,seq+1+ct) end
				flag=bit.bxor(flag,0xffff)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
				local s=Duel.SelectDisableField(tp,1,loc,0,flag)
				local nseq=math.log(s,2)
				if nseq>7 then nseq=nseq-8 end
				Duel.MoveSequence(sc,nseq)
			else
				Duel.SendtoHand(sc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sc)
			end
		end
	end
end
