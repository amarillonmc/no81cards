--双月弹珠使·舞踊
local cm,m=GetID()
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_PENDULUM),1,2)
	--psuedo Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(0)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetLabelObject(e1)
	e3:SetTargetRange(1,0)
	e3:SetTarget(cm.actarget)
	e3:SetOperation(cm.costop)
	c:RegisterEffect(e3)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.drcon)
	e2:SetCost(cm.drcost)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
	--remain field
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		cm.activate_sequence={}
		local ge0=Effect.CreateEffect(c)
		ge0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge0:SetOperation(cm.geop)
		Duel.RegisterEffect(ge0,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetCondition(cm.regcon)
		ge1:SetOperation(cm.regop)
		--Duel.RegisterEffect(ge1,0)
		--disable
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetCode(EFFECT_DISABLE)
		e0:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e0:SetTarget(function(e,c) return c:IsOriginalSetCard(0x5977) and c:IsType(TYPE_TRAP) and c:IsHasEffect(EFFECT_DISABLE_TRAPMONSTER) and c:IsHasEffect(EFFECT_DISABLE_TRAPMONSTER):GetHandlerPlayer()==e:GetHandlerPlayer() end)
		Duel.RegisterEffect(e0,0)
		local e1=e0:Clone()
		Duel.RegisterEffect(e1,1)
		local _IsActiveType=Effect.IsActiveType
		local _GetActiveType=Effect.GetActiveType
		local _GetActivateLocation=Effect.GetActivateLocation
		local _GetActivateSequence=Effect.GetActivateSequence
		local _GetChainInfo=Duel.GetChainInfo
		local _ChangeChainOperation=Duel.ChangeChainOperation
		function Effect.GetActiveType(e)
			if e:GetDescription()==aux.Stringid(m,0) then
				return TYPE_TRAP
			end
			return _GetActiveType(e)
		end
		function Effect.IsActiveType(e,typ)
			local typ2=e:GetActiveType()
			return typ&typ2~=0
		end
		function Effect.GetActivateLocation(e)
			if e:GetDescription()==aux.Stringid(m,0) then
				return LOCATION_MZONE
			end
			return _GetActivateLocation(e)
		end
		function Effect.GetActivateSequence(e)
			if e:GetDescription()==aux.Stringid(m,0) then
				return cm.activate_sequence[e]
			end
			return _GetActivateSequence(e)
		end
		function Duel.GetChainInfo(ev,...)
			local ext_params={...}
			if #ext_params==0 then return _GetChainInfo(ev,...) end
			local re=_GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
			if aux.GetValueType(re)=="Effect" then
				local rc=re:GetHandler()
				if rc and re:GetDescription()==aux.Stringid(m,0) then
					local res={}
					for _,ci in ipairs(ext_params) do
						if ci==CHAININFO_TYPE or ci==CHAININFO_EXTTYPE then
							res[#res+1]=TYPE_TRAP
						else
							res[#res+1]=_GetChainInfo(ev,ci)
						end
					end
					return table.unpack(res)
				end
			end
			return _GetChainInfo(ev,...)
		end
		function Duel.ChangeChainOperation(ev,...)
			local re=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
			if aux.GetValueType(re)=="Effect" then
				local rc=re:GetHandler()
				if rc and rc:IsOnField() and re:GetDescription()==aux.Stringid(m,0) then
					rc:CancelToGrave(false)
				end
			end
			return _ChangeChainOperation(ev,...)
		end
	end
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function cm.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local v=0
	if eg:IsExists(cm.cfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(cm.cfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,e:GetLabel())
	elseif Duel.GetCurrentChain()>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetCountLimit(1)
		e1:SetOperation(function()
							Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,ep,e:GetLabel())
							e:Reset()
						end)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,0)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	--local chk,eg,ep,ev=Duel.CheckEvent(EVENT_CUSTOM+m,true)
	--return chk and (ev==tp or ev==PLAYER_ALL)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local res=true
		if KOISHI_CHECK and cm[tp] and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			res=cm[tp]:GetActivateEffect():IsActivatable(tp,true)
		else
			res=(c:CheckActivateEffect(false,false,false)~=nil)
		end
		return res and Duel.CheckReleaseGroup(tp,cm.rfilter,1,nil) and Duel.CheckReleaseGroup(tp,cm.rfilter2,1,nil,tp,c)
	end
end
function cm.rfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_PENDULUM)
end
function cm.rfilter2(c,tp,sc)
	return c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_PENDULUM) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function cm.fselect(g,tp,sc)
	return g:IsExists(cm.rfilter2,1,nil,tp,sc)
end
function cm.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetOperation(cm.rsop111)
	e2:SetReset(RESET_CHAIN)
	--Duel.RegisterEffect(e2,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.rsop111(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message(e:GetHandler():IsAbleToHand())
	e:GetHandler():SetStatus(STATUS_LEAVE_CONFIRMED,false)
	e:Reset()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.actarget(e,te,tp)
	return te:GetHandler()==e:GetHandler() and te==e:GetLabelObject()
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.GetReleaseGroup(tp):Filter(cm.rfilter,nil)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,1,#g,tp,c)
	Duel.Release(sg,REASON_COST)
	Duel.BreakEffect()
	Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP,false)
	cm.activate_sequence[te]=c:GetSequence()
	c:CreateEffectRelation(te)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_TYPE)
	e0:SetValue(TYPE_TRAP)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:RegisterEffect(e0,true)
	local te2=te:Clone()
	e:SetLabelObject(te2)
	te:SetType(26)
	c:RegisterEffect(te2,true)
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
	--control
	c:RegisterFlagEffect(m+100,RESET_EVENT+RESETS_WITHOUT_TEMP_REMOVE,0,1,c:GetFieldID())
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_CONTROL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetLabel(c:GetFieldID())
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(function(se,sc) return sc:GetFlagEffect(m+100)>0 and se:GetLabel()==sc:GetFlagEffectLabel(m+100) end)
	e3:SetValue(tp)
	Duel.RegisterEffect(e3,tp)
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVING and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
		rc:CancelToGrave(false)
	end
	re:Reset()
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckOrExtraAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.geop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	cm[0]=Duel.CreateToken(0,m)
	cm[1]=Duel.CreateToken(1,m)
	if KOISHI_CHECK then
		cm[0]:SetCardData(CARDDATA_TYPE,TYPE_TRAP)
		cm[1]:SetCardData(CARDDATA_TYPE,TYPE_TRAP)
	end
	e:Reset()
end