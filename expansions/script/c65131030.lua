local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,aux.TRUE,s.xyzcheck,2,99)
	--本部分代码修改自ad钙的批判家CB
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetOperation(s.adjustop)
	c:RegisterEffect(e0)
	local adg=Group.CreateGroup()
	adg:KeepAlive()
	e0:SetLabelObject(adg)
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e01:SetCode(id)
	e01:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e01)
	local e02=Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_SINGLE)
	e02:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e02:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e02)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.stcon)
	e1:SetOperation(s.stop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--damage limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(id)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(s.dlcon)
	c:RegisterEffect(e3)
	local e31=e3:Clone()
	e31:SetType(EFFECT_TYPE_FIELD)
	e31:SetValue(s.damval)
	c:RegisterEffect(e31)
	--add effect id
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(id+1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetCondition(s.idcon)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.wdcon)
	e5:SetTargetRange(1,0)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_ACTIVATE_COST)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(1,0)
	e6:SetCondition(s.accon)
	e6:SetTarget(s.actg)
	e6:SetOperation(s.acop)
	c:RegisterEffect(e6)

	if not s.global_check then
		s.global_check=true
		_IsXyzSummonable=Card.IsXyzSummonable
		Card.IsXyzSummonable=function (c,mg,...)
			if c:IsHasEffect(id) then
				local min = select(1, ...) or 0
				local max = select(2, ...) or 99
				if mg==nil then
					xg=Duel.GetMatchingGroup(Card.IsCanBeXyzMaterial,c:GetControler(),LOCATION_MZONE,0,nil,c)
				else
					xg=Filter(Card.IsCanBeXyzMaterial,nil,c)
				end
				return xg:CheckSubGroup(s.xyzcheck,math.max(2,min),max)
			else
				return _IsXyzSummonable(c,mg,...)
			end			
		end
		_IsSpecialSummonable=Card.IsSpecialSummonable
		Card.IsSpecialSummonable=function (c,stype)
			if c:IsHasEffect(id) and stype== SUMMON_TYPE_XYZ then
				return Duel.GetMatchingGroup(Card.IsCanBeXyzMaterial,c:GetControler(),LOCATION_MZONE,0,nil,c):CheckSubGroup(s.xyzcheck,2,min,99)
			else
				return _IsSpecialSummonable(c,stype)
			end
		end

		s.effecttable={{},{}}
		local _RegisterEffect=Duel.RegisterEffect
		Duel.RegisterEffect=function (e,p)
			if Duel.GetTurnCount()>0 then table.insert(s.effecttable[1+p],e) end
			_RegisterEffect(e,p)
		end
		s.damagetable={0,0}
		local _SetLP=Duel.SetLP
		function Duel.SetLP(p,lp)
			if Duel.IsPlayerAffectedByEffect(p,id)~=nil then
				s.damagetable[p+1]=s.damagetable[p+1]+math.min(Duel.GetLP(p)-lp,2000) 
				if Duel.GetLP(p)-lp>2000 then Duel.Hint(HINT_CARD,0,id) end
				_SetLP(p,math.max(Duel.GetLP(p)-2000,lp))
			else
				_SetLP(p,lp)
			end
		end
		local _CheckLPCost=Duel.CheckLPCost
		function Duel.CheckLPCost(p,cost)
			if Duel.IsPlayerAffectedByEffect(p,id)~=nil then
				return _CheckLPCost(p,math.min(cost,2000))
			else
				return _CheckLPCost(p,cost)
			end
		end
		local _PayLPCost=Duel.PayLPCost
		function Duel.PayLPCost(p,cost)
			if Duel.IsPlayerAffectedByEffect(p,id)~=nil then
				s.damagetable[p+1]=s.damagetable[p+1]+math.min(cost,2000) 
				if cost>0 then Duel.Hint(HINT_CARD,0,id) end
				_PayLPCost(p,math.min(cost,2000))
			else
				_PayLPCost(p,cost)
			end
		end		  
		carddata={
			lp={8000,8000},
			turn=0,
			cards={{},{}},  
		}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE+PHASE_END)
		ge1:SetCondition(s.damcon)
		ge1:SetOperation(s.damop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)


		
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_CHAINING)
		ge3:SetCondition(s.addcon)
		ge3:SetOperation(s.addop)
		Duel.RegisterEffect(ge3,0)

		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_ADJUST)
		ge4:SetCondition(s.recon)
		ge4:SetOperation(s.reop)
		Duel.RegisterEffect(ge4,0)
		local ge5=Effect.CreateEffect(c)
		ge5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge5:SetCode(EVENT_PREDRAW)
		ge5:SetCountLimit(1)
		ge5:SetOperation(s.saveop)
		Duel.RegisterEffect(ge5,0)
		
		

		s.acteffecttable={{},{}}
		local ge6=Effect.CreateEffect(c)
		ge6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge6:SetCode(EVENT_CHAIN_SOLVING)
		ge6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		ge6:SetCondition(s.opdocon)
		ge6:SetOperation(s.opdo)
		Duel.RegisterEffect(ge6,0)
		
	end
end
function s.chcon(_con)
	return function(e,...)
				local x=e:GetHandler()
				if x:IsHasEffect(id) and x:GetFlagEffect(id)==0 then return false end
				return _con(e,...)
			end
end
function s.chtg(_tg)
	return function(e,c,...)
				if c:IsHasEffect(id) and c:GetFlagEffect(id)==0 then return false end
				return _tg(e,c,...)
			end
end
function s.chtg2(_tg)
	return function(e,c,sump,sumtype,sumpos,targetp,se)
				if c:IsHasEffect(id) and se:GetHandler()==c and c:GetFlagEffect(id)==0 then return false end
				return _tg(e,c,sump,sumtype,sumpos,targetp,se)
			end
end

function s.reset(e,tp,eg,ep,ev,re,r,rp)
	local x=e:GetLabelObject():GetHandler()
	local te=e:GetLabelObject():GetLabelObject()
	local loc,v=e:GetLabel()
	if x:GetLocation()&loc==0 then
		te:SetLabel(0,v)
		te:SetValue(v)
		e:GetLabelObject():Reset()
		e:Reset()
	end
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	g:Clear()
	c:RegisterFlagEffect(id-1,0,0,0)
	local bool1=c:IsHasEffect(EFFECT_CANNOT_SPECIAL_SUMMON)
	local bool2=c:IsHasEffect(EFFECT_SPSUMMON_COST)
	local bool3=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON)
	local bool4=Duel.IsPlayerAffectedByEffect(tp,EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)
	local bool5=Duel.IsPlayerAffectedByEffect(tp,EFFECT_SPSUMMON_COUNT_LIMIT)
	if not (bool1 or bool2 or bool3 or bool4 or bool5) then return end
	local re1={c:IsHasEffect(EFFECT_CANNOT_SPECIAL_SUMMON)}
	local re2={c:IsHasEffect(EFFECT_SPSUMMON_COST)}
	local re5={Duel.IsPlayerAffectedByEffect(tp,EFFECT_SPSUMMON_COUNT_LIMIT)}
	for _,te1 in pairs(re1) do
		local con=te1:GetCondition()
		if not con then con=aux.TRUE end
		g:AddCard(te1:GetOwner())
		te1:SetCondition(s.chcon(con))
	end
	for _,te2 in pairs(re2) do
		if te2:GetType()==EFFECT_TYPE_SINGLE then
			local con=te2:GetCondition()
			if not con then con=aux.TRUE end
			g:AddCard(te2:GetOwner())
			te2:SetCondition(s.chcon(con))
		end
		if te2:GetType()==EFFECT_TYPE_FIELD then
			local tg=te2:GetTarget()
			local o,h=te2:GetOwner(),te2:GetHandler()
			if not tg then
				if h then g:AddCard(h) else g:AddCard(o) end
				te2:SetTarget(s.chtg(aux.TRUE))
			elseif tg(te2,c,tp)==true then
				if h then g:AddCard(h) else g:AddCard(o) end
				te2:SetTarget(s.chtg(tg))
			end
		end
	end
	for _,te5 in pairs(re5) do
		local val=te5:GetValue()
		local _,a=te5:GetLabel()
		if a==0 then te5:SetLabel(0,val) end
		local x,o,h=nil,te5:GetOwner(),te5:GetHandler()
		if h then x=h else x=o end
		local sp=Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)
		local _,b=te5:GetLabel()
		if sp==0 then
			te5:SetLabel(1,b)
			te5:SetValue(b)
		end
		val=te5:GetValue()
		local l,_=te5:GetLabel()
		if l==0 then te5:SetLabel(sp+1,b) else
			local n=sp-l+1
			if n==val then
				te5:SetValue(val+1)
				local e1=te5:Clone()
				e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e1:SetReset(RESET_PHASE+PHASE_END)
				local loc=te5:GetRange()
				if loc~=0 then
					e1:SetLabelObject(te5)
					h:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e2:SetCode(EVENT_ADJUST)
					e2:SetLabel(loc,b)
					e2:SetLabelObject(e1)
					e2:SetOperation(s.reset)
					Duel.RegisterEffect(e2,tp)
				else Duel.RegisterEffect(e1,te5:GetOwnerPlayer()) end
			end
		end
	end
	local re3={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON)}
	local re4={Duel.IsPlayerAffectedByEffect(tp,EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)}
	for _,te3 in pairs(re3) do
		local tg=te3:GetTarget()
		local o,h=te3:GetOwner(),te3:GetHandler()
		if not tg then
			if h then g:AddCard(h) else g:AddCard(o) end
			te3:SetTarget(s.chtg2(aux.TRUE,0))
		elseif tg(te3,c,tp,SUMMON_TYPE_SPECIAL,POS_FACEUP,tp,e)==true then
			if h then g:AddCard(h) else g:AddCard(o) end
			te3:SetTarget(s.chtg2(tg))
		end
	end
	for _,te4 in pairs(re4) do
		local tg=te4:GetTarget()
		local o,h=te4:GetOwner(),te4:GetHandler()
		if tg(te4,c,tp,tp,POS_FACEUP)==true then
			if h then g:AddCard(h) else g:AddCard(o) end
			te4:SetTarget(s.chtg2(tg))
		end
	end
	c:ResetFlagEffect(id-1)
end
function s.xyzfilter(c)
	if c:IsLinkAbove(1) then return c:GetLink() end
	if c:IsRankAbove(1) then return c:GetRank() end
	return c:GetLevel()
end
function s.xyzcheck(g)   
	return g:GetClassCount(s.xyzfilter)==1 and g:GetClassCount(Card.GetAttribute)==g:GetCount()
end
function s.stcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_ACTIVATE_DISABLED) and c:GetOverlayCount()>=1
end
function s.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	c:RegisterEffect(e1,true)
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetValue(function (e,c)
			return c==e:GetHandler()
		end)
	c:RegisterEffect(e2,true)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetCondition(function (e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_MZONE,0)==0
	end)
	c:RegisterEffect(e3,true)
	
	local et={e1,e2,e3}
	for i=2,math.min(c:GetOverlayCount(),6) do
		local e0=Effect.CreateEffect(c)
		e0:SetDescription(aux.Stringid(id,i))
		e0:SetType(EFFECT_TYPE_SINGLE)  
		e0:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		table.insert(et,e0)
		c:RegisterEffect(e0,true)	   
	end
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.stcon2)
	e4:SetOperation(s.stop2(et))
	c:RegisterEffect(e4,true)
	c:SetStatus(STATUS_SPSUMMON_STEP,true)
	c:SetStatus(STATUS_SUMMONING,true)
	c:SetStatus(STATUS_SUMMON_DISABLED,true)
	c:SetStatus(STATUS_ACTIVATE_DISABLED,true)
end
function s.stcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()<1
end
function s.stop2(et)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		for _,effect in pairs(et) do
			effect:Reset()
		end
		c:SetStatus(STATUS_SPSUMMON_STEP,false)
		c:SetStatus(STATUS_SUMMONING,false)
		c:SetStatus(STATUS_SUMMON_DISABLED,false)
		c:SetStatus(STATUS_ACTIVATE_DISABLED,false)
		e:Reset()
	end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	if c:GetOverlayCount()>=2 and  #s.effecttable[2-tp]>0 then
		for i,v in ipairs(s.effecttable[2-tp]) do
			v:Reset()
		end
		s.effecttable[2-tp]={}
	end
end
function s.dlcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=3
end
function s.damval(e,re,val,r,rp)
	s.damagetable[p+1]=s.damagetable[p+1]+math.min(val,2000) 
	if val>2000 then Duel.Hint(HINT_CARD,0,id) end
	return math.min(val,2000)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return s.damagetable[tp+1]>0
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	if Duel.IsPlayerAffectedByEffect(tp,id) and Duel.IsPlayerAffectedByEffect(1-tp,id) then
		while s.damagetable[tp+1]~=0 or s.damagetable[2-tp]~=0 do
			for p=0,1 do
				Duel.SetLP(1-p,Duel.GetLP(1-p)-math.floor(s.damagetable[p+1]/2))
				s.damagetable[p+1]=0
			end
		end
	else
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)-math.floor(s.damagetable[tp+1]/2))
		s.damagetable[tp+1]=0
	end
end
function s.addeffcon(effect)	
	return function (e,tp,eg,ep,ev,...)
		for i=1,Duel.GetCurrentChain() do	  
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		_,limid1=te:GetCountLimit()
		_,limid2=effect:GetCountLimit()
		if limid1==limid2 then return false end
	end
		local con=effect:GetCondition()
		return Duel.IsPlayerAffectedByEffect(tp,id+1)~=nil and not effect:CheckCountLimit(tp) and (not con or con(e,tp,eg,ep,ev,...)) 
	end
end
function s.change_effect(effect)
	local eff=effect:Clone()
	local etype=EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_FLIP+EFFECT_TYPE_IGNITION+EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_QUICK_O+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_QUICK_F
	local limcount,limid=effect:GetCountLimit()
	if effect:GetType()&etype~=0 and limcount==1 and limid and limid<EFFECT_COUNT_CODE_DUEL then
		eff:SetCondition(s.addeffcon(effect))
		--eff:SetDescription(aux.Stringid(id,4))
		eff:SetCountLimit(2,id+EFFECT_COUNT_CODE_CHAIN)
		return eff
	else
		return 0
	end
end
function s.addcon(e,tp,eg,ep,ev,re,r,rp)   
	local rc=re:GetHandler()	
	return not rc.Is_Add_Effect_Id
end
function s.addop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local cm=_G["c"..rc:GetOriginalCode()]
	if not cm.Is_Add_Effect_Id then
		local inie=cm.initial_effect
		function addinit(c)
			cm.Is_Add_Effect_Id=true
			local _CReg=Card.RegisterEffect
			Card.RegisterEffect=function(card,effect,...)
				if effect then			
					if effect:GetType()&EFFECT_TYPE_GRANT~=0 then
						local labeff=s.change_effect(effect:GetLabelObject())
						if labeff~=0 then
							local eff=effect:Clone()
							eff:SetLabelObject(labeff)
							_CReg(card,eff,...)
						end
					else
						local eff=s.change_effect(effect)
						if eff~=0 then
							_CReg(card,eff,...)
						end
					end
					return _CReg(card,effect,...)
				end	  
			end
			if inie then inie(c) end
			Card.RegisterEffect=_CReg
		end
		cm.initial_effect=addinit
	end
	local g=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0xff,0xff,nil,rc:GetOriginalCode())
	for tc in aux.Next(g) do
		local mt=getmetatable(tc)
		local ini=s.initial_effect
		s.initial_effect=function() end
		tc:ReplaceEffect(id,0)
		s.initial_effect=ini
		mt.initial_effect=addinit
		tc.initial_effect(tc)
	end
end
function s.idcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=4
end
function get_save_location(c)
	if c:IsLocation(LOCATION_PZONE) then return LOCATION_PZONE
	else return c:GetLocation() end
end
function get_save_sequence(c)
	if c:IsOnField() then return c:GetSequence()
	else return 0 end
end
function s.saveop(e,tp,eg,ep,ev,re,r,rp)
	carddata={
		lp={Duel.GetLP(0),Duel.GetLP(1)},
		turn=Duel.GetTurnCount(),
		cards={{},{}},  
	}
	for p=0,1 do	
		local sg=Duel.GetMatchingGroup(nil,p,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
		
		local cid=0
		for tc in aux.Next(sg) do
			cid=cid+1
			local cdata={
				id=cid,
				card=tc,
				location=get_save_location(tc),
				sequence=get_save_sequence(tc),
				position=tc:GetPosition(),
				overlay_cards={},
				counter={}
			}
			if tc:GetCounter(0)>0 then
				for counter=1,65535 do
					local ct=tc:GetCounter(counter)
					if ct>0 then
						table.insert(cdata.counter,{
							type=counter,
							count=ct
						})
					end
				end
			end
			local og=tc:GetOverlayGroup()
			for oc in aux.Next(og) do
				cid=cid+1
				table.insert(cdata.overlay_cards, {
					id=cid,
					card=oc,
					summon_type=oc:GetSummonType(),
					summon_location=oc:GetSummonLocation(),
				})
			end
			table.insert(carddata.cards[p+1],cdata)
		end
	end
end
function s.wdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)==0 and e:GetHandler():GetOverlayCount()>=5
end
function s.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(0)<=0 or Duel.GetLP(1)<=0
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do	
		if Duel.GetLP(p)<=0 and Duel.GetFlagEffect(p,id)==0 and Duel.IsPlayerAffectedByEffect(p,EFFECT_CANNOT_LOSE_KOISHI) then
			Duel.SetLP(p,0)
			Duel.Hint(HINT_CARD,0,id)
			Duel.SendtoGrave(Duel.GetFieldGroup(p,LOCATION_HAND+LOCATION_ONFIELD,0),REASON_ADJUST)
			Duel.Recover(p,carddata.lp[p+1],REASON_ADJUST)
			for i,cdata in ipairs(carddata.cards[p+1]) do
				if cdata.location==LOCATION_HAND then
					Duel.SendtoHand(cdata.card,p,REASON_ADJUST)
				elseif cdata.location==LOCATION_PZONE then
					local tc=cdata.card
					--local e1=Effect.CreateEffect(e:GetHandler())
					--e1:SetType(EFFECT_TYPE_FIELD)
					--e1:SetCode(EFFECT_DISABLE_FIELD)
					--e1:SetLabel(2^(12-cdata.sequence))
					--e1:SetOperation(function (e,tp) return e:GetLabel() end)
					--Duel.RegisterEffect(e1,p)
					--local mc=Duel.CreateToken(p,id)
					--Duel.MoveToField(mc,p,p,LOCATION_SZONE,POS_FACEDOWN,true,2^(4-cdata.sequence))
					local num=0
					while not tc:IsLocation(LOCATION_PZONE) or tc:GetSequence()~=cdata.sequence do
						num=num+1
						Duel.Overlay(e:GetHandler(),tc)
						Duel.MoveToField(tc,p,p,cdata.location,cdata.position,true)
						if num>=3 then Debug.Message("别闹，好好选") end
					end
					--Duel.Exile(mc,REASON_RULE)
						--Duel.MoveSequence(tc,1)
						--if tc:GetLocation()~=cdata.sequence then Duel.MoveSequence(tc,0) end

					for _,counter in ipairs(cdata.counter) do
						tc:AddCounter(counter.type,counter.count)
					end
				else
					local tc=cdata.card
					if cdata.sequence>=5 then Duel.SendtoExtraP(tc,p,REASON_ADJUST) end
					if not Duel.MoveToField(tc,p,p,cdata.location,cdata.position,true,2^cdata.sequence) then Duel.SendtoGrave(tc,REASON_ADJUST) end
					for _,counter in ipairs(cdata.counter) do
						tc:AddCounter(counter.type,counter.count)
					end
					for _,ocards in ipairs(cdata.overlay_cards) do
						Duel.Overlay(tc,ocards.card)
					end
					--tc:CancelToGrave()
				end
			end
			Duel.RegisterFlagEffect(p,id,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function s.accon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=6
end
function s.actg(e,te,tp)
	e:SetLabelObject(te)
	return true
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local p=te:GetOwnerPlayer()
	table.insert(s.acteffecttable[p+1],te)
end
function s.opdocon(e,tp,eg,ep,ev,re,r,rp)
	return #s.acteffecttable[1]>0 or #s.acteffecttable[2]>0
end
function s.opdo(e,tp,eg,ep,ev,re,r,rp)  
	for i=ev,1,-1 do
		local p=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_PLAYER)
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		for j,value in ipairs(s.acteffecttable[p+1]) do
			if value==te then
				table.remove(s.acteffecttable[p+1],j)
				Duel.Hint(HINT_CARD,0,te:GetOwner():GetCode())
				
				
				local reg,rep,rev,cre,cr,crp=Duel.GetChainEvent(i)	
				Duel.SetTargetPlayer(Duel.GetChainInfo(i,CHAININFO_TARGET_PLAYER))
				Duel.SetTargetParam(Duel.GetChainInfo(i,CHAININFO_TARGET_PARAM)) 
				local tg=Duel.GetChainInfo(i,CHAININFO_TARGET_CARDS)
				if tg and tg:GetCount()>0 then
					Duel.SetTargetCard(tg)
					for ac in aux.Next(tg) do
						ac:CreateEffectRelation(te)
					end
				end
				local op=te:GetOperation()
				if op then
					Duel.ChangeChainOperation(i,function (e,tp,eg,ep,ev,re,r,rp) return false end)
					op(te,p,reg,rep,rev,cre,cr,crp)
				end
				if tg and tg:GetCount()>0 then
					Duel.ClearTargetCard()
					for ac in aux.Next(tg) do
						ac:ReleaseEffectRelation(te)
					end
				end 
				break
			end
		end
	end
	s.acteffecttable={{},{}}
end