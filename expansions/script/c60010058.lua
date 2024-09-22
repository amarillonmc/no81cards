--真理医生-万物皆流-
function c60010058.initial_effect(c)
	aux.AddCodeList(c,60010029)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,60010058)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCondition(c60010058.spcon)
	e1:SetTarget(c60010058.sptg)
	e1:SetOperation(c60010058.spop)
	c:RegisterEffect(e1)
	--atkchange
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e1:SetHintTiming(0,TIMING_SUMMON+TIMING_SPSUMMON)
	e3:SetCondition(c60010058.accon)
	e3:SetTarget(c60010058.actg)
	e3:SetOperation(c60010058.acop)
	c:RegisterEffect(e3)
end
function c60010058.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_FZONE,0)>0
end
function c60010058.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c60010058.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		c:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(c60010058.fuslimit)
		c:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		c:RegisterEffect(e4)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		c:RegisterEffect(e5)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		c:RegisterEffect(e6)
		--attack
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_QUICK_O)
		e7:SetCode(EVENT_CHAINING)
		e7:SetProperty(EFFECT_FLAG_DELAY)
		e7:SetRange(LOCATION_MZONE)
		e7:SetCondition(c60010058.ttkcon)
		e7:SetTarget(c60010058.ttktg)
		e7:SetOperation(c60010058.ttkop)
		c:RegisterEffect(e7)
	end
end
function c60010058.fuslimit(e,c,st)
	return st==SUMMON_TYPE_FUSION
end
function c60010058.ttkfilter(e,p,tkc)
	return c:IsControler(p) and c:IsCanBeBattleTarget(tkc)
end
function c60010058.ttkcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	return Duel.IsExistingMatchingCard(Card.IsCanBeBattleTarget,tp,0,LOCATION_MZONE,1,nil,e:GetHandler()) and e:GetHandler():IsAttackPos()
end
function c60010058.ttktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAttackable() and e:GetHandler():GetFlagEffect(60010058)==0 end
	e:GetHandler():RegisterFlagEffect(60010058,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c60010058.ttkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanBeBattleTarget,tp,0,LOCATION_MZONE,nil,e:GetHandler())
	local bc=g:GetFirst()
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACKTARGET)
		bc=g:Select(tp,1,1,nil):GetFirst()
	end
	Duel.CalculateDamage(e:GetHandler(),bc)
end
function c60010058.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function c60010058.accon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(60010029,tp)
end
function c60010058.atkfilter(c)
	return aux.nzatk(c) or aux.nzdef(c)
end
function c60010058.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and (aux.nzatk(chkc) or aux.nzdef(chkc)) end
	if chk==0 then return Duel.IsExistingTarget(c60010058.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c60010058.atkfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c60010058.acop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e3:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e3)
	end
end
