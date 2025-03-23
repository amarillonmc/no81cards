--恋慕屋敷 增殖爱奴
function c9911053.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c9911053.ctcon1)
	e1:SetOperation(c9911053.ctop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c9911053.regcon)
	e2:SetOperation(c9911053.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c9911053.ctcon2)
	e3:SetOperation(c9911053.ctop2)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,9911053)
	e4:SetCost(c9911053.spcost)
	e4:SetTarget(c9911053.sptg)
	e4:SetOperation(c9911053.spop)
	c:RegisterEffect(e4)
	--token
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9911053,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCountLimit(1,9911054)
	e5:SetCost(c9911053.tkcost)
	e5:SetTarget(c9911053.tktg)
	e5:SetOperation(c9911053.tkop)
	c:RegisterEffect(e5)
end
function c9911053.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsType(TYPE_EFFECT) and c:IsCanAddCounter(0x1954,2)
end
function c9911053.ctcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9911053.cfilter,1,nil,1-tp) and not Duel.IsChainSolving()
end
function c9911053.ctop1(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(c9911053.cfilter,nil,1-tp)
	for tc in aux.Next(tg) do
		tc:AddCounter(0x1954,2)
	end
end
function c9911053.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9911053.cfilter,1,nil,1-tp) and Duel.IsChainSolving()
end
function c9911053.regop(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(c9911053.cfilter,nil,1-tp)
	local g=e:GetLabelObject()
	if g==nil or #g==0 then
		tg:KeepAlive()
		e:SetLabelObject(tg)
	else
		g:Merge(tg)
	end
	Duel.RegisterFlagEffect(tp,9911053,RESET_CHAIN,0,1)
end
function c9911053.ctcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9911053)>0
end
function c9911053.ctop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,9911053)
	local g=e:GetLabelObject():GetLabelObject()
	local tg=g:Filter(c9911053.cfilter,nil,1-tp)
	local og=Group.CreateGroup()
	og:KeepAlive()
	e:GetLabelObject():SetLabelObject(og)
	g:DeleteGroup()
	for tc in aux.Next(tg) do
		tc:AddCounter(0x1954,2)
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
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9911053.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e)
		and Duel.SelectYesNo(tp,aux.Stringid(9911053,0)) then
		Duel.BreakEffect()
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c9911053.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c9911053.confilter(c)
	return c:IsSetCard(0x9954) and not c:IsPublic()
end
function c9911053.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>0 and Duel.IsExistingMatchingCard(c9911053.confilter,tp,LOCATION_HAND,0,1,e:GetHandler())
		and Duel.IsPlayerCanSpecialSummonMonster(tp,9911052,0,0x4011,0,0,3,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_ATTACK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c9911053.tkop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c9911053.confilter,tp,LOCATION_HAND,0,nil)
	if ft<=0 or not #g==0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,9911052,0,0x4011,0,0,3,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_ATTACK) then return end
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=g:Select(tp,1,ft,nil)
	Duel.ConfirmCards(1-tp,cg)
	Duel.ShuffleHand(tp)
	for i=1,#cg do
		local token=Duel.CreateToken(tp,9911054)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_LEAVE_FIELD)
			e1:SetOperation(c9911053.ctop3)
			token:RegisterEffect(e1,true)
		end
	end
	Duel.SpecialSummonComplete()
end
function c9911053.addfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsCanAddCounter(0x1954,1)
end
function c9911053.ctop3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9911053.addfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		tc:AddCounter(0x1954,1)
	end
	e:Reset()
end
