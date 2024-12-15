--电送拟人 失控念动人
local cm,m=GetID()
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.filter0,2,true)
	aux.AddContactFusionProcedure(c,cm.filter,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,Duel.Remove,POS_FACEUP,REASON_COST)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_MOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.sumcon)
	e3:SetTarget(cm.sumtg)
	e3:SetOperation(cm.sumop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_LEAVE_GRAVE)
	e4:SetCondition(aux.TRUE)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		cm[0]={}
		cm[1]={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MOVE)
		ge1:SetOperation(cm.chkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_LEAVE_GRAVE)
		ge2:SetOperation(cm.chkop2)
		Duel.RegisterEffect(ge2,0)
	end
	if not cm.global_check2 then
		cm.global_check2=true
		local _Equip=Duel.Equip
		Duel.Equip=function(p,c,...)
			if not c:IsOnField() then c:RegisterFlagEffect(m-4,RESET_CHAIN,0,1) end
			local res=_Equip(p,c,...)
			return res
		end
		local _CRegisterEffect=Card.RegisterEffect
		function Card.RegisterEffect(c,e,...)
			local res=_CRegisterEffect(c,e,...)
			if e:GetCode()==EFFECT_EQUIP_LIMIT and c:GetFlagEffect(m-4)>0 then
				c:ResetFlagEffect(m-4)
				Duel.RaiseEvent(Group.FromCards(c),EVENT_CUSTOM+m,e,0,0,0,0)
			end
			return res
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
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
	if c:GetFlagEffect(m-4)==0 then c:RegisterFlagEffect(m-4,RESET_EVENT+RESETS_STANDARD,0,1) end
	return false
end
function cm.filter12(c,e)
	if not (c:IsOnField() and (c:IsFacedown() or c:IsStatus(STATUS_EFFECT_ENABLED))) or c:GetFlagEffect(m-4)>0 then return false end
	if e:GetCode()==EVENT_MOVE then
		local b1,g1=Duel.CheckEvent(EVENT_SUMMON_SUCCESS,true)
		local b2,g2=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
		return not c:IsPreviousLocation(LOCATION_ONFIELD) and (not b1 or not g1:IsContains(c)) and (not b2 or not g2:IsContains(c))
	end
	return not (e:GetCode()==EVENT_SUMMON_SUCCESS and c:GetFlagEffect(m-4)>0)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter12,1,nil,e)
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,ev)
end
function cm.descon3(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():GetFieldID()==re:GetHandler():GetRealFieldID()
end
function cm.desop3(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,ev)
end
function cm.chkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_MZONE) and tc:IsPreviousLocation(LOCATION_MZONE) and (tc:GetPreviousSequence()~=tc:GetSequence() or tc:GetPreviousControler()~=tc:GetControler()) then
			tc:RegisterFlagEffect(m+rp,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
			cm[rp][tc:GetCode()]=true
			--Debug.Message(rp)
			--Debug.Message(tc:GetCode())
		end
		tc=eg:GetNext()
	end
end
function cm.chkop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(m+rp,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
		cm[rp][tc:GetCode()]=true
		--Debug.Message(rp)
		--Debug.Message(tc:GetCode())
		tc=eg:GetNext()
	end
end
function cm.filter0(c,fc)
	local rp=fc:GetControler() or 0
	return c:GetFlagEffect(m+rp)>0 or cm[rp][c:GetCode()]
end
function cm.filter(c,fc)
	local rp=fc:GetControler() or 0
	return c:IsAbleToRemoveAsCost() and ((c:IsOnField() and c:GetFlagEffect(m+rp)>0) or (c:IsLocation(LOCATION_GRAVE) and cm[rp][c:GetCode()])) --and not (c:IsOnField() and c:IsFacedown() and c:IsControler(1-rp))
end
function cm.cfilter(c)
	return c:IsPreviousLocation(LOCATION_DECK) and not (c:IsLocation(LOCATION_DECK) and c:IsControler(c:GetPreviousControler()))
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(m-4)==0 end
	e:GetHandler():RegisterFlagEffect(m-4,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,0x1973,1)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0,0)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	local tc=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,0x1973,1):GetFirst()
	if tc then
		tc:AddCounter(0x1973,1)
		tc:SetCounterLimit(0x1973,1)
		if not cm[2] then
			cm[2]=true
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CUSTOM+m)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCondition(cm.descon11)
			e1:SetOperation(cm.desop11)
			Duel.RegisterEffect(e1,0)
		end
	end
end
function cm.descon11(e,tp,eg,ep,ev,re,r,rp)
	return eg and #eg>0 and not pnfl_adjusting
end
function cm.desop11(e,tp,eg,ep,ev,re,r,rp)
	pnfl_adjusting=true
	local g=Duel.GetMatchingGroup(function(c) return c:GetCounter(0x1973)>0 end,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local hg=eg:Filter(Card.IsPreviousLocation,nil,LOCATION_HAND)
	local left=#hg>0 --==#eg
	if #g>0 then
		for p=0,1 do
			for loc=LOCATION_SZONE,LOCATION_MZONE,LOCATION_MZONE-LOCATION_SZONE do
				if left then
					for seq=0,4 do
						local c=Duel.GetFieldCard(p,loc,seq)
						if c and g:IsContains(c) then
							--local left=#hg>0 and seq>0
							--if left and #(eg-hg)>0 and seq<4 then left=false end --Duel.SelectEffectYesNo(p,c,aux.Stringid(m,1)) end
							if left and seq>0 then
								--Duel.HintSelection(Group.FromCards(c))
								--Duel.Hint(HINT_CARD,0,eg:GetFirst():GetCode())
								local e1=Effect.CreateEffect(c)
								e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
								e1:SetCode(m)
								e1:SetOperation(function()
													local tc=Duel.GetFieldCard(p,loc,seq-1)
													if tc then Duel.Destroy(tc,REASON_RULE) end
													if Duel.CheckLocation(p,loc,seq-1) then Duel.MoveSequence(c,seq-1) end
												end)
								Duel.RegisterEffect(e1,c:GetControler())
								Duel.RaiseEvent(c,m,e,0,0,0,0)
								e1:Reset()
							elseif #(eg-hg)>0 and seq<4 then
								local e1=Effect.CreateEffect(c)
								e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
								e1:SetCode(m)
								e1:SetOperation(function()
													local tc=Duel.GetFieldCard(p,loc,seq+1)
													if tc then Duel.Destroy(tc,REASON_RULE) end
													if Duel.CheckLocation(p,loc,seq+1) then Duel.MoveSequence(c,seq+1) end
												end)
								Duel.RegisterEffect(e1,c:GetControler())
								Duel.RaiseEvent(c,m,e,0,0,0,0)
								e1:Reset()
							end
						end
					end
				else
					for seq=4,0,-1 do
						local c=Duel.GetFieldCard(p,loc,seq)
						if c and g:IsContains(c) then
							--local left=#hg>0 and seq>0
							--if left and #(eg-hg)>0 and seq<4 then left=false end --Duel.SelectEffectYesNo(p,c,aux.Stringid(m,1)) end
							if left and seq>0 then
								local e1=Effect.CreateEffect(c)
								e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
								e1:SetCode(m)
								e1:SetOperation(function()
													local tc=Duel.GetFieldCard(p,loc,seq-1)
													if tc then Duel.Destroy(tc,REASON_RULE) end
													if Duel.CheckLocation(p,loc,seq-1) then Duel.MoveSequence(c,seq-1) end
												end)
								Duel.RegisterEffect(e1,c:GetControler())
								Duel.RaiseEvent(c,m,e,0,0,0,0)
								e1:Reset()
							elseif #(eg-hg)>0 and seq<4 then
								local e1=Effect.CreateEffect(c)
								e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
								e1:SetCode(m)
								e1:SetOperation(function()
													local tc=Duel.GetFieldCard(p,loc,seq+1)
													if tc then Duel.Destroy(tc,REASON_RULE) end
													if Duel.CheckLocation(p,loc,seq+1) then Duel.MoveSequence(c,seq+1) end
												end)
								Duel.RegisterEffect(e1,c:GetControler())
								Duel.RaiseEvent(c,m,e,0,0,0,0)
								e1:Reset()
							end
						end
					end
				end
			end
		end
	end
	pnfl_adjusting=false
end