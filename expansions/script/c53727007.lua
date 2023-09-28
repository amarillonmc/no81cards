local m=53727007
local cm=_G["c"..m]
cm.name="循环感染"
cm.cybern_numc=true
if not require and Duel.LoadScript then
    function require(str)
        local name=str
        for word in string.gmatch(str,"%w+") do
            name=word
        end
        Duel.LoadScript(name..".lua")
        return true
    end
end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	aux.AddCodeList(c,53727003)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		ge1:SetCode(EFFECT_MATERIAL_CHECK)
		ge1:SetValue(cm.valcheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.valcheck(e,c)
	if c:GetMaterial():IsExists(Card.IsType,3,nil,TYPE_MONSTER) then c:RegisterFlagEffect(m,RESET_EVENT+0x4fe0000,0,1) end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and eg:GetFirst():IsFaceup()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	local ct=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,53727003):GetClassCount(Card.GetOriginalCodeRule)
	local b1=ct>Duel.GetFlagEffect(0,m) and tc:GetAttack()>0
	local b2=ct>Duel.GetFlagEffect(0,m+33)+2 and aux.NegateEffectMonsterFilter(tc)
	local b3=ct>Duel.GetFlagEffect(0,m+66)+4
	if chk==0 then return b1 or b2 or b3 end
	SNNM.CyberNSwitch(e:GetHandler())
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	SNNM.CyberNSwitch(e:GetHandler())
	local c,tc=e:GetHandler(),eg:GetFirst()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local b1=ct>Duel.GetFlagEffect(0,m) and tc:GetAttack()>0
	if b1 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,3))
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_SET_ATTACK_FINAL)
		e7:SetValue(0)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e7)
		Duel.RegisterFlagEffect(0,m,0,0,0)
	end
	local b2=ct>Duel.GetFlagEffect(0,m+33)+2 and aux.NegateEffectMonsterFilter(tc)
	if b2 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,4))
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e8=Effect.CreateEffect(c)
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetCode(EFFECT_DISABLE)
		e8:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e8)
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_SINGLE)
		e9:SetCode(EFFECT_DISABLE_EFFECT)
		e9:SetValue(RESET_TURN_SET)
		e9:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e9)
		Duel.RegisterFlagEffect(0,m+33,0,0,0)
	end
	local b3=ct>Duel.GetFlagEffect(0,m+66)+4
	if b3 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,5))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(function(e,c,sumtype)return sumtype==SUMMON_TYPE_FUSION end)
		tc:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e4)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		tc:RegisterEffect(e5)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		tc:RegisterEffect(e6)
		Duel.RegisterFlagEffect(0,m+66,0,0,0)
	end
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() and Duel.IsExistingMatchingCard(function(c)return c:GetFlagEffect(m)~=0 and c:IsCode(53727002) and c:GetSummonType()&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION and c:IsFaceup()end,tp,LOCATION_MZONE,0,1,nil) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
