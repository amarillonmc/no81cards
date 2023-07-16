--拟态武装 强攻共鸣
function c67200648.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--cannot attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetCondition(c67200648.limcon)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x667b))
	e6:SetValue(1000)
	c:RegisterEffect(e6) 
	--
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_PIERCE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCondition(c67200648.limcon)
	e7:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x667b))
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--Move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200648,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,67200648)
	e2:SetTarget(c67200648.sptg)
	e2:SetOperation(c67200648.spop)
	c:RegisterEffect(e2)	
end
function c67200648.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x667b) and c:IsAttackPos()
end
function c67200648.limcon(e)
	return Duel.GetMatchingGroupCount(c67200648.cfilter1,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)>1
end
--
function c67200648.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsLevel(3) and Duel.IsExistingMatchingCard(c67200648.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetAttribute())
end  
function c67200648.spfilter(c,e,tp,att)  
	return c:IsAttribute(att) and c:IsLinkBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c:IsType(TYPE_LINK) 
end
function c67200648.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	local tp=e:GetHandlerPlayer() 
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)  
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c67200648.tgfilter(chkc,e,tp) end  
	if chk==0 then return ft>0 and Duel.IsExistingTarget(c67200648.tgfilter,tp,LOCATION_SZONE,0,1,e:GetHandler(),e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)  
	local g=Duel.SelectTarget(tp,c67200648.tgfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c67200648.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tp=e:GetHandlerPlayer() 
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local sg=Duel.SelectMatchingCard(tp,c67200648.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc:GetAttribute())
	if sg:GetCount()>0 then  
		Duel.BreakEffect()  
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end