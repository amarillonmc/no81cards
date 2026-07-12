--创界神 赫拉
local s,id=GetID()
s.named_with_Grandwalker=1

function s.OgreWizard(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_OgreWizard
end

function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.copytg)
	e1:SetOperation(s.copyop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_GRAVE,0)
	e2:SetTarget(s.immtg)
	e2:SetValue(s.immval)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e2)
	
	if not s.global_check1 then
		s.global_check1=true
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_TO_GRAVE)
		ge3:SetOperation(s.checkop1)
		Duel.RegisterEffect(ge3,0)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1,id+100)
	e3:SetCondition(s.pzcon)
	e3:SetTarget(s.pztg)
	e3:SetOperation(s.pzop)
	c:RegisterEffect(e3) 
end

function s.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (s.OgreWizard(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()) then return false end
	local m=_G["c"..c:GetCode()]
	if not m then return false end
	local te=m.OgreWizard_spsummon_effect
	if not te then return false end
	local tg=te:GetTarget()
	return not tg or tg(e,tp,eg,ep,ev,re,r,rp,0,nil,c)
end

function s.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.efffilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.efffilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	local m=_G["c"..tc:GetCode()]
	local te=m.OgreWizard_spsummon_effect
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	Duel.ClearOperationInfo(0)
end

function s.copyop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc or not (tc:IsLocation(LOCATION_HAND+LOCATION_GRAVE) and tc:IsAbleToRemove()) then return end
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==0 then return end
	local m=_G["c"..tc:GetCode()]
	if m then
		local te=m.OgreWizard_spsummon_effect
		if te then
			local op=te:GetOperation()
			if op then op(e,tp,eg,ep,ev,re,r,rp) end
		end
	end
end

function s.immtg(e,c)
	return s.OgreWizard(c)
end

function s.immval(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function s.checkop1(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	local rc=re:GetHandler()
	if s.Grandwalker(rc) and eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_DECK) then
		Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.pzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end
function s.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLocation(tp,LOCATION_PZONE,0)
			or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	end
end
function s.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		return
	end
	if Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		if Duel.GetFlagEffect(tp,id)==0 then
			if Duel.IsPlayerCanDiscardDeck(tp,3) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.BreakEffect()
				Duel.DiscardDeck(tp,3,REASON_EFFECT)
			end
		end
	end
end

