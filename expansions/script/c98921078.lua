--娱乐法师 杂技魔术家
function c98921078.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),4,2)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)	
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98921078,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c98921078.postg)
	e2:SetOperation(c98921078.posop)
	c:RegisterEffect(e2)
	--pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98921078,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,98921078)
	e2:SetCost(c98921078.pencost)
	e2:SetTarget(c98921078.pentg)
	e2:SetOperation(c98921078.penop)
	c:RegisterEffect(e2)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c98921078.rctg)
	e2:SetOperation(c98921078.rcop)
	c:RegisterEffect(e2)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98921078,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,98931078)
	e4:SetCondition(c98921078.thcon2)
	e4:SetTarget(c98921078.thtg2)
	e4:SetOperation(c98921078.thop2)
	c:RegisterEffect(e4)
end
c98921078.pendulum_level=4
function c98921078.filter(c)
	return c:IsCanChangePosition()
end
function c98921078.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c98921078.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98921078.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c98921078.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,300)
end
function c98921078.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK) then
		Duel.Damage(tp,300,REASON_EFFECT,true)
		Duel.Damage(1-tp,300,REASON_EFFECT,true)
		Duel.RDComplete()
	end
end
function c98921078.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c98921078.penfilter(c)
	return c:IsSetCard(0xc6) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c98921078.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98921078.penfilter,tp,LOCATION_DECK,0,1,nil)
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function c98921078.penop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c98921078.penfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			if Duel.IsExistingMatchingCard(c98921078.tefilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(98921078,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(98921078,3))
				local g=Duel.SelectMatchingCard(tp,c98921078.tefilter,tp,LOCATION_DECK,0,1,1,nil)
				if g:GetCount()>0 then
				   Duel.SendtoExtraP(g,nil,REASON_EFFECT)
				end
			end
		end
	end
end
function c98921078.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xc6)
end
function c98921078.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c98921078.ofilter,tp,LOCATION_DECK,0,1,nil) end
end
function c98921078.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c98921078.ofilter,tp,LOCATION_DECK,0,1,1,nil,e)
		local tc=g:GetFirst()
		if tc then
			Duel.Overlay(c,tc)
		end
	end
end
function c98921078.ofilter(c,e)
	return c:IsCanOverlay() and (not e or not c:IsImmuneToEffect(e)) and c:IsSetCard(0xc6) and c:IsType(TYPE_MONSTER)
end
function c98921078.thfilter2(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and bit.band(c:GetPreviousTypeOnField(),TYPE_PENDULUM)~=0
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp) and c:IsPreviousPosition(POS_FACEUP) and not (c:IsLocation(LOCATION_DECK+LOCATION_HAND) or c:IsFacedown())
end
function c98921078.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c98921078.thfilter2,1,c,tp) and not eg:IsContains(c) and c:IsFaceup()
end
function c98921078.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end	
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c98921078.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(c98921078.damfilter2,nil,tp)
	local tc=nil
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		tc=g:Select(tp,1,1,nil):GetFirst()
	elseif #g==1 then
		tc=g:GetFirst()
	end
	if tc and Duel.SendtoHand(tc,tp,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c98921078.damfilter2(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and bit.band(c:GetPreviousTypeOnField(),TYPE_PENDULUM)~=0
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp) and c:IsPreviousPosition(POS_FACEUP) and not (c:IsLocation(LOCATION_DECK+LOCATION_HAND) or c:IsFacedown()) and c:IsAbleToHand()
end