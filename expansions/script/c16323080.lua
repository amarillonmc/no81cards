--苍夜传说 马尔修斯 毁灭×坚壁
function c16323080.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3dcf),4,3,c16323080.ovfilter,aux.Stringid(16323080,0))
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e11=e1:Clone()
	e11:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e11)
	--
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e12:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e12:SetRange(LOCATION_MZONE)
	e12:SetValue(c16323080.efilter)
	c:RegisterEffect(e12)
	--immune effect
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCode(EFFECT_IMMUNE_EFFECT)
	e13:SetValue(c16323080.immunefilter)
	c:RegisterEffect(e13)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(c16323080.condition)
	e2:SetTarget(c16323080.target)
	e2:SetOperation(c16323080.activate)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c16323080.descost)
	e3:SetTarget(c16323080.destg)
	e3:SetOperation(c16323080.desop)
	c:RegisterEffect(e3)
end
function c16323080.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local rt=c:RemoveOverlayCard(tp,1,ct,REASON_COST)
	e:SetLabel(rt)
end
function c16323080.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,0xc,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,0xc,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c16323080.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,0xc,1,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c16323080.cfilter(c,tp)
	local type=c:GetType()&0x7
	return c:IsPreviousControler(1-tp) and c:IsCanOverlay() and c:IsLocation(0x70) and c:IsFaceupEx()
		and Duel.GetFlagEffect(tp,16323080+type)==0
end
function c16323080.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c16323080.cfilter,1,nil,tp)
end
function c16323080.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c16323080.cfilter,1,nil,tp) and c:IsType(TYPE_XYZ) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=eg:Filter(c16323080.cfilter,nil,tp)
	Duel.SetTargetCard(g)
end
function c16323080.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or not c:IsFaceup() or not c:IsType(TYPE_XYZ) then return end
	local g=Duel.GetTargetsRelateToChain()
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		local type=tc:GetType()&0x7
		Duel.Overlay(c,sg)
		Duel.RegisterFlagEffect(tp,16323080+type,RESET_PHASE+PHASE_END,0,1)
	end
end
function c16323080.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3dcf) and c:IsLevel(8) and c:IsRace(0x20)
end
function c16323080.immunefilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
		and te:GetHandler():IsRace(0x20)
end
function c16323080.efilter(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER) and e:GetHandlerPlayer()~=re:GetHandlerPlayer()
		and re:GetHandler():IsRace(0x20)
end