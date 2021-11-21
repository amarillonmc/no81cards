--龙姬diyer 永远的干涸
local m=20000
local cm=_G["c"..m]
	function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PREDRAW)
	e0:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_SZONE+LOCATION_GRAVE)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SSET)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e1)
	--ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetValue(2147483647)
	c:RegisterEffect(e2)
	local e7=e2:Clone()
	e7:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e7)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_SZONE+LOCATION_GRAVE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(cm.efilter3)
	c:RegisterEffect(e3)
	--cannot trigger
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_SZONE+LOCATION_GRAVE)
	e4:SetTargetRange(1,1)
	e4:SetValue(cm.aclimit4)
	c:RegisterEffect(e4)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DISABLE)
	e5:SetRange(LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_SZONE+LOCATION_GRAVE)
	e5:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e5:SetTarget(cm.distg5)
	c:RegisterEffect(e5)
	--disable effect
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVING)
	e6:SetRange(LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_SZONE+LOCATION_GRAVE)
	e6:SetOperation(cm.disop6)
	c:RegisterEffect(e6)
end
	function cm.effilter(c)
	return c:IsFaceup() and c:GetOriginalCode()==m
end
	function cm.effcon(e)
	return Duel.IsExistingMatchingCard(cm.effilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
	function cm.efilter3(e,te)
	return te:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and te:GetOwner()~=e:GetOwner()
end
	function cm.aclimit4(e,re,tp)
	return re:IsActiveType(TYPE_SPELL+TYPE_MONSTER+TYPE_TRAP) and (re:GetHandler():IsOnField() or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
	function cm.distg5(e,c)
	return c:IsType(TYPE_SPELL+TYPE_MONSTER+TYPE_TRAP)
end
	function cm.disop6(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if bit.band(tl,LOCATION_SZONE)~=0 and re:IsActiveType(TYPE_SPELL+TYPE_MONSTER+TYPE_TRAP) then
		Duel.NegateEffect(ev)
	end
end
	function cm.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,1)
	e2:SetCondition(cm.effcon)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetValue(m)
	Duel.RegisterEffect(e2,tp)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SEND_REPLACE)
	e7:SetTarget(aux.TRUE)
	e7:SetValue(aux.TRUE)
	c:RegisterEffect(e7)
	if Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP,true)~=0 then
	if Duel.IsPlayerCanDraw(tp,1) then
		Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,nil,REASON_EFFECT)
	if Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP,true)~=0 then
		Duel.BreakEffect()
		local g1=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0)
		local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
		if g1:GetCount()==0 or g2:GetCount()==0 then return end
		Duel.ConfirmCards(tp,g2)
		Duel.ConfirmCards(1-tp,g1)
		Duel.SendtoHand(g1,tp,REASON_EFFECT)
		Duel.SendtoHand(g2,tp,REASON_EFFECT)
	if Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP,true)~=0 then
		Duel.BreakEffect()
		if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>=1 end
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_EXTRA,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0) end
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_EXTRA,nil)
		if Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)<1 then return end
		if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)~=0 then
		Duel.SendtoDeck(g,tp,2,REASON_EFFECT)
	if Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP,true)~=0 then
		Duel.BreakEffect()
		Duel.Win(tp,0x33)
					end
				end
			end
		end
	end
end