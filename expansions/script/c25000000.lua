--芬尼根的守灵夜
local m=25000000
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.chain_rev then
		cm.chain_rev=true
		cm.chain_rev_tab={}
		cm.skip_check={{0,0,0,0,0},{0,0,0,0,0}}
		local re1=Effect.CreateEffect(c)
		re1:SetType(EFFECT_TYPE_FIELD)
		re1:SetCode(EFFECT_ACTIVATE_COST)
		re1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		re1:SetTargetRange(1,1)
		re1:SetTarget(cm.actarget)
		re1:SetCost(cm.costchk)
		re1:SetCondition(cm.condition2)
		re1:SetOperation(cm.costop)
		Duel.RegisterEffect(re1,tp)
	end
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,m)>0 or Duel.GetFlagEffect(1,m)>0
end
function cm.actarget(e,te,tp)
	e:SetLabelObject(te)
	return true
end
function cm.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,79323590)
	return true
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local cost=te:GetCost()
	local target=te:GetTarget()
	local operation=te:GetOperation()
	local code=te:GetHandler():GetOriginalCode()
	local evr=Duel.GetCurrentChain()+1
	if cost then
		te:SetCost(function(ce,ctp,ceg,cep,cev,cre,cr,crp,chk,chkc)
					if cost(ce,ctp,ceg,cep,cev,cre,cr,crp,0) then
						cm.chain_rev_tab[#cm.chain_rev_tab+1]={evr,ce,ctp,cost,target,operation,code}
						te:SetCost(cost)
						return true
					end
				end)
	end
	if target then
		te:SetTarget(function(ce,ctp,ceg,cep,cev,cre,cr,crp,chk,chkc)
						if target(ce,ctp,ceg,cep,cev,cre,cr,crp,0) then
							if not cost then
								cm.chain_rev_tab[#cm.chain_rev_tab+1]={evr,ce,ctp,cost,target,operation,code}
							end
							te:SetTarget(target)
							return true
						end
				end)
	end
	if not target and not cost then
		cm.chain_rev_tab[#cm.chain_rev_tab+1]={evr,ce,ctp,cost,target,operation,code}
	end
end
function cm.condition(e,tp)
	return true
end
function cm.activate(e,tp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.ConfirmCards(1-tp,e:GetHandler())
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,m)>0 or Duel.GetFlagEffect(1-tp,m)>0 then
		return 
	end
	Duel.RegisterFlagEffect(tp,m,0,0,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetOperation(cm.opdo)
	Duel.RegisterEffect(e1,tp)
	local g=Duel.GetMatchingGroup(nil,0,0x7f,0x7f,nil)
	for tc in aux.Next(g) do
		if tc:GetActivateEffect() then
			local ce=tc:GetActivateEffect():Clone()
			ce:SetRange(LOCATION_DECK)
			local pro,pro2=ce:GetProperty()
			ce:SetProperty(pro|EFFECT_FLAG_SET_AVAILABLE,pro2)
			tc:RegisterEffect(ce,true)
		elseif not c:IsSummonableCard() then
			local tpe=tc:GetOriginalType()
			tc:SetCardData(CARDDATA_TYPE,TYPE_MONSTER+TYPE_EFFECT)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetValue(tpe|TYPE_MONSTER|TYPE_EFFECT)
			tc:RegisterEffect(e1,true)
		end
	end
end
function cm.opdo(e,tp,eg,ep,ev,re,r,rp)
	local cev,effect_do,rtp,cost,target,operation,code=table.unpack(cm.chain_rev_tab[1])
	local reg,rep,rev,cre,cr,crp=Duel.GetChainEvent(cev)
	if cost then
		effect_do:SetCost(cost)
	end
	if target then
		effect_do:SetTarget(target)
	end
	Duel.ChangeChainOperation(0,cm.op2)
	Duel.ClearTargetCard()
	Duel.Hint(HINT_CARD,0,code)
	if cost then cost(effect_do,rtp,reg,rep,rev,cre,cr,crp,1) end
	if target then target(effect_do,rtp,reg,rep,rev,cre,cr,crp,1) end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g and g:GetCount()>0 then
		local ac=g:GetFirst()
		while ac do
			ac:CreateEffectRelation(effect_do)
			ac=g:GetNext()
		end
	end
	if cev==1 then
		Duel.RaiseEvent(e:GetHandler(),m,cre,cr,crp,cep,cev)
	end
	if operation then operation(effect_do,rtp,reg,rep,rev,cre,cr,crp) end
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsType(TYPE_PENDULUM) then
		re:GetHandler():CancelToGrave(true)
	end
	if g and g:GetCount()>0 then
		local sc=g:GetFirst()
		while sc do
			sc:ReleaseEffectRelation(effect_do)
			sc=g:GetNext()
		end
	end
	table.remove(cm.chain_rev_tab,1)
end
function cm.op2(e,tp)
	return false 
end