--千夜 瞬间爆炸
function c60150604.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(60150604,3))
	e11:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e11:SetRange(LOCATION_PZONE)
	e11:SetCountLimit(1,6010604)
	e11:SetTarget(c60150604.sptg)
	e11:SetOperation(c60150604.spop)
	c:RegisterEffect(e11)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c60150604.spcon)
	c:RegisterEffect(e1)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60150604,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_TO_DECK)
	e4:SetCountLimit(1,60150604)
	e4:SetCondition(c60150604.descon)
	e4:SetTarget(c60150604.destg)
	e4:SetOperation(c60150604.desop)
	c:RegisterEffect(e4)

	--Duel.AddCustomActivityCounter(60150604,ACTIVITY_SPSUMMON,c60150604.counterfilter)
end
function c60150604.sptgf(c)
	return Duel.GetMZoneCount(tp,c)>0
end
function c60150604.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c60150604.sptgf,tp,LOCATION_ONFIELD,0,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c60150604.sptgf,tp,LOCATION_ONFIELD,0,1,1,c,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150604.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0
		and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c60150604.counterfilter(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c60150604.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(60150604,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60150604.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c60150604.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_SPELLCASTER)
end
function c60150604.rpfilter(c,e,tp)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_PENDULUM) and (not c:IsForbidden()
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))) and not c:IsCode(60150604)
end
function c60150604.rptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150604.rpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c60150604.rpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150601,6))
		local g=Duel.SelectMatchingCard(tp,c60150604.rpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		local op=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			op=Duel.SelectOption(tp,aux.Stringid(60150601,1),aux.Stringid(60150601,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(60150601,1))
		end
		if op==0 then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c60150604.tfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetSummonPlayer()~=tp 
		and c:IsDestructable()
end
function c60150604.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x3b21) then return false end
	return tp~=ep and eg:GetCount()>=1
end
function c60150604.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c60150604.tfilter,nil,tp)
	if not e:GetHandler():IsDestructable() then return false end
	if g:GetCount()==0 then return
		false 
	else
		if chk==0 then return true end
		Duel.SetTargetCard(eg)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)  
	end
end
function c60150604.tfilter2(c,e,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetSummonPlayer()~=tp 
		and c:IsDestructable() and c:IsRelateToEffect(e) 
end
function c60150604.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c60150604.tfilter2,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.Destroy(g,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
	end
end
function c60150604.xyzlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x5b21)
end
function c60150604.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3b21)
end
function c60150604.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c60150604.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c60150604.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_EXTRA) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c60150604.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c60150604.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150604.filter2,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c60150604.filter2,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150604.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c60150604.filter2,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end