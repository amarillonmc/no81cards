--平成骑士月骑·加鲁鲁形态
function c9980617.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c9980617.tfilter,aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980617.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6bcd))
	c:RegisterEffect(e2)
	--move
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980617,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c9980617.mvtg)
	e1:SetOperation(c9980617.mvop)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetCountLimit(1,9980617)
	e1:SetCondition(c9980617.condition)
	e1:SetTarget(c9980617.target)
	e1:SetOperation(c9980617.activate)
	c:RegisterEffect(e1)
end
function c9980617.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980617,2))
end
function c9980617.tfilter(c)
	return c:IsCode(9980615) or c:IsHasEffect(9980622)
end 
function c9980617.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9980617,0))
	Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9980617.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc1=Duel.GetFirstTarget()
	if not tc1:IsRelateToEffect(e) or tc1:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(tc1,nseq)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980617,3))
	Duel.BreakEffect()
	local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc2=tg:GetFirst()
	while tc2 do
		local atk=tc2:GetAttack()
		local def=tc2:GetDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(atk/2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc2:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(def/2)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc2:RegisterEffect(e2)
		tc2=tg:GetNext()
	end
end
function c9980617.filter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x6bcd)
end
function c9980617.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and eg:IsExists(c9980617.filter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function c9980617.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,re:GetHandler(),1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
	end
end
function c9980617.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(re:GetHandler(),REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		local a=re:GetHandler():GetAttack()
		local b=re:GetHandler():GetDefense()
		if b>a then a=b end
		if a<0 then a=0 end
		if a>0 then Duel.Damage(1-tp,a,REASON_EFFECT) end
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980617,3))
end
