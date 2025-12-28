--天人 GN武装TYPE-E
local s,id=GetID()
--CB
s.named_with_CelestialBeing=1
function s.CelestialBeing(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_CelestialBeing
end
function s.Exia(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Exia
end
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.eqtarget)
	e1:SetOperation(s.eqoperation)
	c:RegisterEffect(e1)
	--equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(s.eqlimit)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(500)
	c:RegisterEffect(e3)


	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,id)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(s.flipcon)
	e4:SetTarget(s.fliptg)
	e4:SetOperation(s.flipop)
	c:RegisterEffect(e4)


	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,id+1)
	e5:SetCondition(s.thcon)
	e5:SetTarget(s.thtg)
	e5:SetOperation(s.thop)
	c:RegisterEffect(e5)
end
function s.eqlimit(e,c)
	return s.CelestialBeing(c) and c:IsRace(RACE_MACHINE)
end
function s.eqfilter(c)
	return c:IsFaceup() and s.CelestialBeing(c) and c:IsRace(RACE_MACHINE)
end
function s.eqtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.eqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.eqoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end

function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and (Duel.GetAttacker()==ec or Duel.GetAttackTarget()==ec)
end

function s.setfilter(c)
	return c:IsFacedown() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
end

function s.deckfilter(c,code)
	return s.CelestialBeing(c) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) 
		and not c:IsCode(code) and c:IsSSetable()
end

function s.fliptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_SZONE) and s.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.setfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	Duel.SelectTarget(tp,s.setfilter,tp,LOCATION_SZONE,0,1,1,nil)
end

function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFacedown() then
		Duel.ChangePosition(tc,POS_FACEUP)
		if Duel.IsExistingMatchingCard(s.deckfilter,tp,LOCATION_DECK,0,1,nil,tc:GetCode())
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,s.deckfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
			if #g>0 then
				Duel.SSet(tp,g)
			end
		end
	end
end

function s.thfilter(c,tp)
	return c:IsControler(tp) and s.Exia(c)
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.thfilter,1,nil,tp)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end

