--人理之基 弟橘比卖命
function c22023430.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xff1),4,2,nil,nil,99)
	c:EnableReviveLimit()
	--xyz
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023430,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,22023430)
	e1:SetCondition(c22023430.condition)
	e1:SetTarget(c22023430.target)
	e1:SetOperation(c22023430.operation)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c22023430.desreptg)
	e2:SetValue(c22023430.desrepval)
	e2:SetOperation(c22023430.desrepop)
	c:RegisterEffect(e2)
	--attach
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22023430,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,22023431)
	e3:SetTarget(c22023430.xtg)
	e3:SetOperation(c22023430.xop)
	c:RegisterEffect(e3)
	--attach
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22023430,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,22023431)
	e4:SetCondition(c22023430.erecon)
	e4:SetCost(c22023430.erecost)
	e4:SetTarget(c22023430.xtg)
	e4:SetOperation(c22023430.xop)
	c:RegisterEffect(e4)
end
function c22023430.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c22023430.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetDecktopGroup(tp,6)
	if chk==0 then return tc:FilterCount(Card.IsAbleToChangeControler,nil)==6 end
end
function c22023430.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if not tc then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=6 then
		dr=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	end
	Duel.Overlay(e:GetHandler(),Duel.GetDecktopGroup(tp,6))
end
function c22023430.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField()
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c22023430.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c22023430.repfilter,1,nil,tp)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c22023430.desrepval(e,c)
	return c22023430.repfilter(c,e:GetHandlerPlayer())
end
function c22023430.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,93854893)
end
function c22023430.xfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and (c:IsCode(22023310) or c:IsCode(22023400))
end
function c22023430.xtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22023430.xfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c22023430.xfilter,tp,LOCATION_MZONE,0,1,c)
		and c:IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c22023430.xfilter,tp,LOCATION_MZONE,0,1,1,c)
end
function c22023430.xop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local mg=c:GetOverlayGroup()
		if mg:GetCount()>0 then Duel.Overlay(tc,mg,false) end
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function c22023430.erecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22023430.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end