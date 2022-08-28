local m=25000122
local cm=_G["c"..m]
cm.name="现实融解"
cm.Snnm_Ef_Rst=true
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.AllEffectReset(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	return #g==1 and g:GetFirst()==e:GetHandler()
end
function cm.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetLabelObject(e)
	e1:SetOperation(cm.negop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if re==e:GetLabelObject() then
		e:Reset()
		return
	end
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,aux.NULL)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(TYPE_NORMAL)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_REMOVE_TYPE)
		e2:SetValue(TYPE_EFFECT)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	for _,p in ipairs({tp,1-tp}) do
		local ft=Duel.GetLocationCount(p,LOCATION_SZONE)
		local pg=g:Filter(Card.IsControler,nil,p)
		if #pg>ft then
			Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(m,0))
			pg=pg:Select(p,ft,ft,nil)
		end
		for mc in aux.Next(pg) do
			Duel.MoveToField(mc,tp,p,LOCATION_SZONE,POS_FACEUP,true)
			mc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
			local e4=Effect.CreateEffect(c)
			e4:SetCode(EFFECT_CHANGE_TYPE)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e4:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			mc:RegisterEffect(e4)
		end
	end
end
