--新海皇 安泰德拉
function c40009285.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_WATER),1)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009285,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,40009285)
	e1:SetCondition(c40009285.thcon)
	e1:SetTarget(c40009285.thtg)
	e1:SetOperation(c40009285.thop)
	c:RegisterEffect(e1)  
	--atkdown
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c40009285.atkval)
	c:RegisterEffect(e2)  
end
function c40009285.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c40009285.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c40009285.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c40009285.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c40009285.pmfilter(c)
	return c:IsSetCard(0x77) 
end
function c40009285.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c40009285.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=5 then
			local ht=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
			Duel.BreakEffect()
			if ht>=5 and c:GetMaterial():IsExists(c40009285.pmfilter,1,nil) then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
				local sg=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,LOCATION_HAND,0,ht-4,ht-4,nil)
				Duel.SendtoGrave(sg,REASON_EFFECT)
			else
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
				local sg=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,LOCATION_HAND,0,ht-6,ht-6,nil)
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
		end
	end
end
function c40009285.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c40009285.atkval(e,c)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)*-300
end
