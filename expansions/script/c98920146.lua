--天启号 朱庇斯特
function c98920146.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,2,c98920146.ovfilter,aux.Stringid(98920146,0),2,c98920146.xyzop)
	c:EnableReviveLimit() 
--disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920146,1))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c98920146.tgcost)
	e1:SetTarget(c98920146.tgtg)
	e1:SetOperation(c98920146.tgop)
	c:RegisterEffect(e1)
--overlay
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920146,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c98920146.hdcon)
	e3:SetTarget(c98920146.hdtg)
	e3:SetOperation(c98920146.hdop)
	c:RegisterEffect(e3)
	if not c98920146.global_check then
		c98920146.global_check=true
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(c98920146.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c98920146.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c98920146.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,98920146)>0 and Duel.GetFlagEffect(tp,90448280)==0 end
	Duel.RegisterFlagEffect(tp,90448280,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c98920146.check(c)
	return c and c:IsType(TYPE_XYZ)
end
function c98920146.checkop(e,tp,eg,ep,ev,re,r,rp)
	if c98920146.check(Duel.GetAttacker()) or c98920146.check(Duel.GetAttackTarget()) then
		Duel.RegisterFlagEffect(tp,98920146,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1-tp,98920146,RESET_PHASE+PHASE_END,0,1)
	end
end
function c98920146.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c98920146.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c98920146.dsfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function c98920146.dsfilter(c)
	return c:IsFaceup() and (c:IsLocation(LOCATION_SZONE) or c:IsType(TYPE_EFFECT))
end
function c98920146.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler()
	local g=Duel.GetMatchingGroup(c98920146.dsfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if #g>0 then
		local tc=g:GetFirst()
		while tc do
		   local e1=Effect.CreateEffect(e:GetHandler())
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_DISABLE)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		   tc:RegisterEffect(e1)
		   local e2=Effect.CreateEffect(e:GetHandler())
		   e2:SetType(EFFECT_TYPE_SINGLE)
		   e2:SetCode(EFFECT_DISABLE_EFFECT)
		   e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		   tc:RegisterEffect(e2)
		   tc=g:GetNext()
	   end
	end
end
function c98920146.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c98920146.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c98920146.cfilter,1,nil,1-tp)
end
function c98920146.ofilter(c,e)
	return c:IsCanOverlay() and (not e or not c:IsImmuneToEffect(e))
end
function c98920146.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c98920146.ofilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
end
function c98920146.hdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c98920146.ofilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e)
		local tc=g:GetFirst()
		if tc then
			Duel.Overlay(c,tc)
		end
		Duel.ShuffleDeck(tp)
	end
end