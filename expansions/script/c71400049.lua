--幻异梦境-黑白世界
if not c71401001 then dofile("expansions/script/c71400001.lua") end
function c71400049.initial_effect(c)
	--Activate
	--See AddYumeFieldGlobal
	--self to deck & activate field
	yume.AddYumeFieldGlobal(c,71400049,1)
	--synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400049,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(c71400049.con1)
	e1:SetTarget(c71400049.tg1)
	e1:SetCost(c71400049.cost1)
	e1:SetOperation(c71400049.op1)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1a:SetProperty(0)
	e1a:SetCondition(c71400049.con1a)
	c:RegisterEffect(e1a)
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
	if not c71400049.global_check then
		c71400049.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_DESTROYED)
		ge1:SetOperation(c71400049.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
c71400049.toss_dice=true
function c71400049.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,71400049,RESET_PHASE+PHASE_END,0,1)
end
function c71400049.filter1con(c)
	return c:IsType(TYPE_MONSTER) and c:IsReason(REASON_EFFECT)
end
function c71400049.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c71400049.filter1con,1,nil)
end
function c71400049.con1a(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,71400049)>0
end
function c71400049.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c71400049.filter1(c)
	return c:IsSetCard(0x714) and c:IsSynchroSummonable(nil)
end
function c71400049.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400049.filter1,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c71400049.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(c71400049.filter1,tp,LOCATION_EXTRA,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SynchroSummon(tp,tc,nil)
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