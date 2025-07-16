--吸血鬼归还者
function c1171242.initial_effect(c)
    -- 攻守变化
    --[[local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(1171242,0))
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,1171242)
    e1:SetCost(c1171242.cost1)
    e1:SetOperation(c1171242.op1)
    c:RegisterEffect(e1)]]
    -- 特殊召唤
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(1171242,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e2:SetCountLimit(1,1171243)
    e2:SetCondition(c1171242.con2)
    e2:SetTarget(c1171242.tg2)
    e2:SetOperation(c1171242.op2)
    c:RegisterEffect(e2)
    -- 特招超量
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(1171242,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,1171247)
    e3:SetCost(c1171242.cost3)
    e3:SetTarget(c1171242.tg3)
    e3:SetOperation(c1171242.op3)
    c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(1171242,ACTIVITY_SUMMON,c1171242.counterfilter)
	Duel.AddCustomActivityCounter(1171242,ACTIVITY_SPSUMMON,c1171242.counterfilter)
    Duel.AddCustomActivityCounter(1171242,ACTIVITY_CHAIN,c1171242.chainfilter)
    if not c1171242.global_check then
        c1171242.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
        ge1:SetOperation(c1171242.regop)
        Duel.RegisterEffect(ge1,0)
    end
end
function c1171242.regop(e,tp,eg,ep,ev,re,r,rp)
    for tc in aux.Next(eg) do
        if tc:IsPreviousLocation(LOCATION_GRAVE) then
            Duel.RegisterFlagEffect(rp,1171242,RESET_PHASE+PHASE_END,0,1)
            Duel.RegisterFlagEffect(1-rp,1171242,RESET_PHASE+PHASE_END,0,1)
        end
    end
end
-- 自肃
function c1171242.counterfilter(c)
	return c:IsRace(RACE_ZOMBIE)
end
-- 1
--[[function c1171242.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,2000) end
    Duel.PayLPCost(tp,2000)
end
function c1171242.op1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(3000)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
        c:RegisterEffect(e2)
    end
end]]
-- 2
function c1171242.chainfilter(re,tp,cid)
    local loc=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)
    return re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_GRAVE
end
function c1171242.con2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFlagEffect(0,1171242)>0
        and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c1171242.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c1171242.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
        e1:SetValue(LOCATION_REMOVED)
        c:RegisterEffect(e1)
    end
end
-- 3
function c1171242.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,math.floor(Duel.GetLP(tp)/2)) end
    Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c1171242.filter3(c,e,tp,mc)
    return c:IsSetCard(0x8e) and c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c1171242.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c1171242.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c1171242.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c1171242.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
		local sc=g:GetFirst()
		if sc then
			local mg=c:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(sc,mg)
			end
			sc:SetMaterial(Group.FromCards(c))
			Duel.Overlay(sc,Group.FromCards(c))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end