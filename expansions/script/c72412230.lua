--星宫守护者·射手
function c72412230.initial_effect(c)
	aux.AddCodeList(c,72412240)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72412230,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,72412230)
	e1:SetTarget(c72412230.retg)
	e1:SetOperation(c72412230.reop)
	c:RegisterEffect(e1)
				--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,72412231)
	e2:SetOperation(c72412230.regop)
	c:RegisterEffect(e2)
end
function c72412230.refilter(c,tp)
	return c:IsSetCard(0x9728) and c:IsAbleToGrave()
end
function c72412230.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return  Duel.IsExistingMatchingCard(c72412230.refilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1200)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE) 
end
function c72412230.reop(e,tp,eg,ep,ev,re,r,rp)
	local lg=Duel.SelectMatchingCard(tp,c72412230.refilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	if lg:GetCount()~=0 and  Duel.SendtoGrave(lg,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,1200,REASON_EFFECT)
	end
end
function c72412230.thfilter1(c)
	return c:IsCode(72412240) 
end
function c72412230.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,72412230,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(c72412230.thcon)
	e1:SetOperation(c72412230.thop)
	Duel.RegisterEffect(e1,tp)
end
function c72412230.thfilter2(c)
	return c72412230.thfilter1(c) and c:IsAbleToHand()
end
function c72412230.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c72412230.thfilter2),tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,72412230)==0
end
function c72412230.thop(e,tp,eg,ep,ev,re,r,rp)
	Effect.Reset(e)
	Duel.Hint(HINT_CARD,0,72412230)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c72412230.thfilter2),tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end