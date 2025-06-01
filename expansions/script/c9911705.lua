--剑域修武士 落银
function c9911705.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9911705)
	e1:SetCondition(c9911705.spcon)
	e1:SetTarget(c9911705.sptg)
	e1:SetOperation(c9911705.spop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetOperation(c9911705.spop2)
	c:RegisterEffect(e2)
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(c9911705.atktg)
	e3:SetValue(0)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e4)
	--redirect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCondition(c9911705.recon)
	e5:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e5)
	if not c9911705.global_check then
		c9911705.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BECOME_TARGET)
		ge1:SetOperation(c9911705.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetOperation(c9911705.checkop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function c9911705.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(9911705,RESET_EVENT+0x1fc0000,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911705,3))
		end
	end
end
function c9911705.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c9911705.ctgfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(9911705,RESET_EVENT+0x1fc0000,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911705,3))
		end
	end
end
function c9911705.ctgfilter(c)
	return c:GetOwnerTargetCount()>0 and c:GetFlagEffect(9911705)==0
end
function c9911705.cfilter(c)
	return c:IsFaceupEx() and c:IsSetCard(0x9957)
end
function c9911705.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)==1 and eg:GetCount()==1
		and Duel.IsExistingMatchingCard(c9911705.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c9911705.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9911705.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	local b1=tc:IsRelateToChain(ev) and tc:IsLocation(LOCATION_MZONE) and tc:IsAbleToRemove(tp,POS_FACEDOWN)
	local b2=Duel.CheckChainTarget(ev,c)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(9911705,0),1},
		{b2,aux.Stringid(9911705,1),2},
		{true,aux.Stringid(9911705,2),3})
	if op==1 then
		Duel.BreakEffect()
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	elseif op==2 then
		Duel.BreakEffect()
		Duel.ChangeTargetCard(ev,Group.FromCards(c))
	end
end
function c9911705.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local a=Duel.GetAttacker()
	local tc=Duel.GetAttackTarget()
	local b1=tc:IsLocation(LOCATION_MZONE) and tc:IsAbleToRemove(tp,POS_FACEDOWN)
	local b2=a:GetAttackableTarget():IsContains(c) and not a:IsImmuneToEffect(e)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(9911705,0),1},
		{b2,aux.Stringid(9911705,1),2},
		{true,aux.Stringid(9911705,2),3})
	if op==1 then
		Duel.BreakEffect()
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	elseif op==2 then
		Duel.BreakEffect()
		Duel.ChangeAttackTarget(c)
	end
end
function c9911705.atktg(e,c)
	return c:GetFlagEffect(9911705)~=0
end
function c9911705.recon(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and not c:IsReason(REASON_RELEASE)
end
