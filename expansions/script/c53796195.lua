if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--SNNM.AllEffectReset(c)
	aux.AddCodeList(c,53796195)
	aux.EnablePendulumAttribute(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(id)
	e0:SetRange(LOCATION_HAND+LOCATION_DECK)
	e0:SetTargetRange(1,0)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return #(s[tp])>0 end)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		if not s[0] then
			s[0]={}
			s[1]={}
		end
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_SOLVING)
		ge2:SetOperation(s.count)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.GlobalEffect()
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EFFECT_SEND_REPLACE)
		ge3:SetTarget(s.reptg)
		ge3:SetValue(s.repval)
		Duel.RegisterEffect(ge3,0)
		local roll=Duel.GetFieldGroup(0,0x3,0x41):GetSum(Card.GetCode)
		local A=1103515245
		local B=12345
		local M=32767
		function s.roll(min,max)
			min=tonumber(min)
			max=tonumber(max)
			roll=((roll*A+B)%M)/M
			if min~=nil then
				if max==nil then
					return math.floor(roll*min)+1
				else
					max=max-min+1
					return math.floor(roll*max+min)
				end
			end
			return roll
		end
		local f1=Card.IsAbleToDeckAsCost
		Card.IsAbleToDeckAsCost=function(sc)
			local ct=sc:GetFlagEffectLabel(id) or 0
			if ct&(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)~=0 then return false else return f1(sc) end
		end
		local f2=Card.IsAbleToExtra
		Card.IsAbleToExtra=function(sc)
			local ct=sc:GetFlagEffectLabel(id)
			if ct and ct&(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK+TYPE_PENDULUM)==0 then return false else return f2(sc) end
		end
		local f3=Card.IsAbleToExtraAsCost
		Card.IsAbleToExtraAsCost=function(sc)
			local ct=sc:GetFlagEffectLabel(id)
			if ct and ct&(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)==0 then return false else return f3(sc) end
		end
		local f4=Card.IsAbleToHandAsCost
		Card.IsAbleToHandAsCost=function(sc)
			local ct=sc:GetFlagEffectLabel(id) or 0
			if ct&(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)~=0 then return false else return f4(sc) end
		end
		local f5=Card.IsSSetable
		Card.IsSSetable=function(sc,...)
			local ct=sc:GetFlagEffectLabel(id)
			if ct and ct&(TYPE_SPELL+TYPE_TRAP)==0 then return false else return f5(sc,...) end
		end
		local f6=Card.IsCanBeSpecialSummoned
		Card.IsCanBeSpecialSummoned=function(sc,...)
			local ct=sc:GetFlagEffectLabel(id)
			if ct and ct&(TYPE_MONSTER)==0 then return false else return f6(sc,...) end
		end
		local f7=Card.CheckEquipTarget
		Card.CheckEquipTarget=function(sc,...)
			local ct=sc:GetFlagEffectLabel(id)
			if ct then return false else return f7(sc,...) end
		end
		local f8=Duel.IsPlayerCanSummon
		Duel.IsPlayerCanSummon=function(tp,type,sc)
			if type then
				local ct=sc:GetFlagEffectLabel(id)
				if ct then return false else return f8(tp,type,sc) end
			else return f8(tp) end
		end
		local f9=Duel.IsPlayerCanMSet
		Duel.IsPlayerCanMSet=function(tp,type,sc)
			if type then
				local ct=sc:GetFlagEffectLabel(id)
				if ct then return false else return f9(tp,type,sc) end
			else return f9(tp) end
		end
		local f10=Duel.IsPlayerCanSSet
		Duel.IsPlayerCanSSet=function(tp,sc)
			if sc then
				local ct=sc:GetFlagEffectLabel(id)
				if ct then return false else return f10(tp,sc) end
			else return f10(tp) end
		end
		local f11=Duel.IsPlayerCanSpecialSummon
		Duel.IsPlayerCanSpecialSummon=function(p,type,pos,tp,sc)
			if type then
				local ct=sc:GetFlagEffectLabel(id)
				if ct then return false else return f11(p,type,pos,tp,sc) end
			else return f11(p) end
		end
		local funcs={}
		local fnames={"SendtoGrave","Destroy","SendtoHand","SendtoExtraP","SendtoDeck","Overlay","SpecialSummon","SpecialSummonStep","MoveToField","ReturnToField","Summon","MSet","SSet","Equip"}
		for k,v in ipairs(fnames) do
			funcs[v]=Duel[v]
			if k==1 then
				Duel[v]=function(tg,reason)
					if reason&REASON_RULE~=0 then
						tg=Group.__add(tg,tg)
						for tc in aux.Next(tg) do
							local ct=tc:GetFlagEffectLabel(id+250) or 0
							if ct>0 then s.retop(tc,ct) end
						end
					end
					return funcs[v](tg,reason)
				end
			elseif k==2 then
				Duel[v]=function(tg,reason,...)
					if reason&REASON_RULE~=0 then
						tg=Group.__add(tg,tg)
						for tc in aux.Next(tg) do
							local ct=tc:GetFlagEffectLabel(id+250) or 0
							if ct>0 then s.retop(tc,ct) end
						end
					end
					return funcs[v](tg,reason,...)
				end
			elseif k==3 then
				Duel[v]=function(tg,tp,reason)
					if reason&REASON_RULE~=0 then
						tg=Group.__add(tg,tg)
						for tc in aux.Next(tg) do
							local ct=tc:GetFlagEffectLabel(id+250) or 0
							if ct>0 then s.retop(tc,ct) end
						end
					end
					return funcs[v](tg,tp,reason)
				end
			elseif k==4 then
				Duel[v]=function(tg,tp,reason)
					tg=Group.__add(tg,tg)
					for tc in aux.Next(tg) do
						local ct=tc:GetFlagEffectLabel(id+250) or 0
						if ct>0 then s.retop(tc,ct) end
					end
					return funcs[v](tg,tp,reason)
				end
			elseif k==5 then
				Duel[v]=function(tg,tp,seq,reason)
					if reason&REASON_RULE~=0 then
						tg=Group.__add(tg,tg)
						for tc in aux.Next(tg) do
							local ct=tc:GetFlagEffectLabel(id+250) or 0
							if ct>0 then s.retop(tc,ct) end
						end
					end
					return funcs[v](tg,tp,seq,reason)
				end
			elseif k==6 then
				Duel[v]=function(oc,tg)
					tg=Group.__add(tg,tg)
					for tc in aux.Next(tg) do
						local ct=tc:GetFlagEffectLabel(id+250) or 0
						if ct>0 then s.retop(tc,ct) end
					end
					return funcs[v](oc,tg)
				end
			elseif k<11 then
				Duel[v]=function(tg,...)
					local tg2=Group.__add(tg,tg)
					for tc in aux.Next(tg2) do
						local ct=tc:GetFlagEffectLabel(id+250) or 0
						if ct>0 then s.retop(tc,ct) end
					end
					return funcs[v](tg,...)
				end
			else
				Duel[v]=function(tp,tg,...)
					local tg2=Group.__add(tg,tg)
					for tc in aux.Next(tg2) do
						local ct=tc:GetFlagEffectLabel(id+250) or 0
						if ct>0 then s.retop(tc,ct) end
					end
					return funcs[v](tp,tg,...)
				end
			end
		end
		s.func1=Card.RegisterEffect
		s.tempreset={}
		local echk=Effect.SetReset
		Effect.SetReset=function(se,reset,ct)
			s.tempreset={reset,ct}
			return echk(se,reset,ct)
		end
		Card.RegisterEffect=function(sc,se,bool)
			local tempr=s.tempreset
			s.tempreset={}
			if not sc:IsStatus(STATUS_INITIALIZING) and SNNM.IsInTable(se:GetCode(),s.event) then
				local e1=Effect.CreateEffect(sc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetRange(0xff)
				e1:SetCode(id+250)
				e1:SetLabelObject(se)
				if #tempr>0 then e1:SetReset(table.unpack(tempr)) end
				s.func1(sc,e1,true)
			end
			return s.func1(sc,se,bool)
		end
		local tempf1=Effect.Reset
		Effect.Reset=function(se)
			local sc=se:GetHandler()
			if sc then
				local le={sc:IsHasEffect(id+250)}
				for _,v in pairs(le) do if v:GetLabelObject()==se then tempf1(v) end end
			end
			return tempf1(se)
		end
		local tempf2=Card.ReplaceEffect
		Card.ReplaceEffect=function(sc,...)
			local le={sc:IsHasEffect(id+250)}
			for _,v in pairs(le) do tempf1(v) end
			if sc:GetFlagEffect(53702700)>0 then
				local le={sc:IsHasEffect(id+750)}
				for _,v in pairs(le) do v:GetLabelObject():Reset() v:Reset() end
				return 0
			else return tempf2(sc,...) end
		end
	end
end
s.resettable={}
s.event={EVENT_TO_DECK,EVENT_TO_HAND,EVENT_MOVE}
function s.retop(tc,ct)
	tc:SetEntityCode(ct)
	tc:ReplaceEffect(ct,0)
	local loc=tc:GetPreviousLocation()
	local le={Duel.IsPlayerAffectedByEffect(0,id+500)}
	for _,v in pairs(le) do
		local ae=v:GetLabelObject()
		if v:GetOwner()==tc and ae then if tc:GetFlagEffect(53702700)==0 then s.func1(tc,ae,true) end v:Reset() end
	end
	local res=false
	local f=Card.RegisterEffect
	Card.RegisterEffect=function(tc,te,bool)
		s.tempreset={}
		local event=te:GetCode()
		if te:GetType()&EFFECT_TYPE_SINGLE~=0 and ((event==EVENT_TO_DECK and loc&0x41~=0) or (event==EVENT_TO_HAND and loc==LOCATION_HAND) or event==EVENT_MOVE) then res=true end
		return s.func1(tc,te,bool)
	end
	Duel.CreateToken(tp,tc:GetOriginalCode())
	if res then
		local evt={}
		Card.RegisterEffect=function(tc,te,bool)
			s.tempreset={}
			local event=te:GetCode()
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetRange(0xff)
			e1:SetCode(id+750)
			e1:SetLabelObject(te)
			s.func1(tc,e1,true)
			if te:GetType()&EFFECT_TYPE_SINGLE~=0 and ((event==EVENT_TO_DECK and loc&0x41~=0) or (event==EVENT_TO_HAND and loc==LOCATION_HAND) or event==EVENT_MOVE) then table.insert(evt,te) end
			return s.func1(tc,te,bool)
		end
		if tc.initial_effect then
			local ini=s.initial_effect
			s.initial_effect=function() end
			tc:ReplaceEffect(id,0)
			s.initial_effect=ini
			tc.initial_effect(tc)
			tc:RegisterFlagEffect(53702700,0,0,0)
		end
		Card.RegisterEffect=f
		local evrt={}
		for k,v in pairs(evt) do
			local con=v:GetCondition() or aux.TRUE
			table.insert(evrt,con)
			v:SetCondition(aux.FALSE)
		end
		s.resettable={evt,evrt}
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) then re:GetHandler():RegisterFlagEffect(id+750,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1) end
	local g=Group.__sub(Duel.GetFieldGroup(rp,0xff,0),re:GetHandler())
	if #g<3 or not Duel.IsPlayerAffectedByEffect(1-rp,id) then return end
	local roll1=s.roll(1,#g)
	local roll2=roll1
	while roll2==roll1 do roll2=s.roll(1,#g) end
	local sg=Group.CreateGroup()
	local sc=g:GetFirst()
	local ct=1
	while sc do
		if ct==roll1 or ct==roll2 then sg:AddCard(sc) end
		sc=g:GetNext()
		ct=ct+1
	end
	sg:AddCard(re:GetHandler())
	for tc in aux.Next(sg) do Duel.Hint(HINT_CODE,rp,tc:GetCode()) if not SNNM.IsInTable(tc:GetCode(),s[1-rp]) then table.insert(s[1-rp],tc:GetCode()) end end
end
function s.count(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsStatus(STATUS_LEAVE_CONFIRMED) then re:GetHandler():ResetFlagEffect(id+750) end
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(function(c)return c:GetFlagEffect(id+250)>0 end,nil)
	if chk==0 then return #g>0 end
	for tc in aux.Next(g) do
		local ct=tc:GetFlagEffectLabel(id+250)
		s.retop(tc,ct)
	end
	return false
end
function s.repval(e,c)
	return false
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtra() end
	Duel.SendtoExtraP(c,tp,REASON_COST)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0x41,0,#(s[tp]),e:GetHandler(),tp,POS_FACEDOWN) end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+SNNM.GetCurrentPhase(),0,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,0x41)
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_EXTRA) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0x41,0,#(s[tp]),#(s[tp]),c,tp,POS_FACEDOWN)
	if #g==0 then return end
	local acg=Group.CreateGroup()
	for tc in aux.Next(g) do if tc:GetFlagEffect(id+750)>0 or tc:GetEquipTarget() or tc:IsHasEffect(EFFECT_REMAIN_FIELD) then acg:AddCard(tc) end end
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	if #og==0 then return end
	og:Filter(Card.IsPreviousLocation,nil,LOCATION_ONFIELD):ForEach(Card.SetReason,REASON_EFFECT+REASON_TEMPORARY)
	for tc in aux.Next(og) do
		tc:CreateRelation(c,RESET_EVENT+RESETS_STANDARD)
		local num=s.roll(1,#(s[tp]))
		local code=(s[tp])[num]
		table.remove(s[tp],num)
		local name=tc:GetOriginalCode()
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,tc:GetOriginalType())
		tc:RegisterFlagEffect(id+250,RESET_EVENT+RESETS_STANDARD,0,1,name)
		if acg:IsContains(tc) then tc:RegisterFlagEffect(id+500,RESET_EVENT+RESETS_STANDARD,0,1) end
		if tc:GetFlagEffect(53702700)==0 then
			local cp={}
			local f=Card.RegisterEffect
			Card.RegisterEffect=function(tc,te,bool)
				local pro1,pro2=te:GetProperty()
				if pro1&EFFECT_FLAG_UNCOPYABLE~=0 then table.insert(cp,te:Clone()) end
				return s.func1(tc,te,bool)
			end
			Duel.CreateToken(tp,tc:GetOriginalCode())
			for _,v in pairs(cp) do
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(1,1)
				e1:SetCode(id+500)
				e1:SetLabelObject(v)
				Duel.RegisterEffect(e1,tp)
			end
			Card.RegisterEffect=f
		end
		tc:SetEntityCode(code)
		local ini=s.initial_effect
		s.initial_effect=function() end
		tc:ReplaceEffect(id,0)
		s.initial_effect=ini
	end
	Duel.ConfirmCards(tp,Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil))
	og:KeepAlive()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MOVE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetLabelObject(og)
	e1:SetCondition(s.tdcon)
	e1:SetOperation(s.tdop)
	s.func1(c,e1,true)
	Duel.ConfirmCards(tp,og)
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsLocation(LOCATION_REMOVED)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(Card.IsRelateToCard,nil,e:GetHandler())
	if #g==0 then return end
	local exg=Group.__sub(Duel.GetFieldGroup(0,0xff,0xff),g)
	local evg=Group.CreateGroup()
	local evc=nil
	local f=Card.RegisterEffect
	Card.RegisterEffect=function(tc,te,bool)
		s.tempreset={}
		if te:GetType()&(EFFECT_TYPE_FIELD+EFFECT_TYPE_ACTIVATE)~=0 and SNNM.IsInTable(te:GetCode(),s.event) and evc:IsLocation(te:GetRange()) then evg:AddCard(evc) end
		return s.func1(tc,te,bool)
	end
	for tc in aux.Next(exg) do
		evc=tc
		Duel.CreateToken(tp,tc:GetOriginalCode())
	end
	local evt={}
	Card.RegisterEffect=function(tc,te,bool)
		s.tempreset={}
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(0xff)
		e1:SetCode(id+750)
		e1:SetLabelObject(te)
		s.func1(tc,e1,true)
		if te:GetType()&(EFFECT_TYPE_FIELD+EFFECT_TYPE_ACTIVATE)~=0 and SNNM.IsInTable(te:GetCode(),s.event) and tc:IsLocation(te:GetRange()) then
			table.insert(evt,te)
		end
		return s.func1(tc,te,bool)
	end
	for tc in aux.Next(evg) do
		if tc.initial_effect then
			local ini=s.initial_effect
			s.initial_effect=function() end
			tc:ReplaceEffect(id,0)
			s.initial_effect=ini
			tc.initial_effect(tc)
			tc:RegisterFlagEffect(53702700,0,0,0)
		end
	end
	Card.RegisterEffect=f
	local evrt={}
	for k,v in pairs(evt) do
		local con=v:GetCondition() or aux.TRUE
		table.insert(evrt,con)
		v:SetCondition(aux.FALSE)
	end
	local others1,others2={},{}
	for tc in aux.Next(exg) do
		for _,v in pairs({tc:IsHasEffect(id+250)}) do
			local ae=v:GetLabelObject()
			local con=ae:GetCondition() or aux.TRUE
			table.insert(others1,ae)
			table.insert(others2,con)
			ae:SetCondition(aux.FALSE)
		end
	end
	local sg=g:Filter(function(c)return c:GetFlagEffect(id+500)>0 end,nil)
	if #sg>0 then Duel.SendtoGrave(sg,REASON_RULE+REASON_RETURN) end
	g:Sub(sg)
	sg=g:Filter(Card.IsReason,nil,REASON_TEMPORARY)
	for tc in aux.Next(sg) do
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc and tc:IsPreviousLocation(LOCATION_FZONE) then Duel.SendtoGrave(fc,REASON_RULE) end
		if tc:IsPreviousLocation(LOCATION_FZONE) then Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true) else Duel.ReturnToField(tc) end
	end
	g:Sub(sg)
	sg=g:Filter(Card.IsPreviousLocation,nil,LOCATION_HAND)
	if #sg>0 then Duel.SendtoHand(sg,tp,REASON_EFFECT) end
	g:Sub(sg)
	sg=g:Filter(function(c)return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_EXTRA)end,nil)
	local tempsg1=sg:Clone()
	g:Sub(sg)
	sg=g:Filter(function(c)return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_DECK)end,nil)
	local tempsg2=sg:Clone()
	sg=g:Filter(Card.IsPreviousLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if #sg>0 then Duel.SendtoDeck(sg,tp,2,REASON_EFFECT) if #tempsg2>0 then tempsg2:ForEach(Card.ReverseInDeck) end end
	if #tempsg1>0 then Duel.SendtoExtraP(tempsg1,tp,REASON_EFFECT) end
	g:Sub(sg)
	sg=g:Filter(Card.IsPreviousLocation,nil,LOCATION_GRAVE)
	if #sg>0 then Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN) end
	for k,v in pairs(evt) do v:SetCondition(evrt[k]) end
	for k,v in pairs(others1) do v:SetCondition(others2[k]) end
	if #(s.resettable)>0 then
		local rst1,rst2=s.resettable[1],s.resettable[2]
		for k,v in pairs(rst1) do v:SetCondition(rst2[k]) end
	end
	s.resettable={}
end
function s.filter(c,code)
	return c:IsFacedown() and c:GetOriginalCode()~=code
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local b1=e:GetHandler():IsAbleToDeck()
	local b2=Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_REMOVED,0,1,nil)
	local sel=aux.SelectFromOptions(tp,{b1,aux.Stringid(id,1)},{b2,aux.Stringid(id,2)},{true,aux.Stringid(id,4)})
	if sel~=3 then Duel.Hint(HINT_CARD,0,id) end
	if sel==1 then Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT) elseif sel==2 then
		local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
		local ac=0
		if g:GetClassCount(Card.GetOriginalCode)==1 then ac=Duel.AnnounceCard(tp,g:GetFirst():GetOriginalCode(),OPCODE_ISCODE,OPCODE_NOT) else ac=Duel.AnnounceCard(tp) end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
		local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_REMOVED,0,1,1,nil,ac):GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		local name=tc:GetOriginalCode()
		if tc:GetFlagEffect(id)==0 then
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,tc:GetOriginalType())
			tc:RegisterFlagEffect(id+250,RESET_EVENT+RESETS_STANDARD,0,1,name)
		end
		tc:SetEntityCode(ac)
		local ini=s.initial_effect
		s.initial_effect=function() end
		tc:ReplaceEffect(id,0)
		s.initial_effect=ini
		local le={tc:IsHasEffect(id+500)}
		for _,v in pairs(le) do v:GetLabelObject():Reset() v:Reset() end
		Duel.ConfirmCards(tp,Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil))
	end
end
