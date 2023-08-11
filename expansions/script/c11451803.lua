--惊异派对女巫
--2022 Happy Halloween!
local cm,m=GetID()
function cm.initial_effect(c)
	--maxx c!
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--dimension shifter!
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(cm.condition2)
	e2:SetCost(cm.cost2)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	e2:SetValue(2)
	c:RegisterEffect(e2)
	--nibiru!
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_HAND)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(cm.condition3)
	e3:SetCost(cm.cost3)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	e3:SetValue(3)
	c:RegisterEffect(e3)
	--evenly matched!
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,3))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_HAND)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e4:SetCondition(cm.condition4)
	e4:SetCost(cm.cost4)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.operation)
	e4:SetValue(4)
	c:RegisterEffect(e4)
	--mystic mine!
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,4))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCondition(cm.condition5)
	e5:SetCost(cm.cost5)
	e5:SetTarget(cm.target)
	e5:SetOperation(cm.operation)
	e5:SetValue(5)
	c:RegisterEffect(e5)
	--feather duster!
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,5))
	e6:SetCategory(CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_HAND)
	e6:SetCondition(cm.condition6)
	e6:SetCost(cm.cost6)
	e6:SetTarget(cm.target)
	e6:SetOperation(cm.operation)
	e6:SetValue(6)
	c:RegisterEffect(e6)
	--trick or treat!
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_ACTIVATE_COST)
	e7:SetRange(LOCATION_HAND)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(1,0)
	e7:SetTarget(cm.actarget)
	e7:SetOperation(cm.costop)
	c:RegisterEffect(e7)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
local _IsActiveType=Effect.IsActiveType
local _GetActiveType=Effect.GetActiveType
local _IsType=Card.IsType
local _GetType=Card.GetType
local _GetOriginalType=Card.GetOriginalType
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),m,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function cm.actarget(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler()
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	local val=te:GetValue()
	local code_list={23434538,91800273,27204311,15693423,76375976,18144506}
	if not KOISHI_CHECK then
		Duel.Hint(HINT_CARD,0,code_list[val])
	else
		function Effect.GetActiveType(se)
			if se==te then
				return TYPE_MONSTER
			end
			return _GetActiveType(se)
		end
		function Effect.IsActiveType(se,typ)
			local typ2=se:GetActiveType()
			return typ&typ2~=0
		end
		function Card.GetType(sc)
			if sc==e:GetHandler() then
				return TYPE_MONSTER+TYPE_EFFECT
			end
			return _GetType(sc)
		end
		function Card.IsType(sc,typ)
			local typ2=sc:GetType()
			return typ&typ2~=0
		end
		function Card.GetOriginalType(sc)
			if sc==e:GetHandler() then
				return TYPE_MONSTER+TYPE_EFFECT
			end
			return _GetOriginalType(sc)
		end
		c:SetEntityCode(code_list[val],false)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCountLimit(1)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return re==te end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
							c:SetEntityCode(m,false)
							Duel.ShuffleHand(tp)
							Effect.IsActiveType=_IsActiveType
							Effect.GetActiveType=_GetActiveType
							Card.IsType=_IsType
							Card.GetType=_GetType
							Card.GetOriginalType=_GetOriginalType
						end)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) and ep~=tp
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,6))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ex3,g3,gc3,dp3,dv3=Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE)
	local ex6=re:IsHasCategory(CATEGORY_DECKDES)
	return ((ex3 and bit.band(dv3,LOCATION_DECK)==LOCATION_DECK) or ex6) and ep~=tp
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,6))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function cm.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,m)>=5 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,6))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function cm.condition4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local ct=g:GetCount()-Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	return ct>0
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,6))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function cm.condition5(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local ct=g:GetCount()-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	return ct>0
end
function cm.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,6))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function cm.condition6(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP)
end
function cm.cost6(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,6))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.IsPlayerCanDraw(tp,1) end
	--[[if KOISHI_CHECK then
		e:GetHandler():SetEntityCode(m,false)
		Duel.ShuffleHand(tp)
		Effect.IsActiveType=_IsActiveType
		Effect.GetActiveType=_GetActiveType
		Card.IsType=_IsType
		Card.GetType=_GetType
		Card.GetOriginalType=_GetOriginalType
	end--]]
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end