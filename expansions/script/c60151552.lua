--Myrtenaster
function c60151552.initial_effect(c)
	c:SetUniqueOnField(1,0,60151552)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c60151552.target)
	e1:SetOperation(c60151552.operation)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetValue(c60151552.Value)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c60151552.eqlimit)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c60151552.thtg)
	e4:SetOperation(c60151552.thop)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,60151552)
	e5:SetCondition(aux.exccon)
	e5:SetCost(c60151552.descost)
	e5:SetTarget(c60151552.destg)
	e5:SetOperation(c60151552.activate)
	c:RegisterEffect(e5)
end
function c60151552.filter(c)
	return c:IsFaceup() and c:IsCode(60151502)
end
function c60151552.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c60151552.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60151552.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c60151552.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c60151552.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c60151552.Value(e,c)
	return c:GetBaseAttack()+1000
end
function c60151552.eqlimit(e,c)
	return c:IsCode(60151502)
end
function c60151552.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():GetEquipTarget()~=0 end
    Duel.Hint(HINT_SELECTMSG,tp,562)
    local rc=Duel.AnnounceAttribute(tp,1,0xffff)
    e:SetLabel(rc)
end
function c60151552.thop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=e:GetHandler():GetEquipTarget()
	if not tc then return end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetLabel(e:GetLabel())
    e1:SetValue(c60151552.Val)
    tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e2:SetLabel(e:GetLabel())
    e2:SetValue(c60151552.Val2)
    tc:RegisterEffect(e2)
end
function c60151552.Val(e,c)
	return c:GetAttribute()==e:GetLabel()
end
function c60151552.Val2(e,re)
	return re:GetHandler():GetAttribute()==e:GetLabel()
end
function c60151552.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c60151552.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x9b28) and c:IsAbleToGrave()
end
function c60151552.filter3(c,e,tp)
	return c:IsCode(60151502) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c60151552.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c60151552.filter2,tp,LOCATION_ONFIELD,0,1,nil) 
		and Duel.IsExistingTarget(c60151552.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and e:GetHandler():IsAbleToHand() end
end
function c60151552.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c60151552.filter2,tp,LOCATION_ONFIELD,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
            Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=Duel.SelectMatchingCard(tp,c60151552.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			if g2:GetCount()>0 then
				Duel.SpecialSummon(g2,0,tp,tp,true,false,POS_FACEUP)
				if c:IsRelateToEffect(e) then
					Duel.SendtoHand(c,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,c)
				end
			end
		end
    end
end
