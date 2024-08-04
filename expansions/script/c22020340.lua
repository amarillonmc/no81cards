--人理之基 尤瑞艾莉
function c22020340.initial_effect(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22020340,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,22020340)
	e1:SetTarget(c22020340.sptg)
	e1:SetOperation(c22020340.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCountLimit(1,22020340)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCountLimit(1,22020341)
	e3:SetCondition(c22020340.effcon)
	e3:SetOperation(c22020340.effop)
	c:RegisterEffect(e3)
end
function c22020340.filter(c,e,tp)
	return c:IsLevelBelow(3) and c:IsSetCard(0x6ff1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22020340.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22020340.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	if Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)>=1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	end
end
function c22020340.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	local g=Duel.SelectMatchingCard(tp,c22020340.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
			and Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)>=1
			and Duel.SelectYesNo(tp,aux.Stringid(22020340,1)) then
			Duel.BreakEffect()
			local sg=g1:RandomSelect(1-tp,1)
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
function c22020340.effcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO and e:GetHandler():GetReasonCard():IsSetCard(0x6ff1)
end
function c22020340.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(22020340,2))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetCondition(c22020340.condition)
	e1:SetTarget(c22020340.target)
	e1:SetOperation(c22020340.operation)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(22020340,3))
end
function c22020340.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c22020340.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(ep,LOCATION_HAND,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c22020340.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(ep,LOCATION_HAND,0)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
end