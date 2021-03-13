--亡语权能 恶灵教皇
function c99988037.initial_effect(c)
    c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c99988037.limval)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c99988037.condition)
	e3:SetTarget(c99988037.target)
	e3:SetOperation(c99988037.operation)
	c:RegisterEffect(e3)
end
function c99988037.limval(e,re,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsRace(RACE_ZOMBIE)
end
function c99988037.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c99988037.thfilter(c)
	return c:IsSetCard(0x20df) and c:IsAbleToHand()
end
function c99988037.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function c99988037.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local g2=Duel.IsExistingMatchingCard(c99988037.thfilter,tp,LOCATION_GRAVE,0,1,nil)
	local opt=0
	if c and g1:GetCount()>0 then
		opt=Duel.SelectOption(tp,aux.Stringid(99988037,0),aux.Stringid(99988037,1),aux.Stringid(99988037,2))+1
	elseif c then opt=1
	elseif g1:GetCount()>0 then opt=2 
	elseif g2 then opt=3
	end
	if opt==1 and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	elseif opt==2 then
		Duel.ConfirmCards(tp,g1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=g1:Select(tp,1,1,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)	
	elseif opt==3 then
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c99988037.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g2:GetCount()>0 then
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
        end
    end
end