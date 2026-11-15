--竞争乐士 池P
function c19209720.initial_effect(c)
	--spsummon-self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(19209720,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,19209720)
	e1:SetCondition(c19209720.spcon)
	e1:SetTarget(c19209720.sptg)
	e1:SetOperation(c19209720.spop)
	c:RegisterEffect(e1)
	if not CATEGORY_SSET then CATEGORY_SSET = 0 end
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19209720,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	--e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19209720+1)
	e2:SetCondition(c19209720.atkcon)
	e2:SetTarget(c19209720.atktg)
	e2:SetOperation(c19209720.atkop)
	c:RegisterEffect(e2)
end
function c19209720.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(19209696,tp,LOCATION_FZONE)
end
function c19209720.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,0x5,tp,0x4) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c19209720.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,0x4)
	end
end
function c19209720.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler():IsSetCard(0xb53) and rp==tp
end
function c19209720.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c19209720.setfilter(c)
	return c:IsSetCard(0xb53) and c:IsType(TYPE_QUICKPLAY) and c:IsSSetable()
end
function c19209720.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc then
		Duel.HintSelection(Group.FromCards(tc))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c19209720.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		if not tc:IsStatus(STATUS_BATTLE_DESTROYED) and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(19209720,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sc=g:Select(tp,1,1,nil):GetFirst()
			Duel.SSet(tp,sc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(19209720,0))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e1)
		end
	end
end
