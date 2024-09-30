--conprologue of infinite saga
--21.04.13
local cm,m=GetID()
cm.IsFusionSpellTrap=true
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(cm.valcheck)
	c:RegisterEffect(e0)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetLabelObject(e0)
	--e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	--e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCost(cm.costchk)
	e2:SetTarget(cm.actarget)
	e2:SetOperation(cm.costop)
	c:RegisterEffect(e2)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCondition(cm.condition2)
	e4:SetCost(cm.cost2)
	c:RegisterEffect(e4)
	--type
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCode(EFFECT_REMOVE_TYPE)
	e5:SetRange(0xff)
	e5:SetValue(TYPE_FUSION)
	c:RegisterEffect(e5)
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
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	if #g>0 then e:SetLabel(g:GetClassCount(Card.GetCode)) end
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)<=0
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckActivateEffect(false,false,false)~=nil
	end
end
function cm.filter(c)
	return c:IsSetCard(0xa977) and c:IsAbleToDeckAsCost()
end
function cm.ssfilter(c)
	return c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5
end
function cm.fselect(g)
	return g:IsExists(cm.ssfilter,1,nil)
end
function cm.costchk(e,te,tp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	if te:IsHasType(EFFECT_TYPE_ACTIVATE) then
		return #g>=3
	end
	return #g>=3 and g:IsExists(Card.IsLocation,1,nil,LOCATION_SZONE)
end
function cm.actarget(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler()
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	if te:IsHasType(EFFECT_TYPE_ACTIVATE) then
		g=g:Select(tp,3,3,nil)
	else
		g=g:SelectSubGroup(tp,cm.fselect,false,3,3)
	end
	local cg=g:Filter(Card.IsFacedown,nil)
	if #cg>0 then Duel.ConfirmCards(1-c:GetControler(),cg) end
	c:SetMaterial(g)
	Duel.SendtoDeck(g,nil,2,REASON_COST+REASON_MATERIAL)
	Duel.BreakEffect()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	cm.activate_sequence[te]=c:GetSequence()
	e:GetHandler():CreateEffectRelation(te)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	if te:IsHasType(EFFECT_TYPE_QUICK_O) then
		c:CancelToGrave(false)
		local te2=te:Clone()
		e:SetLabelObject(te2)
		te:SetType(26)
		c:RegisterEffect(te2,true)
		e1:SetLabel(1)
	end
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
	if e:GetLabel()>0 then re:Reset() end
end
function cm.spfilter(c,e,tp)
	return c:IsCode(11451406) and c:IsAbleToHand()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or not e:GetHandler():IsLocation(LOCATION_EXTRA) end
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,3,3,nil)
	local cg=g:Filter(Card.IsFacedown,nil)
	if #cg>0 then Duel.ConfirmCards(1-c:GetControler(),cg) end
	c:SetMaterial(g)
	Duel.SendtoDeck(g,nil,2,REASON_COST+REASON_MATERIAL)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local b1=#g>0
	local b2=Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b2 end
	local num=e:GetLabelObject():GetLabel()
	local op=0
	if b1 then
		if num==3 then
			op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
		end
	else
		op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	end
	e:SetLabel(op)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,op))
	if op~=1 then Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local rflag=false
	if op~=1 and #g>0 then
		local tg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
		rflag=true
	end
	if op~=0 then
		if rflag then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,0)
			Duel.ConfirmDecktop(tp,1)
			--Duel.MoveSequence(tc,1)
		end
	end
end