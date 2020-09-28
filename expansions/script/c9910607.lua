--赛博空间侵袭
function c9910607.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910607+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910607.target)
	e1:SetOperation(c9910607.activate)
	c:RegisterEffect(e1)
end
function c9910607.rmfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c9910607.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6950) and c:IsType(TYPE_FUSION)
end
function c9910607.locfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and Duel.GetMZoneCount(tp,c)>0
end
function c9910607.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c9910607.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if chk==0 then return g:IsExists(c9910607.cfilter,1,nil)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9910606,0,0x4011,1000,1000,11,RACE_MACHINE,ATTRIBUTE_DARK)
		and (ft>0 or g:IsExists(c9910607.locfilter,-ft+1,nil,tp)) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c9910607.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c9910607.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if g:GetCount()==0 or not g:IsExists(c9910607.cfilter,1,nil) then return end
	local g1=nil
	local g2=nil
	local g3=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	g1=g:FilterSelect(tp,c9910607.cfilter,1,1,nil)
	g:RemoveCard(g1:GetFirst())
	if ft<1 and not c9910607.locfilter(g1:GetFirst()) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g2=g:FilterSelect(tp,c9910607.locfilter,1,1,nil,tp)
		g1:Merge(g2)
		g:RemoveCard(g2:GetFirst())
	end
	local ct=g:GetCount()
	if ct>3-g1:GetCount() then ct=3-g1:GetCount() end
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910607,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		g3=g:Select(tp,1,ct,nil)
		g1:Merge(g3)
	end
	Duel.HintSelection(g1)
	ct=Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	local atk=ct*1000+1000
	if ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,9910606,0,0x4011,atk,atk,11,RACE_MACHINE,ATTRIBUTE_DARK) then
		Duel.BreakEffect()
		local token=Duel.CreateToken(tp,9910606)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		token:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e3:SetRange(LOCATION_MZONE)
		e3:SetTargetRange(0,LOCATION_MZONE)
		e3:SetValue(c9910607.atlimit)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e3,true)
		Duel.SpecialSummonComplete()
	end
end
function c9910607.atlimit(e,c)
	return c~=e:GetHandler()
end
