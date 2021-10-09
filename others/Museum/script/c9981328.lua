--天空璋 摩多罗隐岐奈
function c9981328.initial_effect(c)
	 --pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9981328.splimit)
	c:RegisterEffect(e1)
	--scale
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981328,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c9981328.target)
	e1:SetOperation(c9981328.operation)
	c:RegisterEffect(e1)
	--chain attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9981328,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c9981328.catg)
	e4:SetOperation(c9981328.caop)
	c:RegisterEffect(e4)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981328,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9981328.descon)
	e1:SetTarget(c9981328.destg)
	e1:SetOperation(c9981328.desop)
	c:RegisterEffect(e1)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981328,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c9981328.discon)
	e1:SetTarget(c9981328.distg)
	e1:SetOperation(c9981328.disop)
	c:RegisterEffect(e1)
  --Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9981328,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c9981328.spcon3)
	e3:SetTarget(c9981328.sptg3)
	e3:SetOperation(c9981328.spop3)
	c:RegisterEffect(e3)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981328.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981328.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981328,0))
end
function c9981328.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not (c:IsSetCard(0x6bd1) and c:IsType(TYPE_MONSTER)) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c9981328.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x6bd1) end
	local tc=Duel.GetFirstMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,e:GetHandler(),0x6bd1)
	Duel.SetTargetCard(tc)
end
function c9981328.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		tc:RegisterEffect(e2)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c9981328.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
  Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981328,0))
end
function c9981328.splimit(e,c)
	return not c:IsSetCard(0x6bd1)
end
function c9981328.afilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x6bd1) and c:IsChainAttackable()
end
function c9981328.catg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c9981328.afilter,1,nil,tp) end
	local a=eg:Filter(c9981328.afilter,nil,tp):GetFirst()
	Duel.SetTargetCard(a)
end
function c9981328.caop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsControler(tp) and tc:IsRelateToBattle() then
		Duel.ChainAttack()
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981328,0))
end
function c9981328.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9981328.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c9981328.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6bd1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9981328.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9981328.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	if sg:GetCount()~=0 and Duel.SelectYesNo(tp,aux.Stringid(9981328,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sp=sg:Select(tp,1,1,nil)
		Duel.SpecialSummon(sp,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9981328.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsContains(e:GetHandler()) and Duel.IsChainDisablable(ev)
end
function c9981328.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9981328.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) then
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981328,0))
end
function c9981328.spcon3(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9981328.spfilter3(c,e,tp)
	return c:IsSetCard(0x6bd1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9981328.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9981328.spfilter3,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9981328.spop3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9981328.spfilter3,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
