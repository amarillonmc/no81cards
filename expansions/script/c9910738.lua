--远古造物 印石板始祖鸟
dofile("expansions/script/c9910700.lua")
function c9910738.initial_effect(c)
	--special summon
	QutryYgzw.AddSpProcedure(c,1)
	c:EnableReviveLimit()
	--flag
	QutryYgzw.AddTgFlag(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910738)
	e1:SetCondition(c9910738.thcon)
	e1:SetCost(c9910738.thcost)
	e1:SetTarget(c9910738.thtg)
	e1:SetOperation(c9910738.thop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9910739)
	e2:SetCondition(c9910738.setcon)
	e2:SetTarget(c9910738.settg)
	e2:SetOperation(c9910738.setop)
	c:RegisterEffect(e2)
end
function c9910738.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c9910738.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9910738.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttacker()
	if chk==0 then return tc and tc:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function c9910738.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsRelateToBattle() and tc:IsControler(1-tp) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c9910738.setcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9910738.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return QutryYgzw.SetFilter(e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c9910738.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then QutryYgzw.Set(c,e,tp) end
end
