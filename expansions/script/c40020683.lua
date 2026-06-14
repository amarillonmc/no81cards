--创界神 宙斯
local s,id=GetID()
s.named_with_Grandwalker=1
s.named_with_Olym=1
function s.Olym(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Olym
end
function s.Grandwalker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Grandwalker
end
s.named_with_ZeusCreator = 1
function s.ZeusCreatorFilter(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_ZeusCreator
end
function s.EmperorBeast(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_EmperorBeast
end
function s.initial_effect(c)

	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1160)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_HAND)
	e0:SetCost(s.reg)
	c:RegisterEffect(e0)

	--change effect type
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(id)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)

	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1,id+10)
	e5:SetCondition(s.thcon)
	e5:SetTarget(s.thtg)
	e5:SetOperation(s.thop)
	c:RegisterEffect(e5)


	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
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
function s.reg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(id+10,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end


function s.repval(e, tp, eg, ep, ev, re, r, rp)

	if r & REASON_COST == 0 then return false end
	if not re then return false end

	local rc = re:GetHandler()
	if not rc or not rc:IsType(TYPE_MONSTER) then return false end
	if not s.EmperorBeast(rc) then return false end

	local c = e:GetHandler()
	return eg:IsContains(c)
end

function s.reptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.repfilter, tp, 
			LOCATION_HAND + LOCATION_DECK + LOCATION_EXTRA + LOCATION_REMOVED, 0, 1, nil)
	end
	return Duel.SelectYesNo(tp, aux.Stringid(id, 0))
end

function s.repfilter(c)
	if not s.ZeusCreatorFilter(c) then return false end
	if not c:IsAbleToGrave() then return false end
	local loc = c:GetLocation()
	if loc == LOCATION_HAND or loc == LOCATION_DECK then
		return true
	end
	if loc == LOCATION_EXTRA or loc == LOCATION_REMOVED then
		return c:IsFaceup()
	end
	return false
end

function s.repop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
	local g = Duel.SelectMatchingCard(tp, s.repfilter, tp, 
		LOCATION_HAND + LOCATION_DECK + LOCATION_EXTRA + LOCATION_REMOVED, 0, 1, 1, nil)
	if #g > 0 then
		Duel.SendtoGrave(g, REASON_EFFECT + REASON_REPLACE)
	end
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id+10)~=0
end
function s.thfilter(c)
	return not c:IsCode(id) and s.Olym(c) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
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

