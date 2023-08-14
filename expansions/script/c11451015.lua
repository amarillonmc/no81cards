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
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetCondition(cm.regcon)
		ge1:SetOperation(cm.regop)
		--Duel.RegisterEffect(ge1,0)
		local _IsActiveType=Effect.IsActiveType
		local _GetActiveType=Effect.GetActiveType
		function Effect.GetActiveType(e)
			local cost=e:GetCost()
			if cost and cost==cm.cost then
				return TYPE_TRAP
			end
			return _GetActiveType(e)
		end
		function Effect.IsActiveType(e,typ)
			local typ2=e:GetActiveType()
			return typ&typ2~=0
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
		if KOISHI_CHECK and cm[tp] then
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
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
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
	c:CreateEffectRelation(te)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_TYPE)
	e0:SetValue(TYPE_TRAP)
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
		rc:SetStatus(STATUS_LEAVE_CONFIRMED,false)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
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
Duel.DisableActionCheck(true)
cm[0]=Duel.CreateToken(0,m)
cm[1]=Duel.CreateToken(1,m)
cm[0]:SetCardData(CARDDATA_TYPE,TYPE_TRAP)
cm[1]:SetCardData(CARDDATA_TYPE,TYPE_TRAP)
Duel.DisableActionCheck(false)