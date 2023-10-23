--真红眼烈炎龙
function c50223010.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,50223010)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c50223010.con1)
	e1:SetTarget(c50223010.tg1)
	e1:SetOperation(c50223010.op1)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c50223010.op2)
	c:RegisterEffect(e2)
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e22:SetCode(EVENT_CHAIN_SOLVED)
	e22:SetRange(LOCATION_MZONE)
	e22:SetCondition(c50223010.con22)
	e22:SetOperation(c50223010.op22)
	c:RegisterEffect(e22)
end
function c50223010.con1f(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK+LOCATION_HAND) and c:IsControler(1-tp)
end
function c50223010.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c50223010.con1f,1,nil,tp)
end
function c50223010.tg1f(c)
	return c:IsSetCard(0x3b) and c:IsAbleToGrave()
end
function c50223010.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c50223010.tg1f,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c50223010.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c50223010.tg1f,tp,LOCATION_DECK,0,1,1,nil)
		if g1:GetCount()>0 then
			if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				g2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
				if g2:GetCount()>0 then
					Duel.Destroy(g2,REASON_EFFECT)
				end
			end
		end
	end
end
function c50223010.op2(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(50223010,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c50223010.con22f(c)
	return c:IsFaceup() and c:IsSetCard(0x3b) and c:IsType(TYPE_MONSTER)
end
function c50223010.con22(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c50223010.con22f,tp,LOCATION_MZONE,0,1,c) and ep~=tp and c:GetFlagEffect(50223010)~=0
end
function c50223010.op22(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,50223010)
	Duel.Damage(1-tp,300,REASON_EFFECT)
end