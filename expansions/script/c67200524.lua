--珊海环的思念体
function c67200524.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c67200524.matfilter1,nil,nil,aux.FilterBoolFunction(Card.IsSetCard,0x675),1,1)
	c:EnableReviveLimit()  
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200524,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,67200524)
	e3:SetCondition(c67200524.thcon)
	e3:SetTarget(c67200524.thtg)
	e3:SetOperation(c67200524.thop)
	c:RegisterEffect(e3)	
end
function c67200524.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSetCard(0x675)
end
--
function c67200524.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
		and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp
end
function c67200524.thfilter(c,e,tp)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c67200524.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200524.thfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c67200524.thfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c67200524.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c67200524.thfilter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	end
end

