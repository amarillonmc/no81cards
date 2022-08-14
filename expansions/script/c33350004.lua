--传说之魂 仁慈
local m=33350004
local cm=_G["c"..m]
function c33350004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.hspcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(cm.dacon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetOperation(cm.activate)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetCondition(cm.atkcon)
	e4:SetOperation(cm.atkop)
	c:RegisterEffect(e4)
end
cm.setname="TaleSouls"
function cm.cfilter(c,tp)
	return c:IsControler(1-tp) and c:IsType(TYPE_MONSTER)
end
function cm.hspcon(e)
    local tp=e:GetHandlerPlayer()
	local g=e:GetHandler():GetColumnGroup():Filter(cm.cfilter,nil,tp)
	return g:GetCount()==0 
end
function cm.filter(c,e,tp)
    return  c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD)>0
        and Duel.IsExistingMatchingCard(cm.filter,1-tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local seq=4-c:GetSequence()
	local zone=2^seq
    if not c:IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,cm.filter,1-tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if g:GetCount()>0 and Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP_ATTACK,zone) then
        if Duel.CheckLocation(1-tp,LOCATION_MZONE,4-c:GetSequence()) then
            local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
        end
        Duel.SpecialSummonComplete()
    end
end

--效果1
function cm.dacon(e)
	local tp=e:GetHandlerPlayer()
	local g=e:GetHandler():GetColumnGroup():Filter(cm.cfilter,nil,tp)
	return g:GetCount()==0
end
--效果2
function cm.spfilter(c,e,tp)
	return c:IsCode(33350001) and c:IsFaceup()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	if d and d:IsRelateToBattle() then
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_SET_BATTLE_ATTACK)
		e7:SetValue(d:GetDefense())
		e7:SetReset(RESET_PHASE+PHASE_DAMAGE)
		d:RegisterEffect(e7,true)
	end
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc  and bc:GetAttack()>0 and bc:IsAttackPos() and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp)
end

function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local dam=bc:GetAttack()
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(bc:GetAttack())
		c:RegisterEffect(e1)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_EXTRA_ATTACK)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3)
		if dam<0 then dam=0 end
		Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
end
