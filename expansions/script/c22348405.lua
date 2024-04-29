--银河眼新星龙
local m=22348405
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c22348405.ffilter,2,true)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetCondition(c22348405.actcon)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348405,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22348405)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c22348405.thtg)
	e2:SetOperation(c22348405.thop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348405,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c22348405.spcon)
	e3:SetOperation(c22348405.spop)
	c:RegisterEffect(e3)
	
end
function c22348405.ffilter(c)
	return c:IsAttackAbove(2000) and c:IsOnField()
end
function c22348405.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function c22348405.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand() and c:GetBaseAttack~=0
end
function c22348405.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c22348405.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22348405.thfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c22348405.thfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c22348405.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=tc:GetBaseAttack()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c22348405.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end

function c22348405.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1)
	e1:SetCondition(c22348405.sp2con2)
	e1:SetOperation(c22348405.sp2op2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c22348405.filter1(c,e,tp)
	return c:IsCode(93717133) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348405.sp2con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22348405.filter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
end
function c22348405.sp2op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22348405.filter1),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end