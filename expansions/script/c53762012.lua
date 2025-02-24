if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	SNNM.ScreemTraps(c,s.got)
end
function s.got(c)
	--[[local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetTarget(s.rmtg)
	e1:SetTargetRange(LOCATION_OVERLAY+LOCATION_ONFIELD,LOCATION_OVERLAY+LOCATION_ONFIELD)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1)]]--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end
function s.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer() and (c:IsLocation(LOCATION_OVERLAY) or c:GetEquipTarget())
end
function s.thfilter(c)
	return c:IsSetCard(0xc538) and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	Duel.SetLP(tp,lp-600)
	if Duel.GetLP(tp)<lp and (Duel.GetLP(tp)>0 or Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_LOSE_KOISHI)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function s.eqfilter(c,tc,tp)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(tc) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local l1,l2=0,0
	if Duel.GetTurnPlayer()==tp then l1=LOCATION_GRAVE else l2=LOCATION_GRAVE end
	local tc=Duel.GetAttacker()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_HAND+l1,l2,1,nil,tc,tp) end
	Duel.SetTargetCard(tc)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if not Duel.NegateAttack() then return end
	local l1,l2=0,0
	if Duel.GetTurnPlayer()==tp then l1=LOCATION_GRAVE else l2=LOCATION_GRAVE end
	local tc=Duel.GetAttacker()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local ec=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.eqfilter),tp,LOCATION_HAND+l1,l2,1,1,nil,tc,tp):GetFirst()
		if ec and Duel.Equip(tp,ec,tc) then
			local lp=Duel.GetLP(tp)
			Duel.SetLP(tp,lp-tc:GetAttack())
		end
	end
end
