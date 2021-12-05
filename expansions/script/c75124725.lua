--械龙圣铠·暗骑龙皇
function c75124725.initial_effect(c)
	c:SetSPSummonOnce(75124725)
	c:EnableCounterPermit(0x3276)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),10,2,c75124725.ovfilter,aux.Stringid(75124725,0),2,nil)
	c:EnableReviveLimit()
	--immune
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(c75124725.efilter)
	c:RegisterEffect(e0)
	--atk/def gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c75124725.value)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--atk/def down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c75124725.value1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--material
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetDescription(aux.Stringid(75124725,2))
	e5:SetCountLimit(2)
	e5:SetCost(c75124725.cost)
	e5:SetTarget(c75124725.target)
	e5:SetOperation(c75124725.operation)
	c:RegisterEffect(e5)
	--damage
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(75124725,1))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c75124725.discost)
	e6:SetTarget(c75124725.target2)
	e6:SetOperation(c75124725.damop)
	c:RegisterEffect(e6)
	--noDmg
	--local e7=Effect.CreateEffect(c)
	--e7:SetCode(EVENT_BE_BATTLE_TARGET)
	--e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	--e7:SetRange(LOCATION_MZONE)
	--e7:SetCountLimit(1,75124725)
	--e7:SetTarget(c75124725.target3)
	--e7:SetCost(c75124725.cost2)
	--e7:SetOperation(c75124725.opNoDmg)
	--c:RegisterEffect(e7)
	--to Grave
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_SELF_DESTROY)
	e8:SetCondition(c75124725.tgcon)
	c:RegisterEffect(e8)
end
function c75124725.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetCurrentPhase()==PHASE_END and c:GetCounter(0x3276)>=2
end
function c75124725.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanAddCounter(tp,0x3276,1,e:GetHandler()) end
end
function c75124725.opNoDmg(e,tp,eg,ep,ev,re,r,rp)
	Duel.BreakEffect()
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
	e:GetHandler():AddCounter(0x3276,1)
end
function c75124725.filter(c)
	return c:IsCanOverlay() and c:IsRace(RACE_MACHINE)
end
function c75124725.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c75124725.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(c75124725.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,c75124725.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,e:GetHandler())
end
function c75124725.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c75124725.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c75124725.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end   
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c75124725.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	e:GetHandler():AddCounter(0x3276,1)
end
function c75124725.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c75124725.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c75124725.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer() and re:IsActivated()
end
function c75124725.vafilter(c)
	return c:IsFaceup()
end
function c75124725.value(e,c)
	return Duel.GetMatchingGroupCount(c75124725.vafilter,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*200
end
function c75124725.value1(e,c)
	return Duel.GetMatchingGroupCount(c75124725.vafilter,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*(-200)
end
function c75124725.ovfilter(c)
	return c:IsFaceup() and c:IsCode(75124703)
end