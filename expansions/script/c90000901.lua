--拼死一搏的战士
function c90000901.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c90000901.atktg)
	e1:SetOperation(c90000901.atkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon-other
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90000901,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetCondition(c90000901.spcon)
	e3:SetTarget(c90000901.sptg)
	e3:SetOperation(c90000901.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(aux.bdocon)
	c:RegisterEffect(e4)
	--immune monster
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c90000901.efilter)
	c:RegisterEffect(e5)
end
function c90000901.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	c:RegisterFlagEffect(90000901,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OATH)
	e0:SetCountLimit(1)
	e0:SetLabel(fid)
	e0:SetLabelObject(c)
	e0:SetCondition(c90000901.rmcon)
	e0:SetOperation(c90000901.rmop)
	Duel.RegisterEffect(e0,tp)
end
function c90000901.atkfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c90000901.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local cg=c:GetColumnGroup()
	cg:AddCard(c)
	local g=cg:Filter(c90000901.atkfilter,nil)
	local atk=g:GetSum(Card.GetAttack)+g:GetSum(Card.GetDefense)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end
function c90000901.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(90000901)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c90000901.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,90000901)
	Duel.Remove(e:GetLabelObject(),POS_FACEDOWN,REASON_EFFECT)
end
function c90000901.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_BATTLE)
end
function c90000901.spfilter(c,e,tp,val)
	return (c:IsAttackBelow(val) or c:IsDefenseBelow(val)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c90000901.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local val=math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c90000901.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,val)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c90000901.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local val=math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c90000901.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,val):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c90000901.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER)
end
