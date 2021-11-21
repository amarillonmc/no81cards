--直到最后一刻
if not pcall(function() require("expansions/script/c16104200") end) then require("script/c16104200") end
local m,cm=rk.set(16104220)
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	local e1=rsef.ACT(c)
	local e2=rsef.FV_LIMIT_PLAYER(c,"sp",nil,cm.tg2,{1,0})
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON+CATEGORY_SUMMON)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_CONTROL)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCondition(cm.condition2)
	e4:SetCost(cm.cost)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)  
end
function cm.tg2(e,c)
	return not c:IsSetCard(0xccd) and not c:IsSetCard(0xccb)
end
function cm.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsPreviousControler(tp) and c:IsSetCard(0x3ccd)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp) and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x3ccd) and Duel.IsPlayerCanSpecialSummonMonster(tp,16104222,0xccd,TYPES_TOKEN_MONSTER,c:GetAttack(),c:GetDefense(),8,RACE_WARRIOR,c:GetAttribute())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and eg:IsExists(cm.spfilter,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.sumfilter(c)
	if not c:IsSetCard(0xccd) then return false end
	if c:IsLocation(LOCATION_HAND) then
		return c:IsSummonable(true,nil)
	else
		local minc,maxc=c:GetTributeRequirement()
		return Duel.IsPlayerCanSummon(tp,SUMMON_TYPE_NORMAL,c) and Duel.CheckTribute(c,minc,maxc)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=5
	local c=e:GetHandler()
	local flag=false
	local sg=eg:Filter(cm.spfilter,nil,e,tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	ft=math.min(ft,(Duel.GetLocationCount(tp,LOCATION_MZONE)))
	for tc in aux.Next(sg) do
		if ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,16104222,0xccd,TYPES_TOKEN_MONSTER,tc:GetAttack(),tc:GetDefense(),8,RACE_WARRIOR,tc:GetAttribute()) then 
		local token=Duel.CreateToken(tp,16104222)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
			ft=ft-1
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(tc:GetAttack())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE)
			e2:SetValue(tc:GetDefense())
			token:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e3:SetValue(tc:GetAttribute())
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e3)
			flag=true
		end
		end
	end
	Duel.SpecialSummonComplete()
	Duel.BreakEffect()
	if flag==true and Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND+LOCATION_PZONE,0,1,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local tc=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND+LOCATION_PZONE,0,1,1,nil):GetFirst()
		if tc then
			Duel.Summon(tp,tc,true,nil)
		end
	end
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.cost(e)
	e:SetLabel(1)
	return true
end
function cm.addfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup() and c:IsSetCard(0xccd) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if e:GetLabel()==1 then
			return Duel.IsExistingMatchingCard(cm.addfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) 
		else
			return false
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=Duel.SelectMatchingCard(tp,cm.addfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.ConfirmCards(1-tp,sg)
	local tc=sg:GetFirst()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not tc:IsRelateToEffect(e) or not c:IsRelateToEffect(e) or not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.GetLocationCountFromEx(tp,tp,nil,tc)<1 then return end
	if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		if tc.dff==true then
			tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+0x7e0000,EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_OATH,0,0,aux.Stringid(16104200,3))
		end
	end
	Duel.SpecialSummonComplete()
end