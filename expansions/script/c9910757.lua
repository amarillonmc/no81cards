--远古造物 鳞木
dofile("expansions/script/c9910700.lua")
function c9910757.initial_effect(c)
	--special summon
	QutryYgzw.AddSpProcedure(c,1)
	c:EnableReviveLimit()
	--flag
	QutryYgzw.AddTgFlag(c)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetTarget(c9910757.desreptg)
	e1:SetValue(c9910757.desrepval)
	e1:SetOperation(c9910757.desrepop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9910757)
	e2:SetCondition(c9910757.setcon)
	e2:SetTarget(c9910757.settg)
	e2:SetOperation(c9910757.setop)
	c:RegisterEffect(e2)
end
function c9910757.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField()
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c9910757.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc950)
end
function c9910757.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGrave() and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and eg:IsExists(c9910757.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c9910757.confilter,tp,LOCATION_ONFIELD,0,1,nil) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c9910757.desrepval(e,c)
	return c9910757.repfilter(c,e:GetHandlerPlayer())
end
function c9910757.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910757)
	local c=e:GetHandler()
	if Duel.SendtoGrave(c,REASON_EFFECT)>0 and c:IsLocation(LOCATION_GRAVE)
		and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(9910757,0)) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c9910757.setcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9910757.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return QutryYgzw.SetFilter(e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c9910757.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then QutryYgzw.Set(c,e,tp) end
end
