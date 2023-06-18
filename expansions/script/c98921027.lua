--阳炎升华
function c98921027.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--decrease tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DECREASE_TRIBUTE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x107d))
	e2:SetValue(0x1)
	c:RegisterEffect(e2)
   --negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98921027,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,98931027)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c98921027.discon)
	e1:SetTarget(c98921027.distg)
	e1:SetOperation(c98921027.disop)
	c:RegisterEffect(e1) 
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98921027,1))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCountLimit(1,98921027)
	e3:SetCost(c98921027.spcost)
	e3:SetTarget(c98921027.target)
	e3:SetOperation(c98921027.activate)
	c:RegisterEffect(e3)
end
function c98921027.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x107d) and c:IsType(TYPE_XYZ)
end
function c98921027.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x107d) and c:IsType(TYPE_XYZ) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c98921027.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return bit.band(loc,LOCATION_ONFIELD)~=0
		and Duel.IsChainDisablable(ev) and Duel.IsExistingMatchingCard(c98921027.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c98921027.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,98921027)==0 end  
	Duel.RegisterFlagEffect(tp,98921027,RESET_CHAIN,0,1)
end
function c98921027.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c98921027.cfilter2,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 and not g:GetFirst():IsImmuneToEffect(e) then
			rc:CancelToGrave()
			Duel.Overlay(g:GetFirst(),Group.FromCards(rc))
		end
	end
end
function c98921027.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x107d)
end
function c98921027.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c98921027.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,98921027)==0 end
	Duel.RegisterFlagEffect(tp,98921027,RESET_CHAIN,0,1)
end
function c98921027.activate(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c98921027.filter,tp,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetValue(c98921027.efilter)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
			e4:SetOwnerPlayer(tp)
			tc:RegisterEffect(e4)
			tc=g:GetNext()
		end
end
function c98921027.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end