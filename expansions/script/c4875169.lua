function c4875169.initial_effect(c)   
   local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(4875169,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCountLimit(1,4875169)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e2:SetTarget(c4875169.destg)
    e2:SetOperation(c4875169.desop)
    c:RegisterEffect(e2)
end
function c4875169.desfilter1(c)
    return Duel.IsExistingMatchingCard(nil,0,0,LOCATION_ONFIELD,1,c)
end
function c4875169.destg(e,tp,eg,ep,ev,re,r,rp,chk)
   	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c4875169.desop(e,tp,eg,ep,ev,re,r,rp)
local tc=Duel.GetFirstTarget()
if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)==0 then
		if  Duel.SelectYesNo(tp,aux.Stringid(4875169,1)) then
	Duel.BreakEffect()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 or Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
	Duel.ConfirmDecktop(tp,1)
	Duel.ConfirmDecktop(1-tp,1)
	local g1=Duel.GetDecktopGroup(tp,1)
	local tc1=g1:GetFirst()
	local g2=Duel.GetDecktopGroup(1-tp,1)
	local tc2=g2:GetFirst()
	if bit.band(tc1:GetType(),0x7)==bit.band(tc2:GetType(),0x7) then
		Duel.DisableShuffleCheck()
		local g3=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
		if g3:GetCount()>0  then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g3:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,REASON_RULE)
		end
	else
		Duel.DisableShuffleCheck()
		Duel.Remove(tc1,POS_FACEDOWN,REASON_EFFECT)
		Duel.Remove(tc2,POS_FACEDOWN,REASON_EFFECT)
	end
	else return end
	end
end