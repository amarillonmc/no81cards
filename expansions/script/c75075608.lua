--噩梦的女王 神阶芙蕾娜
function c75075608.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x757),3,127,false)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75075608,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,75075608)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c75075608.destg)
	e2:SetOperation(c75075608.desop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c75075608.descon)
	e3:SetValue(c75075608.val)
	c:RegisterEffect(e3)	
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetCondition(c75075608.descon)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c75075608.descon)
	e5:SetValue(aux.indoval)
	c:RegisterEffect(e5)
	--pierce
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_PIERCE)
	e6:SetCondition(c75075608.descon)
	c:RegisterEffect(e6)
end
function c75075608.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanChangePosition() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c75075608.filter(c,e,tp)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) 
end
function c75075608.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0 and Duel.IsExistingMatchingCard(c75075608.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(75075608,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local g=Duel.SelectMatchingCard(tp,c75075608.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
			Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		end
	end
end
--
function c75075608.fil1ter(c,seq)
	return c:GetPreviousSequence()<5 and math.abs(seq-c:GetPreviousSequence())==1 and :IsRace(RACE_BEAST+RACE_FAIRY)
end
function c75075608.fil2ter(c,seq)
	return c:GetPreviousSequence()<5 and math.abs(seq-c:GetPreviousSequence())==1 
end
function c75075608.descon(e,c)
	local tp=e:GetHandlerPlayer()
	local seq=e:GetHandler():GetSequence()
	if seq>=5 then return false end
	return Duel.IsExistingMatchingCard(c75075608.fil1ter,tp,LOCATION_MZONE,0,1,nil,seq) or not Duel.IsExistingMatchingCard(c75075608.fil2ter,tp,LOCATION_MZONE,0,1,nil,seq)
end
--
function c75075608.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsPosition,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil,POS_DEFENSE)*500
end



