--操纵业火与煌炎之人 莉莉娜
function c75000871.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x756),1)
	c:EnableReviveLimit()   
	--add
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75000871,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,75000871)
	e1:SetCondition(c75000871.rmcon)
	e1:SetTarget(c75000871.rmtg)
	e1:SetOperation(c75000871.rmop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c75000871.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function c75000871.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsLinkCode,1,nil,75000853) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c75000871.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()==1
end
--
function c75000871.costfilter(c)
	return c:IsSetCard(0x756) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c75000871.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c75000871.costfilter,tp,LOCATION_DECK,0,1,c)
	local b2=Duel.IsExistingMatchingCard(c75000871.costfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	if chk==0 then return b1 or b2 end
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c75000871.costfilter,tp,LOCATION_DECK,0,c)
	local g2=Duel.GetMatchingGroup(c75000871.costfilter,tp,LOCATION_GRAVE,0,nil)
	if b1 then
		g:Merge(g1)
	end
	if b2 then
		g:Merge(g2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	local atk=tc:GetAttack()
	if tc:IsLocation(LOCATION_DECK) then
		e:SetLabel(1,atk)
		e:SetCategory(CATEGORY_ATKCHANGE)
	end
	if tc:IsLocation(LOCATION_GRAVE) then
		e:SetLabel(2,atk)
		e:SetCategory(CATEGORY_ATKCHANGE)
	end
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
end
function c75000871.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local label,atk=e:GetLabel()
	if label==1 then
		if not c:IsRelateToEffect(e) then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
	if label==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		if tc then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(-atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end


