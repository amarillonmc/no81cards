--N公司的暴戾处刑
local m=43990058
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c43990058.target)
	e1:SetOperation(c43990058.activate)
	c:RegisterEffect(e1)
	
end
function c43990058.filter(c)
	return not c:IsRace(RACE_MACHINE) and c:IsFaceup()
end
function c43990058.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43990058.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c43990058.smfilter(c)
	return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)
end
function c43990058.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c43990058.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(RACE_MACHINE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	if Duel.IsExistingMatchingCard(c43990058.smfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(43990058,2)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			Duel.BreakEffect()
	local sg=Duel.SelectMatchingCard(tp,c43990058.smfilter,tp,LOCATION_HAND,0,1,1,nil)
	local stc=sg:GetFirst()
	if stc then
		local s1=stc:IsSummonable(true,nil,1)
		local s2=stc:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,stc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,stc,true,nil,1)
		else
			Duel.MSet(tp,stc,true,nil,1)
		end
	end

   end


end

