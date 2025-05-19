--甘城猫猫的休息
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,id-70000000)
	e3:SetCondition(s.thcon1)
	e3:SetTarget(s.thtg1)
	e3:SetOperation(s.thop1)
	c:RegisterEffect(e3)
end
function s.thfilter(c)
	return c:IsSetCard(0x52c4) and c:IsAbleToHand() and c:IsFaceupEx()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED) and s.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			if tc:IsType(TYPE_MONSTER) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function s.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x52c4)
end
function s.thfilter1(c)
	return c:IsSetCard(0x52c4) and c:IsAbleToHand() and c:IsFaceup()
end
function s.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(s.thfilter1,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	local lab=0
	if re:IsHasCategory(CATEGORY_REMOVE) then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_DEFCHANGE)
		lab=1
	end
	e:SetLabel(lab)
end
function s.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	if #sg>0 then
		Duel.HintSelection(sg)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
	if e:GetLabel()==1 then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(-500)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
