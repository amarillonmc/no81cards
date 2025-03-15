--悠远之扉：因果
local cm,m=GetID()
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1166)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.LinkCondition(nil,2,2))
	e0:SetTarget(cm.LinkTarget(nil,2,2))
	e0:SetOperation(cm.LinkOperation(nil,2,2))
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	--[[local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(cm.effcon)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)--]]
	--addition
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.chcon)
	e4:SetOperation(cm.chop)
	--c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local _IsActiveType=Effect.IsActiveType
		local _GetActiveType=Effect.GetActiveType
		local _NegateActivation=Duel.NegateActivation
		local _ChangeChainOperation=Duel.ChangeChainOperation
		function Effect.GetActiveType(e)
			if e:GetDescription()==aux.Stringid(m,0) then
				return TYPE_TRAP+TYPE_COUNTER
			end
			return _GetActiveType(e)
		end
		function Effect.IsActiveType(e,typ)
			local typ2=e:GetActiveType()
			return typ&typ2~=0
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
		function Duel.ChangeChainOperation(ev,...)
			local re=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
			if aux.GetValueType(re)=="Effect" then
				local rc=re:GetHandler()
				if rc and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) and re:GetDescription()==aux.Stringid(m,0) then
					rc:CancelToGrave(false)
				end
			end
			return _ChangeChainOperation(ev,...)
		end
	end
end
function cm.fdfilter(c)
	return c:IsFacedown() and c:IsLocation(LOCATION_SZONE) and c:IsSetCard(0x97d) and c:GetActivateEffect() and not c:GetEquipTarget()
end
function cm.LConditionFilter(c,f,lc)
	return (((c:IsFaceup() or not c:IsOnField()) and c:IsCanBeLinkMaterial(lc)) or (Duel.GetFlagEffect(lc:GetControler(),m)<=Duel.GetTurnCount() and cm.fdfilter(c))) and (not f or f(c))
end
function cm.LConditionFilter2(c,f,lc)
	return (((c:IsFaceup() or not c:IsOnField()) and c:IsCanBeLinkMaterial(lc) and c:IsLocation(LOCATION_MZONE)) or (Duel.GetFlagEffect(lc:GetControler(),m)<=Duel.GetTurnCount() and cm.fdfilter(c))) and (not f or f(c))
end
function cm.GetLinkMaterials(tp,f,lc)
	local mg=Duel.GetMatchingGroup(cm.LConditionFilter2,tp,LOCATION_ONFIELD,0,nil,f,lc)
	local mg2=Duel.GetMatchingGroup(aux.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc,tp)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	return mg
end
function cm.LCheckGoal(sg,tp,lc,gf,lmat)
	return sg:CheckWithSumEqual(Auxiliary.GetLinkCount,lc:GetLink(),#sg,#sg) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg)) and not sg:IsExists(Auxiliary.LUncompatibilityFilter,1,nil,sg,lc,tp) and (not lmat or sg:IsContains(lmat)) and sg:FilterCount(cm.fdfilter,nil)<=Duel.GetTurnCount()-Duel.GetFlagEffect(tp,m)+1
end
function cm.LinkCondition(f,minc,maxc,gf)
	return  function(e,c,og,lmat,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og:Filter(cm.LConditionFilter,nil,f,c)
				else
					mg=cm.GetLinkMaterials(tp,f,c)
				end
				if lmat~=nil then
					if not cm.LConditionFilter(lmat,f,c) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(cm.LCheckGoal,minc,maxc,tp,c,gf,lmat)
			end
end
function cm.LinkTarget(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local mg=nil
				if og then
					mg=og:Filter(cm.LConditionFilter,nil,f,c)
				else
					mg=cm.GetLinkMaterials(tp,f,c)
				end
				if lmat~=nil then
					if not cm.LConditionFilter(lmat,f,c) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,cm.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function cm.LinkOperation(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				aux.LExtraMaterialCount(g,c,tp)
				g1=g:Filter(cm.fdfilter,nil)
				g:Sub(g1)
				for i=1,#g1 do Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1) end
				--Duel.SendtoDeck(g1,nil,2,REASON_MATERIAL+REASON_LINK)
				local cid=c:GetFieldID()
				c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1,cid)
				for oc in aux.Next(g1) do
					local te,te2=oc:GetActivateEffect()
					if te2 and oc:IsType(TYPE_TRAP) then te=te2 end
					local con=te:GetCondition()
					local tg=te:GetTarget()
					local op=te:GetOperation()
					local prop=te:GetProperty()
					local e1=Effect.CreateEffect(oc)
					e1:SetDescription(aux.Stringid(m,0))
					e1:SetCategory(te:GetCategory())
					e1:SetType(EFFECT_TYPE_QUICK_F)
					e1:SetCode(EVENT_SPSUMMON_SUCCESS)
					e1:SetProperty(prop|EFFECT_FLAG_SET_AVAILABLE)
					e1:SetRange(LOCATION_SZONE)
					e1:SetLabel(0)
					e1:SetLabelObject(c)
					--if con then e1:SetCondition(con) end
					--e1:SetCondition(function(e) Debug.Message(oc:GetCode()) return true end)
					e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
									local c=e:GetLabelObject()
									if chk==0 then return eg:IsContains(c) and c:GetFlagEffectLabel(m) and c:GetFlagEffectLabel(m)==cid end
								end)
					if tg then e1:SetTarget(cm.btg(tg)) end
					if op then e1:SetOperation(op) end
					--e1:SetReset(RESET_PHASE+PHASE_END)
					oc:RegisterEffect(e1,true)
					local e2=e1:Clone()
					e2:SetCode(EVENT_SPSUMMON_NEGATED)
					oc:RegisterEffect(e2,true)
					local e4=Effect.CreateEffect(c)
					e4:SetType(EFFECT_TYPE_FIELD)
					e4:SetCode(EFFECT_ACTIVATE_COST)
					--e4:SetRange(LOCATION_SZONE)
					e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e4:SetTargetRange(1,0)
					e4:SetTarget(function(e,te,tp) e:SetLabelObject(te) return te==e1 or te==e2 end) --oc==te:GetHandler() and te:IsHasType(EFFECT_TYPE_QUICK_F) end)
					e4:SetOperation(cm.costop)
					e4:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e4,tp)
				end
				if #g1>0 then
					--g1:KeepAlive()
					Duel.ConfirmCards(1-tp,g1)
					--Duel.RaiseEvent(g1,EVENT_CUSTOM+m,e,0,0,0,0)
				end
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
			end
end
function cm.addcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetLabelObject()
	if chk==0 then return eg:IsContains(c) and c:GetFlagEffectLabel(m) and c:GetFlagEffectLabel(m)==e:GetLabel() end
end
function cm.btg(tg)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				if chkc then return tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
				if chk==0 then return true end
				local c=e:GetLabelObject()
				c:ResetFlagEffect(m)
				tg(e,tp,eg,ep,ev,re,r,rp,1)
			end
end
function cm.bop(op)
	return function(e,tp,eg,ep,ev,re,r,rp)
				_NegateActivation=Duel.NegateActivation
				Duel.NegateActivation=aux.TRUE
				op(e,tp,eg,ep,ev,re,r,rp)
				Duel.NegateActivation=_NegateActivation
			end
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	Duel.ChangePosition(tc,POS_FACEUP)
	tc:SetStatus(STATUS_EFFECT_ENABLED,false)
	if tc:IsType(TYPE_COUNTER) then te:SetType(EFFECT_TYPE_QUICK_F+EFFECT_TYPE_ACTIVATE) else te:SetType(EFFECT_TYPE_QUICK_F+EFFECT_TYPE_ACTIVATE) end
	tc:CreateEffectRelation(te)
	local c=e:GetHandler()
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
	local e3=e1:Clone()
	e3:SetCode(EVENT_CHAIN_ACTIVATING)
	e3:SetCondition(aux.TRUE)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) te:SetType(EFFECT_TYPE_QUICK_F+EFFECT_TYPE_ACTIVATE) end)
	--Duel.RegisterEffect(e3,tp)
	e:Reset()
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	--re:SetType(EFFECT_TYPE_QUICK_F+EFFECT_TYPE_ACTIVATE)
	if e:GetCode()==EVENT_CHAIN_SOLVING and rc:IsRelateToEffect(re) then
		--rc:SetStatus(STATUS_EFFECT_ENABLED,true)
		local _NegateActivation=Duel.NegateActivation
		Duel.NegateActivation=aux.TRUE
		local ev0=ev
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetCountLimit(1)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) Duel.NegateActivation=_NegateActivation end)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
		rc:CancelToGrave(false)
	end
	--re:Reset() --boom!!!
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) and re:GetHandler():IsSetCard(0x97d) and re:GetHandler():GetType()&0x100004==0x100004 and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.addition(e,tp,eg,ep,ev,re,r,rp)
	while 1==1 do
		local off=1
		local ops={} 
		local opval={}
		local b1=e:GetLabel()&0x1>0
		local b2=e:GetLabel()&0x2>0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		local b3=e:GetLabel()&0x4>0 and re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsAbleToRemove()
		local b4=e:GetLabel()&0x8>0
		local b5=e:GetLabel()&0x10>0 and Duel.IsPlayerCanDraw(tp,1)
		local b6=e:GetLabel()&0x20>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		local b7=e:GetLabel()&0x40>0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
		local b8=e:GetLabel()&0x80>0
		if b1 then
			ops[off]=aux.Stringid(11451505,1)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(11451506,1)
			opval[off-1]=2
			off=off+1
		end
		if b3 then
			ops[off]=aux.Stringid(11451507,1)
			opval[off-1]=3
			off=off+1
		end
		if b4 then
			ops[off]=aux.Stringid(11451508,1)
			opval[off-1]=4
			off=off+1
		end
		if b5 then
			ops[off]=aux.Stringid(11451509,1)
			opval[off-1]=5
			off=off+1
		end
		if b6 then
			ops[off]=aux.Stringid(11451510,1)
			opval[off-1]=6
			off=off+1
		end
		if b7 then
			ops[off]=aux.Stringid(9310055,1)
			opval[off-1]=7
			off=off+1
		end
		if b8 then
			cm.regsop(e,tp,eg,ep,ev,re,r,rp)
		end
		if off==1 then break end
		ops[off]=aux.Stringid(11451505,2)
		opval[off-1]=8
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
			e:SetLabel(e:GetLabel()&~0x1)
			Duel.NegateActivation(ev)
		elseif opval[op]==2 then
			e:SetLabel(e:GetLabel()&~0x2)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(g)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		elseif opval[op]==3 then
			e:SetLabel(e:GetLabel()&~0x4)
			Duel.Remove(re:GetHandler(),POS_FACEUP,REASON_EFFECT)
		elseif opval[op]==4 then
			e:SetLabel(e:GetLabel()&~0x8)
			Duel.Damage(ep,2200,REASON_EFFECT)
		elseif opval[op]==5 then
			e:SetLabel(e:GetLabel()&~0x10)
			Duel.Draw(tp,1,REASON_EFFECT)
		elseif opval[op]==6 then
			e:SetLabel(e:GetLabel()&~0x20)
			Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		elseif opval[op]==7 then
			e:SetLabel(e:GetLabel()&~0x40)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,2,nil)
			if #g>0 then
				Duel.HintSelection(g)
				Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			end
		elseif opval[op]==8 then break end
	end
end
function cm.regsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetDescription(aux.Stringid(11451927,2))
	e1:SetCountLimit(1)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	Duel.RegisterEffect(e2,1-tp)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetCondition(cm.disscon)
	e3:SetOperation(cm.dissop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(cm.indtg)
	e4:SetValue(function() e:SetLabel(1) return 1 end)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end
function cm.indtg(e,c)
	local tc=e:GetHandler()
	return (c==tc or c==tc:GetBattleTarget()) and c:IsFaceup() and e:GetLabel()==0
end
function cm.disscon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL)
end
function cm.dissop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
	e:Reset()
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) and re:GetHandler():IsSetCard(0x97d) and re:GetHandler():GetType()&0x100004==0x100004 and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.addition(e,tp,eg,ep,ev,re,r,rp)
	while 1==1 do
		local off=1
		local ops={} 
		local opval={}
		local b1=e:GetLabel()&0x1>0
		local b2=e:GetLabel()&0x2>0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		local b3=e:GetLabel()&0x4>0 and re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsAbleToRemove()
		local b4=e:GetLabel()&0x8>0
		local b5=e:GetLabel()&0x10>0 and Duel.IsPlayerCanDraw(tp,1)
		local b6=e:GetLabel()&0x20>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		local b7=e:GetLabel()&0x40>0 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
		local b8=e:GetLabel()&0x80>0 and Duel.GetTurnPlayer()==tp
		if b1 then
			ops[off]=aux.Stringid(11451505,1)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(11451506,1)
			opval[off-1]=2
			off=off+1
		end
		if b3 then
			ops[off]=aux.Stringid(11451507,1)
			opval[off-1]=3
			off=off+1
		end
		if b4 then
			ops[off]=aux.Stringid(11451508,1)
			opval[off-1]=4
			off=off+1
		end
		if b5 then
			ops[off]=aux.Stringid(11451509,1)
			opval[off-1]=5
			off=off+1
		end
		if b6 then
			ops[off]=aux.Stringid(11451510,1)
			opval[off-1]=6
			off=off+1
		end
		if b7 then
			ops[off]=aux.Stringid(9310055,1)
			opval[off-1]=7
			off=off+1
		end
		if b8 then
			cm.regsop(e,tp,eg,ep,ev,re,r,rp)
		end
		if off==1 then break end
		ops[off]=aux.Stringid(11451505,2)
		opval[off-1]=8
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
			e:SetLabel(e:GetLabel()&~0x1)
			Duel.NegateActivation(ev)
		elseif opval[op]==2 then
			e:SetLabel(e:GetLabel()&~0x2)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(g)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		elseif opval[op]==3 then
			e:SetLabel(e:GetLabel()&~0x4)
			Duel.Remove(re:GetHandler(),POS_FACEUP,REASON_EFFECT)
		elseif opval[op]==4 then
			e:SetLabel(e:GetLabel()&~0x8)
			Duel.Damage(ep,2200,REASON_EFFECT)
		elseif opval[op]==5 then
			e:SetLabel(e:GetLabel()&~0x10)
			Duel.Draw(tp,1,REASON_EFFECT)
		elseif opval[op]==6 then
			e:SetLabel(e:GetLabel()&~0x20)
			Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		elseif opval[op]==7 then
			e:SetLabel(e:GetLabel()&~0x40)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,2,nil)
			if #g>0 then
				Duel.HintSelection(g)
				Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			end
		elseif opval[op]==8 then break end
	end
end
function cm.regsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--if Duel.GetFlagEffect(tp,11451928)>0 then return end
	--Duel.RegisterFlagEffect(tp,11451928,RESET_PHASE+PHASE_END,0,1)
	--activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetDescription(aux.Stringid(11451927,2))
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCondition(function() return Duel.GetTurnPlayer()==tp end)
	e1:SetTargetRange(LOCATION_HAND,0)
	--e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	Duel.RegisterEffect(e2,1-tp)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetCondition(cm.disscon)
	e3:SetOperation(cm.dissop)
	--e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCondition(function() return Duel.GetTurnPlayer()==tp end)
	e4:SetTarget(cm.indtg)
	e4:SetValue(function(e) e:SetLabel(1) return 1 end)
	--e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end
function cm.indtg(e,c)
	local tc=e:GetHandler()
	return c:IsFaceup() and e:GetLabel()==0
end
function cm.disscon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and Duel.GetTurnPlayer()==tp
end
function cm.dissop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(re:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
	e:Reset()
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetLabel()&0xbf~=0 then re:SetLabel(re:GetLabel()|0x80) return end
	re:SetLabel(re:GetLabel()|0x80)
	local op=re:GetOperation()
	local repop=function(e,tp,eg,ep,ev,re,r,rp)
		op(e,tp,eg,ep,ev,re,r,rp)
		cm.addition(e,tp,eg,ep,ev,re,r,rp)
	end
	if re:GetHandler():GetOriginalCode()==11451510 or (aux.GetValueType(re:GetLabelObject())=="Effect" and re:GetLabelObject():GetHandler():GetOriginalCode()==11451510) then
		repop=function(e,tp,eg,ep,ev,re,r,rp)
			cm.addition(e,tp,eg,ep,ev,re,r,rp)
			op(e,tp,eg,ep,ev,re,r,rp)
		end
	end
	re:SetOperation(repop)
end