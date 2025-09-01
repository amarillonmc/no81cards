--风雨咏叹调
--22.07.03
local cm,m=GetID()
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11451631,5))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetRange(LOCATION_DECK)
	e3:SetCondition(cm.condition)
	e3:SetCost(cm.cost)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_DECK+LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(cm.actarget)
	e4:SetOperation(cm.costop)
	c:RegisterEffect(e4)
	--set
	local custom_code=cm.RegisterMergedEvent_ToSingleCard(c,m,EVENT_LEAVE_FIELD)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11451631,6))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCode(custom_code)
	local e21=aux.AddThisCardInGraveAlreadyCheck(c)
	e2:SetLabelObject(e21)
	e2:SetCondition(cm.actcon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(cm.actop)
	c:RegisterEffect(e2)
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
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetDecktopGroup(e:GetHandlerPlayer(),1):IsContains(e:GetHandler())
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local te=Duel.IsPlayerAffectedByEffect(tp,11451677)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return te and ft>0 end
	te:UseCountLimit(tp)
end
function cm.actarget(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler() and te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	Duel.DisableShuffleCheck()
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false)
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
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
end
function cm.filter(c,tp)
	return c:IsCode(11451631) and not c:IsForbidden() and c:CheckUniqueOnField(tp) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or Duel.IsPlayerAffectedByEffect(tp,11451676)) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function cm.filter0(c)
	return c:IsCanBeFusionMaterial() --and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function cm.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e) --and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function cm.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.fexfilter(c)
	return c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function cm.frcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function cm.gcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function cm.ccfilter(c)
	return c:IsFaceup() and c:IsCode(11451631)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(cm.filter0,tp,LOCATION_ONFIELD+LOCATION_REMOVED,0,e:GetHandler())
		if Duel.IsExistingMatchingCard(cm.ccfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
			local mg2=Duel.GetMatchingGroup(cm.fexfilter,tp,LOCATION_DECK,0,nil)
			if #mg2>0 then
				mg1:Merge(mg2)
				aux.FCheckAdditional=cm.frcheck
				aux.GCheckAdditional=cm.gcheck
			end
		end
		local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_ONFIELD+LOCATION_REMOVED,0,aux.ExceptThisCard(e),e)
	local exmat=false
	if Duel.IsExistingMatchingCard(cm.ccfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		local mg2=Duel.GetMatchingGroup(cm.fexfilter,tp,LOCATION_DECK,0,nil)
		if mg2:GetCount()>0 then
			mg1:Merge(mg2)
			exmat=true
		end
	end
	if exmat then
		aux.FCheckAdditional=cm.frcheck
		aux.GCheckAdditional=cm.gcheck
	end
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if exmat then
				aux.FCheckAdditional=cm.frcheck
				aux.GCheckAdditional=cm.gcheck
			end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			aux.FCheckAdditional=nil
			aux.GCheckAdditional=nil
			tc:SetMaterial(mat1)
			local mat2=mat1:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
			mat1:Sub(mat2)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			local dg=mat2:Filter(Card.IsAbleToHand,nil)
			local te=Duel.IsPlayerAffectedByEffect(tp,11451674)
			if te and #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(11451674,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
				local rg=dg:Select(tp,1,1,nil)
				mat2:Sub(rg)
				Duel.SendtoHand(rg,nil,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.ConfirmCards(1-tp,rg)
				te:UseCountLimit(tp)
			end
			Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION+REASON_RETURN)
			Duel.BreakEffect()
			local le={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON)}
			local lex={Duel.IsPlayerAffectedByEffect(tp,EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)}
			--for _,v in pairs(lex) do table.insert(le,v) end
			local ret1,ret2={},{}
			for _,v in pairs(le) do
				local tg=v:GetTarget()
				if not tg then tg=aux.TRUE end
				table.insert(ret1,v)
				table.insert(ret2,tg)
				v:SetTarget(cm.chtg(tg,e))
			end
			Duel.SpecialSummonStep(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			for i=1,#ret1 do ret1[i]:SetTarget(ret2[i]) end
			Duel.SpecialSummonComplete()
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function cm.chtg(_tg,re)
	return function(e,c,sump,sumtype,sumpos,targetp,se)
			   if se==re then return false end
			   return _tg(e,c,sump,sumtype,sumpos,targetp,se)
		   end
end
function cm.actfilter(c,se)
	if not (se==nil or c:GetReasonEffect()~=se) then return false end
	local code1,code2=c:GetPreviousCodeOnField()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and (code1==11451631 or code2==11451631)
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(cm.actfilter,1,nil,se) and (not eg:IsContains(e:GetHandler()) or e:GetHandler():IsLocation(LOCATION_HAND))
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetLabel(0)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	e1:SetCondition(cm.descon2)
	e1:SetTarget(cm.destg2)
	e1:SetOperation(cm.desop2)
	Duel.RegisterEffect(e1,tp)
end
function cm.descon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function cm.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function cm.GetCardsInZone(tp,fd)
	if fd==0x400020 then return Duel.GetFieldCard(tp,LOCATION_MZONE,5) or Duel.GetFieldCard(1-tp,LOCATION_MZONE,6) end
	if fd==0x200040 then return Duel.GetFieldCard(tp,LOCATION_MZONE,6) or Duel.GetFieldCard(1-tp,LOCATION_MZONE,5) end
	local seq=math.log(fd,2)
	local p=tp
	if seq>=16 then
		p=1-tp
		seq=seq-16
	end
	local loc=LOCATION_MZONE
	if seq>=8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	return Duel.GetFieldCard(p,loc,math.floor(seq+0.5))
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local sp=tp
		local op=1
		if Duel.IsPlayerAffectedByEffect(tp,11451676) then
			local a1=(tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
			local a2=(tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0)
			local b1=tc:GetActivateEffect():IsActivatable(tp,true,true)
			local b2=tc:IsSSetable(true)
			op=aux.SelectFromOptions(tp,{a1 and b1,aux.Stringid(11451631,3)},{a2 and b1,aux.Stringid(11451631,4)},{a1 and b2,aux.Stringid(11451631,8)},{a2 and b2,aux.Stringid(11451631,9)})
			if op==2 or op==4 then sp=1-tp end
		end
		if op<=2 then
			if tc:IsType(TYPE_FIELD) then
				local fc=Duel.GetFieldCard(sp,LOCATION_FZONE,0)
				if fc then
					if Duel.IsPlayerAffectedByEffect(tp,11451676) then
						Duel.Destroy(fc,REASON_RULE)
					else
						Duel.SendtoGrave(fc,REASON_RULE)
						Duel.BreakEffect()
					end
				end
				Duel.MoveToField(tc,tp,sp,LOCATION_FZONE,POS_FACEUP,true)
				local te=tc:GetActivateEffect()
				local tep=tc:GetControler()
				local cost=te:GetCost()
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
				Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
			else
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451675,0))
				local fd=0xff
				if Duel.IsPlayerAffectedByEffect(tp,11451676) then
					if sp==tp then
						fd=Duel.SelectField(tp,1,LOCATION_SZONE,0,0x20002000)
					else
						fd=Duel.SelectField(tp,1,0,LOCATION_SZONE,0x20002000)
					end
					local fc=cm.GetCardsInZone(tp,fd)
					if fc then Duel.Destroy(fc,REASON_RULE) end
					fd=fd>>8
					if sp~=tp then fd=fd>>16 end
				end
				Duel.MoveToField(tc,tp,sp,LOCATION_SZONE,POS_FACEUP,true,fd)
				local te=tc:GetActivateEffect()
				local tep=tc:GetControler()
				local cost=te:GetCost()
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			end
		else
			if tc:IsType(TYPE_FIELD) then
				local fc=Duel.GetFieldCard(sp,LOCATION_FZONE,0)
				if fc and Duel.IsPlayerAffectedByEffect(tp,11451676) then
					Duel.Destroy(fc,REASON_RULE)
				end
				Duel.SSet(tp,tc,sp)
			else
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451675,0))
				local fd=0xff
				if Duel.IsPlayerAffectedByEffect(tp,11451676) then
					if sp==tp then
						fd=Duel.SelectField(tp,1,LOCATION_SZONE,0,0x20002000)
					else
						fd=Duel.SelectField(tp,1,0,LOCATION_SZONE,0x20002000)
					end
					local fc=cm.GetCardsInZone(tp,fd)
					if fc then Duel.Destroy(fc,REASON_RULE) end
					fd=fd>>8
					if sp~=tp then fd=fd>>16 end
				end
				Duel.MoveToField(tc,tp,sp,LOCATION_SZONE,POS_FACEDOWN,false,fd)
				Duel.ConfirmCards(1-sp,tc)
				tc:SetStatus(STATUS_SET_TURN,true)
				Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,ev)
			end
		end
	end
end

function cm.RegisterMergedEvent_ToSingleCard(c,code,events)
	local g=Group.CreateGroup()
	g:KeepAlive()
	local mt=getmetatable(c)
	local seed=0
	if type(events) == "table" then
		for _, event in ipairs(events) do
			seed = seed + event
		end
	else
		seed = events
	end
	while(mt[seed]==true) do
		seed = seed + 1
	end
	mt[seed]=true
	local event_code_single = (code ~ (seed << 16)) | EVENT_CUSTOM
	if type(events) == "table" then
		for _, event in ipairs(events) do
			cm.RegisterMergedEvent_ToSingleCard_AddOperation(c,g,event,event_code_single)
		end
	else
		cm.RegisterMergedEvent_ToSingleCard_AddOperation(c,g,events,event_code_single)
	end
	--listened to again
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(EVENT_MOVE)
	e3:SetLabelObject(g)
	e3:SetOperation(cm.ThisCardMovedToPublicResetCheck_ToSingleCard)
	c:RegisterEffect(e3)
	return event_code_single
end
function cm.RegisterMergedEvent_ToSingleCard_AddOperation(c,g,event,event_code_single)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(event)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(0xff)
	e1:SetLabel(event_code_single)
	e1:SetLabelObject(g)
	e1:SetOperation(cm.MergedDelayEventCheck1_ToSingleCard)
	c:RegisterEffect(e1)
	local ec={
		EVENT_CHAIN_ACTIVATING,
		EVENT_CHAINING,
		EVENT_ATTACK_ANNOUNCE,
		EVENT_BREAK_EFFECT,
		EVENT_CHAIN_SOLVING,
		EVENT_CHAIN_SOLVED,
		EVENT_CHAIN_END,
		EVENT_SUMMON,
		EVENT_SPSUMMON,
		EVENT_MSET,
		EVENT_BATTLE_DESTROYED
	}
	for _,code in ipairs(ec) do
		local ce=e1:Clone()
		ce:SetCode(code)
		ce:SetOperation(cm.MergedDelayEventCheck2_ToSingleCard)
		c:RegisterEffect(ce)
	end
end
function cm.MergedDelayEventCheck1_ToSingleCard(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local c=e:GetOwner()
	g:Merge(eg)
	if Duel.CheckEvent(EVENT_MOVE) then
		local _,meg=Duel.CheckEvent(EVENT_MOVE,true)
		if meg:IsContains(c) and (c:IsFaceup() or c:IsPublic()) then
			g:Clear()
		end
	end
	if Duel.GetCurrentChain()==0 and #g>0 and not g:IsExists(function(c) return c:GetEquipCount()>0 or c:GetOverlayCount()>0 end,1,nil) then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,e:GetLabel(),re,r,rp,ep,ev)
		g:Clear()
	end
end
function cm.MergedDelayEventCheck2_ToSingleCard(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if Duel.CheckEvent(EVENT_MOVE) then
		local _,meg=Duel.CheckEvent(EVENT_MOVE,true)
		local c=e:GetOwner()
		if meg:IsContains(c) and (c:IsFaceup() or c:IsPublic()) then
			g:Clear()
		end
	end
	if #g>0 then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,e:GetLabel(),re,r,rp,ep,ev)
		g:Clear()
	end
end
function cm.ThisCardMovedToPublicResetCheck_ToSingleCard(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local g=e:GetLabelObject()
	if c:IsFaceup() or c:IsPublic() then
		g:Clear()
	end
end