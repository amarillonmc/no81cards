--异绛胧烈刃·核磁频谱
local cm,m=GetID()
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_FIRE),true)
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11451711,4))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.retg)
	e1:SetOperation(cm.reop)
	c:RegisterEffect(e1)
	--cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCode(m)
	c:RegisterEffect(e2)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e6:SetRange(LOCATION_EXTRA)
	e6:SetTargetRange(LOCATION_SZONE,0)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetCost(cm.efcost)
	e6:SetTarget(cm.eftg)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	c:RegisterEffect(e7)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_ACTIVATE_COST)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetCondition(cm.costcon)
	e5:SetTarget(cm.actarget2)
	e5:SetOperation(cm.costop2)
	c:RegisterEffect(e5)
end
function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	local t={}
	local i=1
	for i=1,7 do t[i]=i+2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NUMBER)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451011,2))
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if c:IsRelateToEffect(e) and Duel.Remove(c,nil,REASON_EFFECT+REASON_TEMPORARY)~=0 and c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_MOVE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
		e2:SetCondition(cm.mvcon)
		e2:SetOperation(cm.mvop1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		e:UseCountLimit(tp,1)
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451011,2))
		c:RegisterFlagEffect(11451717,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,ct,aux.Stringid(11451717,ct-3))
		c:RegisterFlagEffect(11451718,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,9-ct,aux.Stringid(11451718,9-ct))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetLabel(c:GetFieldID())
		e1:SetLabelObject(c)
		e1:SetCondition(cm.retcon)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local flag=c:GetFlagEffectLabel(11451718)
	if not flag or e:GetLabel()~=c:GetFieldID() then
		e:Reset()
	elseif flag>=9 then
		c:ResetFlagEffect(11451718)
		Duel.ReturnToField(c)
		e:Reset()
	else
		flag=flag+1
		c:ResetFlagEffect(11451718)
		c:RegisterFlagEffect(11451718,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,flag,aux.Stringid(11451718,flag))
	end
end
function cm.mvcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON) and not c:IsReason(REASON_SUMMON) and c:GetFlagEffect(11451717)>0
end
function cm.mvop1(e,tp,eg,ep,ev,re,r,rp)
	local n=11451718
	local cn=_G["c"..n]
	local chk=false
	local c=e:GetHandler()
	local lab=c:GetFlagEffectLabel(11451717)
	while 1==1 do
		local off=1
		local ops={} 
		local opval={}
		if cm.mvop(e,tp,eg,ep,ev,re,r,rp,2,lab) and not chk then
			ops[off]=aux.Stringid(n,10)
			opval[off-1]=1
			off=off+1
		end
		for i=11451711,11451715 do
			local ci=_G["c"..i]
			if ci and cn and cn[i] and Duel.GetFlagEffect(tp,0xffffff+i)==0 and ci.mvop and ci.mvop(e,tp,eg,ep,ev,re,r,rp,2,lab) then
				ops[off]=aux.Stringid(i,3)
				opval[off-1]=i-11451709
				off=off+1
			end
		end
		if off==1 then break end
		ops[off]=aux.Stringid(n,11)
		opval[off-1]=7
		--mobile adaption
		local ops2=ops
		local op=-1
		if off<=5 then
			op=Duel.SelectOption(tp,table.unpack(ops))
		else
			local page=0
			while op==-1 do
				if page==0 then
					ops2={table.unpack(ops,1,4)}
					table.insert(ops2,aux.Stringid(11451505,4))
					op=Duel.SelectOption(tp,table.unpack(ops2))
					if op==4 then op=-1 page=1 end
				else
					ops2={table.unpack(ops,5,off)}
					table.insert(ops2,1,aux.Stringid(11451505,3))
					op=Duel.SelectOption(tp,table.unpack(ops2))+3
					if op==3 then op=-1 page=0 end
				end
			end
		end
		if opval[op]==1 then
			cm.mvop(e,tp,eg,ep,ev,re,r,rp,0,lab)
			chk=true
		elseif opval[op]>=2 and opval[op]<=6 then
			local ci=_G["c"..opval[op]+11451709]
			ci.mvop(e,tp,eg,ep,ev,re,r,rp,1,lab)
		elseif opval[op]==7 then break end
	end
end
function cm.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x3977)
end
function cm.tsfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp,opt,lab)
	local c=e:GetHandler()
	local ct=lab//4
	local b1=0
	local fid=e:GetLabel()
	if fid~=0 then b1=1 end
	local chk=false
	local g2=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_GRAVE,0,nil)
	local g1=Duel.GetMatchingGroup(cm.tsfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if ct>=1 and #g1>0 and #g2>0 then
		if opt==2 then return true end
		Duel.HintSelection(Group.FromCards(c))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local fc=g1:Select(tp,1,1,nil):GetFirst()
		local tc=g2:Select(tp,1,1,nil):GetFirst()
		local code=tc:GetOriginalCode()
		if not fc:IsImmuneToEffect(e) then
			if tc:GetOriginalType()&TYPE_NORMAL==0 then
				fc:ReplaceEffect(code,RESET_EVENT+RESETS_STANDARD,1)
			else
				local ini=cm.initial_effect
				cm.initial_effect=function() end
				fc:ReplaceEffect(m,RESET_EVENT+RESETS_STANDARD,1)
				cm.initial_effect=ini
			end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(1,1)
			e1:SetValue(function(e,te) return te:GetHandler()==e:GetHandler() and not te:IsHasProperty(EFFECT_FLAG_COPY) and (te:GetCode()~=EVENT_FREE_CHAIN or te:GetType()&(~0x10a)>0) end)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			fc:RegisterEffect(e1,true)
			Duel.HintSelection(Group.FromCards(fc))
			Duel.Hint(HINT_CODE,tp,code)
			fc:SetHint(CHINT_CARD,code)
		end
		if ct>1 and #g1>0 and #g2>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local fg=g1:CancelableSelect(tp,1,1,nil)
			if fg then
				local fc=fg:GetFirst()
				local tc=g2:Select(tp,1,1,nil):GetFirst()
				local code=tc:GetOriginalCode()
				if not fc:IsImmuneToEffect(e) then
					if tc:GetOriginalType()&TYPE_NORMAL==0 then
						fc:ReplaceEffect(code,RESET_EVENT+RESETS_STANDARD,1)
					else
						local ini=cm.initial_effect
						cm.initial_effect=function() end
						fc:ReplaceEffect(m,RESET_EVENT+RESETS_STANDARD,1)
						cm.initial_effect=ini
					end
					Duel.HintSelection(Group.FromCards(fc))
					Duel.Hint(HINT_CODE,tp,code)
					fc:SetHint(CHINT_CARD,code)
				end
			end
		end
	end
end
function cm.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function cm.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.filter2(c,e,tp,mg,f,chkf)
	if not (c:IsType(TYPE_FUSION) and c:IsHasEffect(m) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)) then return false end
	aux.FCheckAdditional=cm.fcheck
	local res=c:CheckFusionMaterial(mg,nil,chkf)
	aux.FCheckAdditional=nil
	return res
end
function cm.fcheck(tp,sg,fc)
	return #sg<=2 and sg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) and sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK)
end
function cm.eftg(e,c)
	if not c:IsSetCard(0x3977) then return false end
	local tp=c:GetControler()
	local te=c:GetActivateEffect()
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_HAND)
	local mg2=Duel.GetMatchingGroup(cm.filter0,tp,LOCATION_DECK,0,nil)
	mg1:Merge(mg2)
	local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,te,tp,mg1,nil,chkf)
	if not res then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,te,tp,mg2,mf,chkf)
		end
	end
	e:SetLabelObject(te)
	return res
end
function cm.efcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local te=e:GetLabelObject()
	Duel.ConfirmCards(1-tp,e:GetHandler())
	local op0=te:GetOperation() or (function() end)
	local op2=function(e,tp,eg,ep,ev,re,r,rp)
				e:SetOperation(op0)
				op0(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				local chkf=tp
				local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_HAND):Filter(cm.filter1,nil,e)
				local mg2=Duel.GetMatchingGroup(cm.filter0,tp,LOCATION_DECK,0,nil)
				mg1:Merge(mg2)
				local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
				local mg2=nil
				local sg2=nil
				local ce=Duel.GetChainMaterial(tp)
				if ce~=nil then
					local fgroup=ce:GetTarget()
					mg2=fgroup(ce,e,tp)
					local mf=ce:GetValue()
					sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
				end
				if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
					local sg=sg1:Clone()
					if sg2 then sg:Merge(sg2) end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local tg=sg:Select(tp,1,1,nil)
					local tc=tg:GetFirst()
					if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
						aux.FCheckAdditional=cm.fcheck
						local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
						aux.FCheckAdditional=nil
						tc:SetMaterial(mat1)
						Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
						Duel.BreakEffect()
						Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
					else
						local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
						local fop=ce:GetOperation()
						fop(ce,e,tp,tc,mat2)
					end
					tc:CompleteProcedure()
				end
			end
	te:SetOperation(op2)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetCurrentChain())
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==e:GetLabel() end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) re:SetOperation(op0) end)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function cm.costcon(e)
	cm[3]=false
	return true
end
function cm.actarget2(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler():IsSetCard(0x3977) and te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:GetHandler():IsFacedown() and te:GetHandler():IsOnField() and te:GetHandler():IsStatus(STATUS_SET_TURN) and not te:GetHandler():IsType(TYPE_QUICKPLAY) and not te:GetHandler():IsType(TYPE_TRAP)
end
function cm.costop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	if cm[3] then return end
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_HAND)
	local mg2=Duel.GetMatchingGroup(cm.filter0,tp,LOCATION_DECK,0,nil)
	mg1:Merge(mg2)
	local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,te,tp,mg1,nil,chkf)
	if not res then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,te,tp,mg2,mf,chkf)
		end
	end
	if res and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.ConfirmCards(1-tp,c)
		local op0=te:GetOperation() or (function() end)
		local op2=function(e,tp,eg,ep,ev,re,r,rp)
					e:SetOperation(op0)
					op0(e,tp,eg,ep,ev,re,r,rp)
					local c=e:GetHandler()
					local chkf=tp
					local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_HAND):Filter(cm.filter1,nil,e)
					local mg2=Duel.GetMatchingGroup(cm.filter0,tp,LOCATION_DECK,0,nil)
					mg1:Merge(mg2)
					local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
					local mg2=nil
					local sg2=nil
					local ce=Duel.GetChainMaterial(tp)
					if ce~=nil then
						local fgroup=ce:GetTarget()
						mg2=fgroup(ce,e,tp)
						local mf=ce:GetValue()
						sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
					end
					if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
						local sg=sg1:Clone()
						if sg2 then sg:Merge(sg2) end
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
						local tg=sg:Select(tp,1,1,nil)
						local tc=tg:GetFirst()
						if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
							aux.FCheckAdditional=cm.fcheck
							local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
							aux.FCheckAdditional=nil
							tc:SetMaterial(mat1)
							Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
							Duel.BreakEffect()
							Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
						else
							local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
							local fop=ce:GetOperation()
							fop(ce,e,tp,tc,mat2)
						end
						tc:CompleteProcedure()
					end
				end
		te:SetOperation(op2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetCurrentChain())
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==e:GetLabel() end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) re:SetOperation(op0) end)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(e2,tp)
	end
	cm[3]=true
end