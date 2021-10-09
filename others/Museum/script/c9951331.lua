--异闻带之王·始皇帝
function c9951331.initial_effect(c)
	 --synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),aux.Tuner(nil),nil,aux.NonTuner(c9951331.sfilter),1,99)
	c:EnableReviveLimit()
  --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951331,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9951331)
	e1:SetCost(c9951331.spcost)
	e1:SetCondition(c9951331.spcon)
	e1:SetTarget(c9951331.sptg)
	e1:SetOperation(c9951331.spop)
	c:RegisterEffect(e1)
 --immume
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c9951331.efilter)
	c:RegisterEffect(e4)
	--indes battle
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(c9951331.indes)
	c:RegisterEffect(e5)
  --attack all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9951331,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c9951331.atkcon)
	e1:SetOperation(c9951331.atkop)
	c:RegisterEffect(e1)
--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951331.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951331.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951331,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9951331,1))
end
function c9951331.sfilter(c)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_SYNCHRO)
end
function c9951331.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c9951331.indes(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_EARTH+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_WIND)
end
function c9951331.counterfilter(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA or c:IsType(TYPE_SYNCHRO)
end
function c9951331.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(9951331,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9951331.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9951331.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
function c9951331.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9951331.filter(c,e,tp)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c9951331.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9951331.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9951331.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c9951331.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if ft<=0 or g:GetCount()==0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local ct=math.min(g:GetClassCount(Card.GetLevel),ft)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.GCheckAdditional=aux.dlvcheck
	local sg=g:SelectSubGroup(tp,aux.TRUE,false,ct,ct)
	aux.GCheckAdditional=nil
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
function c9951331.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==Duel.GetAttacker() and Duel.GetAttackTarget()~=nil or c==Duel.GetAttackTarget()
end
function c9951331.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetBaseAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
  Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951331,0))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9951331,2))
end
