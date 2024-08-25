--真魔六武众之影
function c98920739.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3,c98920739.ovfilter,aux.Stringid(98920739,0),3,c98920739.xyzop)
	c:EnableReviveLimit()	
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920739,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c98920739.mttg)
	e1:SetOperation(c98920739.mtop)
	c:RegisterEffect(e1)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c98920739.discon)
	e3:SetCost(c98920739.discost)
	e3:SetTarget(c98920739.distg)
	e3:SetOperation(c98920739.disop)
	c:RegisterEffect(e3)
end
function c98920739.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and ((c:IsSetCard(0x3d) and c:IsType(TYPE_XYZ+TYPE_SYNCHRO)) or c:IsCode(63176202))
end
function c98920739.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,98920739)==0 end
	Duel.RegisterFlagEffect(tp,98920739,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c98920739.mtfilter(c,e)
	return c:IsCanOverlay() and c:IsSetCard(0x3d,0x20)
end
function c98920739.mttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c98920739.mfilter,tp,LOCATION_GRAVE,0,1,nil,c) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,c98920739.mfilter,tp,LOCATION_GRAVE,0,1,1,nil,c)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c98920739.matfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsCanOverlay()
end
function c98920739.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetsRelateToChain():Filter(c98920739.matfilter,nil,e)
	if c:IsRelateToChain() and #g>0 then
		Duel.Overlay(c,g)
	end
end
function c98920739.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c98920739.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(ct)
end
function c98920739.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA+LOCATION_DECK+LOCATION_HAND)
end
function c98920739.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,e:GetHandler())
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c98920739.efilter)
		c:RegisterEffect(e1)
		Duel.BreakEffect()
		if e:GetLabelObject():IsSetCard(0x20) then Duel.NegateEffect(ev) end
		if e:GetLabelObject():IsSetCard(0x3d) and #g>0 then 
		   Duel.BreakEffect()
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		   local sg=g:Select(tp,1,1,e:GetHandler())
		   Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end
function c98920739.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end