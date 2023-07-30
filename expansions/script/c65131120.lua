--秘计螺旋 缓冲
local s,id,o=GetID()
function s.initial_effect(c)
	--set
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MONSTER_SSET)
	e0:SetValue(TYPE_SPELL)
	c:RegisterEffect(e0)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	local ge0=Effect.CreateEffect(c)
	ge0:SetType(EFFECT_TYPE_FIELD)
	ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ge0:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
	ge0:SetTargetRange(1,0)
	ge0:SetCondition(s.wd)
	ge0:SetValue(1)
	Duel.RegisterEffect(ge0,tp)
	if not s.global_check then
		s.global_check=true
		--set
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCondition(s.IsLpZone)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.cfilter(c)
	return c:GetOriginalCode()==id and c:IsAbleToGrave() and c:IsFacedown()
end
function s.wd(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.GetFlagEffect(tp,id)==0
end
function s.IsLpZone(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(0)==0 or Duel.GetLP(1)==0
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(0)==0 and Duel.GetFlagEffect(0,id)==0 then
		Duel.Recover(0,4000,REASON_EFFECT)
		Duel.RegisterFlagEffect(0,id,nil,0,1)
		local sg=Duel.GetMatchingGroup(s.cfilter,0,LOCATION_ONFIELD,0,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REPLACE)
	end
	if Duel.GetLP(1)==0 and Duel.GetFlagEffect(1,id)==0 then
		Duel.Recover(0,4000,REASON_EFFECT)
		Duel.RegisterFlagEffect(1,id,nil,0,1)
		local sg=Duel.GetMatchingGroup(s.cfilter,1,LOCATION_ONFIELD,0,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REPLACE)
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function s.spcfilter(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spcfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,s.spcfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if Duel.SendtoHand(g,nil,REASON_COST)==0 or not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD,0,1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabelObject(c)
		e2:SetCondition(s.sscon)
		e2:SetOperation(s.ssop)
		Duel.RegisterEffect(e2,tp)
	end
	Duel.SpecialSummonComplete()
end
function s.sscon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(id+1)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function s.ssop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsSSetable() and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.SSet(tp,tc,tp,false)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end