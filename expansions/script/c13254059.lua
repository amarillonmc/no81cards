--元始飞球之神格
local m=13254059
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_BATTLE_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	
end
function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3356)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(4000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(cm.efilter)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetCode(EFFECT_CANNOT_ACTIVATE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetTargetRange(1,1)
		e4:SetValue(cm.aclimit)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_PHASE+PHASE_END)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCountLimit(1)
		e5:SetCondition(cm.phcon)
		e5:SetOperation(cm.phop)
		tc:RegisterEffect(e5,true)
		if not tc:IsType(TYPE_EFFECT) then
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetCode(EFFECT_ADD_TYPE)
			e6:SetValue(TYPE_EFFECT)
			e6:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e6,true)
		end
	end
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsCode(m)
end
function cm.phcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.cfilter(c)
	return #(tama.tamas_getElements(c))~=0 and c:IsAbleToDeckAsCost()
end
function cm.phop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local el=tama.tamas_increaseElements(tama.tamas_getElements(c),{{TAMA_ELEMENT_MANA,1}})
	local mg=tama.tamas_checkGroupElements(Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_GRAVE,0,nil),el)
	local sg=Group.CreateGroup()
	if tama.tamas_isCanSelectElementsForAbove(mg,el) then
		local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	else
		Duel.Remove(c,POS_FACEDOWN,REASON_RULE)
	end
end
