--幻异梦境-黑白世界
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400049.initial_effect(c)
	--Activate
	--See AddYumeFieldGlobal
	--self to deck & activate field
	yume.AddYumeFieldGlobal(c,71400049,1)
	--synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400049,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c71400049.tg1)
	e1:SetCost(c71400049.cost1)
	e1:SetOperation(c71400049.op1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400049,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c71400049.tg2)
	e2:SetOperation(c71400049.op2)
	c:RegisterEffect(e2)
end
c71400049.toss_dice=true
function c71400049.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c71400049.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400049.filter1des,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
end
function c71400049.filter1des(c,tp)
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	return Duel.IsExistingMatchingCard(c71400049.filter1sp,tp,LOCATION_EXTRA,0,1,nil,mg)
end
function c71400049.filter1sp(c,mg)
	return c:IsSetCard(0x714) and c:IsSynchroSummonable(nil,mg)
end
function c71400049.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if dg:GetCount()>0 and Duel.Destroy(dg,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(c71400049.filter1sp,tp,LOCATION_EXTRA,0,1,1,nil,nil)
		if sg:GetCount()>0 then
			Duel.SynchroSummon(tp,tc,nil)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c71400049.atktg)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	Duel.RegisterEffect(e2,tp)
end
function c71400049.atktg(e,c)
	return c:IsSetCard(0x714) and c:IsType(TYPE_SYNCHRO)
end
--[[
function c71400049.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c71400049.filter1,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		Duel.SynchroSummon(tp,tc,nil)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SPSUMMON_COST)
		e1:SetOperation(c71400049.regop)
		e1:SetLabelObject(c)
		tc:RegisterEffect(e1)
	end
end
function c71400049.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lc=e:GetLabelObject()
	local e1=Effect.CreateEffect(lc)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	e1:SetOperation(c71400049.sumop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(lc)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	c:RegisterEffect(e2)
	e:Reset()
end
function c71400049.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c71400049.chainlm)
end
function c71400049.chainlm(e,rp,tp)
	return aux.ExceptThisCard(e)
end
--]]
function c71400049.filter2(c,e,tp)
	return c:IsSetCard(0x714) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c71400049.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c71400049.op2(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.TossDice(tp,1)
	if d==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(c71400049.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if sg:GetCount()>0 then
			local tc=sg:GetFirst()
			Duel.SpecialSummon(tc,TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end