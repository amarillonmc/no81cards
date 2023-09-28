local m=53757009
local cm=_G["c"..m]
cm.name="次元秽界 冽"
if not require and Duel.LoadScript then
    function require(str)
        local name=str
        for word in string.gmatch(str,"%w+") do
            name=word
        end
        Duel.LoadScript(name..".lua")
        return true
    end
end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetSequence()<5
	end)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetLabelObject(e2)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetLabelObject():GetHandler()
		return c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5
	end)
	e3:SetOperation(cm.adjustop)
	Duel.RegisterEffect(e3,0)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetTargetRange(1,1)
	e4:SetLabelObject(e3)
	e4:SetTarget(cm.actarget)
	e4:SetOperation(cm.costop)
	Duel.RegisterEffect(e4,0)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_SEND_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetLabelObject(c)
	e5:SetTarget(cm.reptarget)
	e5:SetValue(cm.repval)
	e5:SetOperation(cm.repoperation)
	Duel.RegisterEffect(e5,0)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_ACTIVATE_COST)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e6:SetTargetRange(1,1)
	e6:SetLabelObject(c)
	e6:SetTarget(cm.actarget2)
	e6:SetOperation(cm.repoperation)
	Duel.RegisterEffect(e6,0)
	local e6_1=Effect.CreateEffect(c)
	e6_1:SetType(EFFECT_TYPE_FIELD)
	e6_1:SetCode(EFFECT_SSET_COST)
	e6_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e6_1:SetTargetRange(0xff,0xff)
	e6_1:SetLabelObject(c)
	e6_1:SetTarget(cm.actarget3)
	e6_1:SetOperation(cm.repoperation)
	Duel.RegisterEffect(e6_1,0)
	SNNM.Global_in_Initial_Reset(c,{e3,e4,e5,e6,e6_1})
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(m)
	e7:SetCondition(function(e)
		local c=e:GetHandler()
		return c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5
	end)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(53757000)
	e8:SetCondition(function(e)
		return e:GetHandler():IsLocation(LOCATION_SZONE)
	end)
	e8:SetLabelObject(e2)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(m,2))
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e9:SetProperty(EFFECT_FLAG_DELAY)
	e9:SetCode(EVENT_MOVE)
	e9:SetRange(LOCATION_FZONE)
	e9:SetCondition(cm.pcon)
	e9:SetTarget(cm.ptg)
	e9:SetOperation(cm.pop)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_CHAINING)
	e10:SetRange(LOCATION_SZONE)
	e10:SetCondition(cm.cpcon)
	e10:SetOperation(cm.record)
	c:RegisterEffect(e10)
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(m,3))
	e11:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e11:SetCode(EVENT_CHAINING)
	e11:SetRange(LOCATION_SZONE)
	e11:SetCountLimit(1)
	e11:SetCondition(cm.cpcon)
	e11:SetTarget(cm.cptg)
	e11:SetOperation(cm.cpop)
	c:RegisterEffect(e11)
	if not Goron_Dimension_Check then
		Goron_Dimension_Check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetCondition(cm.accon)
		ge1:SetOperation(cm.acop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(4179255)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetProperty(EFFECT_FLAG_DELAY)
		ge3:SetCode(EVENT_MOVE)
		ge3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local g=Duel.GetMatchingGroup(nil,0,0xff,0xff,nil)
			g:ForEach(Card.ResetFlagEffect,53757050)
		end)
		Duel.RegisterEffect(ge3,0)
		cm[1]=Card.GetActivateEffect
		Card.GetActivateEffect=function(ac)
			local le={cm[1](ac)}
			local res=true
			if ac:GetFlagEffect(53757050)>0 then
				res=false
				ac:ResetFlagEffect(53757050)
			end
			if res and ac:IsHasEffect(53757000) then
				local checke={ac:IsHasEffect(53757000)}
				local ae=checke[1]
				local ae1=ae:GetLabelObject()
				local ae2=ae1:GetLabelObject()
				for k,v in pairs(le) do
					if v==ae2 then
						table.insert(le,1,ae1)
						table.remove(le,k+1)
						break
					end
				end
			end
			return table.unpack(le)
		end
		cm[2]=Duel.SSet
		Duel.SSet=function(tp,tg,tgp,...)
			Dragoron_SSet_Check=true
			if not tgp then tgp=tp end
			tg=Group.__add(tg,tg)
			if tg:IsExists(Card.IsType,1,nil,TYPE_FIELD) then
				local fc=Duel.GetFieldCard(tgp,LOCATION_FZONE,0)
				if fc and fc:IsHasEffect(53757000) and Duel.GetLocationCount(tgp,LOCATION_SZONE)-tg:FilterCount(aux.NOT(Card.IsType),nil,TYPE_FIELD)>0 then
					Duel.Hint(HINT_SELECTMSG,tgp,HINTMSG_TOZONE)
					local mv=Duel.SelectDisableField(tgp,1,LOCATION_SZONE,0,0)
					Duel.MoveSequence(fc,math.log(mv,2)-8)
					if fc:IsFacedown() then Duel.ChangePosition(fc,POS_FACEUP) end
					local e1=Effect.CreateEffect(fc)
					e1:SetCode(EFFECT_CHANGE_TYPE)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
					fc:RegisterEffect(e1,true)
				end
			end
			local ct=cm[2](tp,tg,tgp,...)
			Dragoron_SSet_Check=false
			return ct
		end
		cm[3]=Effect.IsHasType
		Effect.IsHasType=function(re,type)
			local res=cm[3](re,type)
			local rc=re:GetHandler()
			local le={rc:IsHasEffect(53757000)}
			local b=false
			for _,v in pairs(le) do if re==v:GetLabelObject() then b=true end end
			if type&EFFECT_TYPE_ACTIVATE~=0 and b then return true else return res end
		end
		cm[4]=Effect.GetType
		Effect.GetType=function(re)
			local rc=re:GetHandler()
			local le={rc:IsHasEffect(53757000)}
			local b=false
			for _,v in pairs(le) do if re==v:GetLabelObject() then b=true end end
			if b then return EFFECT_TYPE_ACTIVATE else return cm[4](re,type) end
		end
		cm[5]=Effect.IsActiveType
		Effect.IsActiveType=function(re,type)
			local res=cm[5](re,type)
			local rc=re:GetHandler()
			local le={rc:IsHasEffect(53757000)}
			local b=false
			for _,v in pairs(le) do if re==v:GetLabelObject() or re==v:GetLabelObject():GetLabelObject() then b=true end end
			if type&TYPE_FIELD~=0 and b then return true else return res end
		end
		cm[6]=Effect.GetActiveType
		Effect.GetActiveType=function(re)
			local rc=re:GetHandler()
			local le={rc:IsHasEffect(53757000)}
			local b=false
			for _,v in pairs(le) do if re==v:GetLabelObject() or re==v:GetLabelObject():GetLabelObject() then b=true end end
			if b then return TYPE_SPELL+TYPE_FIELD else return cm[6](re) end
		end
		cm[7]=Duel.SendtoGrave
		Duel.SendtoGrave=function(tg,reason)
			tg=Group.__add(tg,tg)
			local g=Group.__band(tg,Duel.GetFieldGroup(tp,LOCATION_FZONE,LOCATION_FZONE))
			for fc in aux.Next(g) do
				local p=fc:GetControler()
				if fc and fc:IsHasEffect(53757000) and reason&REASON_RULE~=0 and Duel.GetLocationCount(p,LOCATION_SZONE)>0 then
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOZONE)
					local mv=Duel.SelectDisableField(p,1,LOCATION_SZONE,0,0)
					Duel.MoveSequence(fc,math.log(mv,2)-8)
					if fc:IsFacedown() then Duel.ChangePosition(fc,POS_FACEUP) end
					local e1=Effect.CreateEffect(fc)
					e1:SetCode(EFFECT_CHANGE_TYPE)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
					fc:RegisterEffect(e1)
					tg:RemoveCard(fc)
				end
			end
			return cm[7](tg,reason)
		end
		cm[8]=Duel.Destroy
		Duel.Destroy=function(tg,reason,...)
			tg=Group.__add(tg,tg)
			local g=Group.__band(tg,Duel.GetFieldGroup(tp,LOCATION_FZONE,LOCATION_FZONE))
			for fc in aux.Next(g) do
				local p=fc:GetControler()
				if fc and fc:IsHasEffect(53757000) and reason&REASON_RULE~=0 and Duel.GetLocationCount(p,LOCATION_SZONE)>0 then
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOZONE)
					local mv=Duel.SelectDisableField(p,1,LOCATION_SZONE,0,0)
					Duel.MoveSequence(fc,math.log(mv,2)-8)
					if fc:IsFacedown() then Duel.ChangePosition(fc,POS_FACEUP) end
					local e1=Effect.CreateEffect(fc)
					e1:SetCode(EFFECT_CHANGE_TYPE)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
					fc:RegisterEffect(e1)
					tg:RemoveCard(fc)
				end
			end
			return cm[8](tg,reason,...)
		end
		cm[9]=Duel.Remove
		Duel.Remove=function(tg,pos,reason)
			tg=Group.__add(tg,tg)
			local g=Group.__band(tg,Duel.GetFieldGroup(tp,LOCATION_FZONE,LOCATION_FZONE))
			for fc in aux.Next(g) do
				local p=fc:GetControler()
				if fc and fc:IsHasEffect(53757000) and reason&REASON_RULE~=0 and Duel.GetLocationCount(p,LOCATION_SZONE)>0 then
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOZONE)
					local mv=Duel.SelectDisableField(p,1,LOCATION_SZONE,0,0)
					Duel.MoveSequence(fc,math.log(mv,2)-8)
					if fc:IsFacedown() then Duel.ChangePosition(fc,POS_FACEUP) end
					local e1=Effect.CreateEffect(fc)
					e1:SetCode(EFFECT_CHANGE_TYPE)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
					fc:RegisterEffect(e1)
					tg:RemoveCard(fc)
				end
			end
			return cm[9](tg,pos,reason)
		end
		cm[10]=Duel.SendtoHand
		Duel.SendtoHand=function(tg,tp,reason)
			tg=Group.__add(tg,tg)
			local g=Group.__band(tg,Duel.GetFieldGroup(tp,LOCATION_FZONE,LOCATION_FZONE))
			for fc in aux.Next(g) do
				local p=fc:GetControler()
				if fc and fc:IsHasEffect(53757000) and reason&REASON_RULE~=0 and Duel.GetLocationCount(p,LOCATION_SZONE)>0 then
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOZONE)
					local mv=Duel.SelectDisableField(p,1,LOCATION_SZONE,0,0)
					Duel.MoveSequence(fc,math.log(mv,2)-8)
					if fc:IsFacedown() then Duel.ChangePosition(fc,POS_FACEUP) end
					local e1=Effect.CreateEffect(fc)
					e1:SetCode(EFFECT_CHANGE_TYPE)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
					fc:RegisterEffect(e1)
					tg:RemoveCard(fc)
				end
			end
			return cm[10](tg,tp,reason)
		end
		cm[11]=Duel.SendtoDeck
		Duel.SendtoDeck=function(tg,tp,seq,reason)
			tg=Group.__add(tg,tg)
			local g=Group.__band(tg,Duel.GetFieldGroup(tp,LOCATION_FZONE,LOCATION_FZONE))
			for fc in aux.Next(g) do
				local p=fc:GetControler()
				if fc and fc:IsHasEffect(53757000) and reason&REASON_RULE~=0 and Duel.GetLocationCount(p,LOCATION_SZONE)>0 then
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOZONE)
					local mv=Duel.SelectDisableField(p,1,LOCATION_SZONE,0,0)
					Duel.MoveSequence(fc,math.log(mv,2)-8)
					if fc:IsFacedown() then Duel.ChangePosition(fc,POS_FACEUP) end
					local e1=Effect.CreateEffect(fc)
					e1:SetCode(EFFECT_CHANGE_TYPE)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
					fc:RegisterEffect(e1)
					tg:RemoveCard(fc)
				end
			end
			return cm[11](tg,tp,seq,reason)
		end
		cm[12]=Effect.SetReset
		Effect.SetReset=function(re,reset,...)
			if reset&RESET_TOFIELD~=0 then Dragoron_Reset_Check=true end
			return cm[12](re,reset,...)
		end
		cm[13]=Card.RegisterEffect
		Card.RegisterEffect=function(rc,re,...)
			if Dragoron_Reset_Check then
				local e1=Effect.CreateEffect(rc)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_MOVE)
				e1:SetLabelObject(re)
				e1:SetCondition(cm.resetcon)
				e1:SetOperation(cm.resetop)
				Duel.RegisterEffect(e1,rp)
				Dragoron_Reset_Check=false
			end
			return cm[13](rc,re,...)
		end
		cm[14]=Duel.RegisterEffect
		Duel.RegisterEffect=function(...)
			Dragoron_Reset_Check=false
			return cm[14](...)
		end
		cm[15]=Duel.MoveToField
		Duel.MoveToField=function(mc,p,tgp,dest,...)
			mc:ResetFlagEffect(53757050)
			if dest==LOCATION_FZONE then mc:RegisterFlagEffect(53757050,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1) end
			return cm[15](mc,p,tgp,dest,...)
		end
		cm[16]=Duel.MoveSequence
		Duel.MoveSequence=function(mc,seq)
			mc:ResetFlagEffect(53757050)
			return cm[16](mc,seq)
		end
	end
end
function cm.resetfil(c,tc)
	return c==tc and ((c:IsPreviousLocation(LOCATION_FZONE) and not c:IsLocation(LOCATION_FZONE)) or (c:IsLocation(LOCATION_FZONE) and not c:IsPreviousLocation(LOCATION_FZONE)))
end
function cm.resetcon(e,tp,eg,ep,ev,re,r,rp)
	local re=e:GetLabelObject()
	if not re or aux.GetValueType(re)~="Effect" then
		e:Reset()
		return false
	end
	return eg:IsExists(cm.resetfil,1,nil,re:GetHandler())
end
function cm.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Reset()
	e:Reset()
end
function cm.accon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(rp,53757050)>0 then return end
	Duel.RegisterFlagEffect(rp,53757050,RESET_CHAIN,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetLabel(Duel.GetCurrentChain())
	e1:SetLabelObject(re)
	e1:SetOperation(cm.regop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,rp)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then Duel.RaiseSingleEvent(fc,EVENT_CUSTOM+53757099,e:GetLabelObject(),0,tp,tp,e:GetLabel()) end
	e:Reset()
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local c=te:GetHandler()
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
		if cost and not cost(v,te,p) then
			local tg=v:GetTarget()
			if not tg or tg(v,te,p) then
				table.insert(t1,v)
				table.insert(t2,2)
			end
		end
	end
	local de=te:GetLabelObject()
	local t3,t4={},{}
	for _,v in pairs(pe) do
		local val=v:GetValue()
		if aux.GetValueType(val)=="number" or val(v,de,p) then
			table.insert(t3,v)
			table.insert(t4,1)
		end
	end
	for _,v in pairs(ae) do
		local cost=v:GetCost()
		if cost and not cost(v,de,p) then
			local tg=v:GetTarget()
			if not tg or tg(v,de,p) then
				table.insert(t3,v)
				table.insert(t4,2)
			end
		end
	end
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
				v:SetValue(cm.chval(val,false,de))
			end
		end
		if ret2[k]==2 then
			local cost=v:GetCost()
			if cost and not cost(v,te,p) then
				local tg=v:GetTarget()
				if not tg then
					v:SetTarget(cm.chtg(aux.TRUE,false))
				elseif tg(v,te,p) then
					v:SetTarget(cm.chtg(tg,false))
				end
			end
		end
	end
	for k,v in pairs(ret3) do
		if ret4[k]==1 then
			local val=v:GetValue()
			if aux.GetValueType(val)=="number" then val=aux.TRUE end
			if val(v,de,p) then
				v:SetValue(cm.chval(val,true,de))
			end
		end
		if ret4[k]==2 then
			local cost=v:GetCost()
			if cost and not cost(v,de,p) then
				local tg=v:GetTarget()
				if not tg then
					v:SetTarget(cm.chtg(aux.TRUE,true))
				elseif tg(v,de,p) then
					v:SetTarget(cm.chtg(tg,true))
				end
			end
		end
	end
end
function cm.chval(_val,res,de)
	return function(e,re,...)
				local x=nil
				if aux.GetValueType(re)=="Effect" then x=re:GetHandler() elseif aux.GetValueType(re)=="Card" then
					re=de
					x=de:GetHandler()
				else return res end
				if x and x:IsHasEffect(m) then return res end
				return _val(e,re,...)
			end
end
function cm.chtg(_tg,res)
	return function(e,te,...)
				local x=te:GetHandler()
				if x:IsHasEffect(m) then return res end
				return _tg(e,te,...)
			end
end
function cm.actarget(e,te,tp)
	local ce=e:GetLabelObject():GetLabelObject()
	local c=ce:GetHandler()
	return te==ce and c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then Duel.SendtoGrave(fc,REASON_RULE) end
	local c=e:GetLabelObject():GetLabelObject():GetHandler()
	Duel.MoveSequence(c,5)
	if c:IsFacedown() then Duel.ChangePosition(c,POS_FACEUP) end
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_TYPE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(0x80002)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:RegisterEffect(e0,true)
	c:SetStatus(STATUS_EFFECT_ENABLED,false)
	local te=e:GetLabelObject():GetLabelObject()
	c:CreateEffectRelation(te)
	local te2=te:Clone()
	c:RegisterEffect(te2,true)
	e:GetLabelObject():SetLabelObject(te2)
	local le={c:IsHasEffect(53757000)}
	for _,v in pairs(le) do v:SetLabelObject(te2) end
	te:SetType(EFFECT_TYPE_ACTIVATE)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(cm.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVING and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
	re:Reset()
end
function cm.repfilter(c,tc)
	return c==tc and Duel.GetLocationCount(c:GetControler(),LOCATION_SZONE)>0 and c:IsLocation(LOCATION_FZONE)
end
function cm.reptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetLabelObject()
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,c) end
	return true
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetLabelObject())
end
function cm.repoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if not c:IsLocation(LOCATION_FZONE) then return end
	local p=c:GetControler()
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOZONE)
	local mv=Duel.SelectDisableField(p,1,LOCATION_SZONE,0,0)
	Duel.MoveSequence(c,math.log(mv,2)-8)
	if c:IsFacedown() then Duel.ChangePosition(c,POS_FACEUP) end
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
end
function cm.actarget2(e,te,tp)
	local c=e:GetLabelObject()
	local p=c:GetControler()
	return Duel.GetLocationCount(p,LOCATION_SZONE)>0 and te:IsActiveType(TYPE_FIELD) and te:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsLocation(LOCATION_FZONE) and c:IsControler(p) and p==tp and te:GetHandler()~=c
end
function cm.actarget3(e,tc,tp)
	if Dragoron_SSet_Check then return false end
	local c=e:GetLabelObject()
	local p=c:GetControler()
	return Duel.GetLocationCount(p,LOCATION_SZONE)>0 and tc:IsType(TYPE_FIELD) and c:IsLocation(LOCATION_FZONE) and c:IsControler(p) and tc:GetControler()==p and tc~=c
end
function cm.pcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(function(c,tp)return c:GetReasonPlayer()==1-tp and c:IsPreviousLocation(LOCATION_DECK) and not c:IsLocation(LOCATION_DECK)end,1,nil,tp) and e:GetHandler():GetSequence()>4
end
function cm.pfilter(c,tp)
	return not c:IsLocation(LOCATION_FZONE) and c:GetOriginalType()&TYPE_FIELD~=0 and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function cm.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(m)==0 and Duel.IsExistingMatchingCard(cm.pfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,tp) and c:GetSequence()>4 end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
end
function cm.pop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,5))
	local tc=Duel.SelectMatchingCard(tp,cm.pfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		if tc:IsLocation(LOCATION_SZONE) then
			Duel.MoveSequence(tc,5)
			if tc:IsFacedown() then Duel.ChangePosition(tc,POS_FACEUP) end
		else Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true) end
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function cm.cpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetSequence()>4 then return false end
	local loc,seq,p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_TRIGGERING_CONTROLER)
	if loc~=LOCATION_MZONE then return false end
	local col=aux.MZoneSequence(seq)
	if p~=tp then col=4-col end
	return aux.GetColumn(c,tp)==col and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_DRAGON)
end
function cm.record(e,tp,eg,ep,ev,re,r,rp)
	local pro1,pro2=re:GetProperty()
	cm[re]={re:GetCategory(),re:GetType(),re:GetCode(),re:GetCost(),re:GetCondition(),re:GetTarget(),re:GetOperation(),pro1,pro2}
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetSequence()<5 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thfilter(c,e,tp)
	return c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local cat,type,code,cost,con,tg,op,pro1,pro2=table.unpack(cm[re])
	if type&EFFECT_TYPE_SINGLE~=0 then return end
	if type&(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_QUICK_F)~=0 and code and code==EVENT_CHAINING then return end
	if not con then con=aux.TRUE end
	if not cost then cost=aux.TRUE end
	if not tg then tg=aux.TRUE end
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CUSTOM+53757099)
	e0:SetRange(0xff)
	e0:SetCountLimit(1)
	e0:SetOperation(cm.trop)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(cat)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetRange(0xff)
	e1:SetProperty(pro1|EFFECT_FLAG_DELAY,pro2)
	e1:SetCountLimit(1)
	if type&EFFECT_TYPE_IGNITION==0 and code and code~=EVENT_FREE_CHAIN and code~=EVENT_CHAINING then
		e1:SetCondition(cm.recon(con))
		e1:SetCost(cm.recost(cost))
		e1:SetTarget(cm.retg(tg,op))
		local g=Group.CreateGroup()
		g:KeepAlive()
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(code)
		e3:SetLabelObject(g)
		e3:SetOperation(cm.MergedDelayEventCheck1)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,0)
		local e4=e3:Clone()
		e4:SetCode(EVENT_CHAIN_END)
		e4:SetOperation(cm.MergedDelayEventCheck2)
		Duel.RegisterEffect(e4,0)
	else
		e1:SetCondition(con)
		e1:SetCost(cost)
		e1:SetTarget(tg)
		e1:SetOperation(op)
	end
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local rc=re:GetHandler()
	if not rc:IsLocation(LOCATION_MZONE) or rc:IsFacedown() then return end
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e2)
end
function cm.trop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsLocation(LOCATION_FZONE) then return end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+m,re,0,rp,ep,ev)
	e:Reset()
end
function cm.recon(_con)
	return function(e,tp,eg,ep,ev,re,r,rp)
				local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_CUSTOM+(m+50),true)
				if not res then return false end
				return _con(e,tp,teg,tep,tev,tre,tr,trp)
			end
end
function cm.recost(_cost)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
				local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_CUSTOM+(m+50),true)
				if not res then return false end
				return _cost(e,tp,teg,tep,tev,tre,tr,trp)
			end
end
function cm.retg(_tg,_op)
	return function(e,tp,eg,ep,ev,re,r,rp,...)
				local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_CUSTOM+(m+50),true)
				if not res then return false end
				e:SetOperation(cm.reop(_op,teg,tep,tev,tre,tr,trp))
				return _tg(e,tp,teg,tep,tev,tre,tr,trp,...)
			end
end
function cm.reop(_op,teg,tep,tev,tre,tr,trp)
	return function(e,tp,eg,ep,ev,re,r,rp)
				_op(e,tp,teg,tep,tev,tre,tr,trp)
			end
end
function cm.MergedDelayEventCheck1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	g:Merge(eg)
	if Duel.GetCurrentChain()==0 and not Duel.CheckEvent(EVENT_CHAIN_END) then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+(m+50),re,r,rp,ep,ev)
		g:Clear()
	end
end
function cm.MergedDelayEventCheck2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if #g>0 then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+(m+50),re,r,rp,ep,ev)
		g:Clear()
	end
end
