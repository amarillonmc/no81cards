--天穹司书 睿护之廷达
function c72410270.initial_effect(c)
	aux.AddCodeList(c,56433456)
	--to spell
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72410270,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,72410270)
	e1:SetTarget(c72410270.igtg)
	e1:SetOperation(c72410270.igop)
	c:RegisterEffect(e1)
	--ss success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72410270,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,72410271)
	e2:SetCondition(c72410270.retcon)
	e2:SetOperation(c72410270.retop)
	c:RegisterEffect(e2)
	--as spell
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(72410270,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,72410272)
	e3:SetCondition(c72410270.spellcon)
	e3:SetTarget(c72410270.spelltg)
	e3:SetOperation(c72410270.spellop)
	c:RegisterEffect(e3)
end
--
function c72410270.igtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_HAND))
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c72410270.igop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_HAND)) then return end
	if not Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(72410270,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
end
--
function c72410270.retcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return rc:IsType(TYPE_SPELL) and rc:IsType(TYPE_CONTINUOUS)
end
function c72410270.retop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_TURN_END)
		e2:SetOperation(c72410270.recop)
		Duel.RegisterEffect(e2,tp)
end
function c72410270.recop(e,tp,eg,ep,ev,re,r,rp)
	local thchk=Duel.IsEnvironment(56433456) 
	Duel.Recover(tp,400,REASON_EFFECT)
	if thchk then Duel.Damage(1-tp,400,REASON_EFFECT) end
end
--
function c72410270.filter1(c,e,tp)
	local hp=math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))
	return c:IsSetCard(0xa729) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c:GetAttack()<=hp
end
function c72410270.spellcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_SPELL) and e:GetHandler():IsType(TYPE_CONTINUOUS)
end
function c72410270.spelltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c72410270.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c72410270.spellop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c72410270.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
