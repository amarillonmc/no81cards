--恋慕屋敷 增殖爱奴
function c9911053.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c9911053.ctcon1)
	e1:SetOperation(c9911053.ctop1)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,9911053)
	e2:SetCost(c9911053.spcost)
	e2:SetTarget(c9911053.sptg)
	e2:SetOperation(c9911053.spop)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9911053,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,9911054)
	e3:SetCost(c9911053.tkcost)
	e3:SetTarget(c9911053.tktg)
	e3:SetOperation(c9911053.tkop)
	c:RegisterEffect(e3)
	--register to grave
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetOperation(c9911053.regop)
	c:RegisterEffect(e4)
	--pendulem
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9911053,2))
	e5:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCountLimit(1,9911055)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCondition(c9911053.pencon)
	e5:SetTarget(c9911053.pentg)
	e5:SetOperation(c9911053.penop)
	c:RegisterEffect(e5)
end
function c9911053.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function c9911053.ctcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9911053.cfilter,1,nil,1-tp)
end
function c9911053.addfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsCanAddCounter(0x1954,1)
end
function c9911053.ctop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9911053.addfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		tc:AddCounter(0x1954,1)
	end
end
function c9911053.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1954,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1954,3,REASON_COST)
end
function c9911053.spfilter(c,e,tp)
	return c:IsSetCard(0x9954) and c:IsLevel(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911053.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9911053.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9911053.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9911053.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.SelectYesNo(tp,aux.Stringid(9911053,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0):Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end
function c9911053.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c9911053.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,9911052,0,0x4011,0,0,3,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_ATTACK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c9911053.tkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,9911052,0,0x4011,0,0,3,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_ATTACK) then
		local token=Duel.CreateToken(tp,9911054)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c9911053.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(9911053,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c9911053.pencon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(9911053)>0
end
function c9911053.addfilter2(c)
	return c:IsType(TYPE_EFFECT) and c:IsCanAddCounter(0x1954,2) and c:GetBattledGroupCount()>0
end
function c9911053.pentg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9911053.addfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9911053.addfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	Duel.SelectTarget(tp,c9911053.addfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c9911053.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x1954,2)
	end
end
