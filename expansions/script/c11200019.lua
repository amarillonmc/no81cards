--铃仙·优昙华院·因幡
function c11200019.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11200019,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DICE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11200019)
	e1:SetCost(c11200019.cost1)
	e1:SetTarget(c11200019.tg1)
	e1:SetOperation(c11200019.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11200019,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11200119)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c11200019.tg2)
	e2:SetOperation(c11200019.op2)
	c:RegisterEffect(e2)
--
end
--
function c11200019.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
--
function c11200019.tfilter1(c)
	return (c:IsCode(24094653) 
		or (c:IsType(TYPE_MONSTER) and c:IsRace(RACE_BEAST) and c:IsAttribute(ATTRIBUTE_LIGHT)))
		and c:IsAbleToHand()
end
function c11200019.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
--
function c11200019.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)
	if dc>0 and dc<4 then
		if Duel.GetMZoneCount(tp)<1 then return end
		if not c:IsRelateToEffect(e) then return end
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	if dc==4 then Duel.Damage(tp,1100,REASON_EFFECT) end
	if dc>4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c11200019.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()<1 then return end
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
--
function c11200019.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
--
function c11200019.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local g=Group.CreateGroup()
	g:AddCard(tc)
	Duel.HintSelection(g)
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetDescription(aux.Stringid(11200019,2))
	e1_1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1_1:SetType(EFFECT_TYPE_SINGLE)
	e1_1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1_1:SetValue(1)
	e1_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e1_1)
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_SINGLE)
	e1_2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1_2:SetValue(1)
	e1_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e1_2)
	local e1_3=Effect.CreateEffect(c)
	e1_3:SetType(EFFECT_TYPE_SINGLE)
	e1_3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1_3:SetValue(1)
	e1_3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e1_3)
	local e1_4=Effect.CreateEffect(c)
	e1_4:SetType(EFFECT_TYPE_SINGLE)
	e1_4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1_4:SetValue(1)
	e1_4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e1_4)
	local e1_5=Effect.CreateEffect(c)
	e1_5:SetDescription(aux.Stringid(11200019,3))
	e1_5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1_5:SetType(EFFECT_TYPE_SINGLE)
	e1_5:SetCode(EFFECT_MUST_ATTACK)
	e1_5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e1_5)
end
--
