--魔力联合 赤红之鬼
function c33200429.initial_effect(c)
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200429,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33200429)
	e1:SetCondition(c33200429.spcon1)
	e1:SetTarget(c33200429.sptg)
	e1:SetOperation(c33200429.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200429,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,33200429)
	e2:SetCondition(c33200429.spcon2)
	e2:SetTarget(c33200429.sptg)
	e2:SetOperation(c33200429.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c33200429.atkcon)   
	e3:SetOperation(c33200429.atkop)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(aux.bdocon)
	e4:SetTarget(c33200429.damtg)
	e4:SetOperation(c33200429.damop)
	c:RegisterEffect(e4)
end

--spsm
function c33200429.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function c33200429.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	local tc=Duel.GetAttackTarget()
	if not ac:IsControler(tp) then ac,tc=tc,ac end
	return ac and ac:IsControler(tp) and ac:IsFaceup() and ac:IsSetCard(0x3329)
end
function c33200429.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33200429.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP) and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33200429,0)) then
		Duel.BreakEffect() 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

--e3
function c33200429.atkfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x329) and c:IsControler(tp)
end
function c33200429.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c33200429.atkfilter,1,nil,tp)
		and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)==0
		and Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_GRAVE,nil,TYPE_SPELL)>0
end
function c33200429.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(300)
	c:RegisterEffect(e2)
end

--e4
function c33200429.dmgfilter(c)
	return c:IsSetCard(0x3329) and c:IsFaceup() and c:GetAttack()~=0
end
function c33200429.tgfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGrave()
end
function c33200429.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c33200429.dmgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c33200429.dmgfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c33200429.dmgfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK+LOCATION_HAND)
end
function c33200429.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetMatchingGroupCount(c33200429.tgfilter,1-tp,LOCATION_DECK+LOCATION_HAND,0,nil,TYPE_SPELL)>=2 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(1-tp,c33200429.tgfilter,1-tp,LOCATION_DECK+LOCATION_HAND,0,2,2,nil)
		if g:GetCount()~=0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	else
		local dmg=tc:GetAttack()
		Duel.Damage(1-tp,dmg,REASON_EFFECT)
	end
end