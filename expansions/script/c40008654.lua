--炽天兵龙 加百列
function c40008654.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xf11),2)
	c:EnableReviveLimit() 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_TYPE_FIELD+EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c40008654.target)
	e1:SetOperation(c40008654.activate)
	c:RegisterEffect(e1)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCondition(c40008654.atkcon3)
	e3:SetTarget(c40008654.atktg3)
	e3:SetValue(0)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e3)
	--immune spell
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c40008654.indcon)
	e2:SetValue(c40008654.efilter)
	c:RegisterEffect(e2) 
	--splimit
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c40008654.regcon)
	e4:SetOperation(c40008654.regop)
	c:RegisterEffect(e4)   
end
function c40008654.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c40008654.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c40008654.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c40008654.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(40008654) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c40008654.desfilter(c,ft)
	return c:IsFaceup() and c:IsSetCard(0xf11) and (ft>0 or c:GetSequence()<5) 
end
function c40008654.spfilter(c,e,tp)
	return c:IsSetCard(0xf11) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40008654.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsAbleToHand() end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.IsExistingTarget(c40008654.desfilter,tp,LOCATION_MZONE,0,1,nil,ft)
		and Duel.IsExistingTarget(c40008654.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectTarget(tp,c40008654.desfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c40008654.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
	e:SetLabelObject(g1:GetFirst())
end
function c40008654.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc1,tc2=Duel.GetFirstTarget()
	if tc1~=e:GetLabelObject() then tc1,tc2=tc2,tc1 end
	if tc1:IsControler(tp) and tc1:IsRelateToEffect(e) and Duel.SendtoHand(tc1,nil,REASON_EFFECT)>0 and tc2:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c40008654.efilter(e,te)
	return (te:IsActiveType(TYPE_SPELL) or te:IsActiveType(TYPE_MONSTER) or te:IsActiveType(TYPE_TRAP)) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c40008654.lkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf11)
end
function c40008654.indcon(e)
	return e:GetHandler():GetLinkedGroup():IsExists(c40008654.lkfilter,1,nil)
end
function c40008654.atkcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and e:GetHandler():GetBattleTarget() and e:GetHandler():GetLinkedGroup():IsExists(c40008654.lkfilter,1,nil)
end
function c40008654.atktg3(e,c)
	return c==e:GetHandler():GetBattleTarget()
end