--Weiss Schnee
function c60151502.initial_effect(c)
    c:SetUniqueOnField(1,0,60151502)
    c:EnableReviveLimit()
	--cannot special summon
    local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(aux.synlimit)
    c:RegisterEffect(e0)
	--special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60151502,1))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c60151502.sprcon2)
    e2:SetOperation(c60151502.sprop2)
    e2:SetValue(SUMMON_TYPE_SYNCHRO)
    c:RegisterEffect(e2)
	--synchro limit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    e3:SetValue(1)
    c:RegisterEffect(e3)
	--
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetCondition(c60151502.rmcon)
    e4:SetTarget(c60151502.rmtg)
    e4:SetOperation(c60151502.rmop)
    c:RegisterEffect(e4)
	--
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(c60151502.efilter2)
    e5:SetValue(1)
    c:RegisterEffect(e5)
	--indes
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_ATKCHANGE)
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetRange(LOCATION_MZONE)
    e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e6:SetCountLimit(1)
    e6:SetTarget(c60151502.indtg)
    e6:SetOperation(c60151502.indop)
    c:RegisterEffect(e6)
end
function c60151502.sprfilter1(c,tp)
    return c:IsFaceup() and c:IsSetCard(0x9b28) and c:IsAbleToGraveAsCost()
        and Duel.IsExistingMatchingCard(c60151502.sprfilter2,tp,LOCATION_ONFIELD,0,1,c)
end
function c60151502.sprfilter2(c)
    return c:IsFaceup() and c:IsSetCard(0x9b28) and c:IsAbleToGraveAsCost()
end
function c60151502.sprcon2(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
			and Duel.IsExistingMatchingCard(c60151502.sprfilter1,tp,LOCATION_MZONE,0,1,nil,tp) 
			and Duel.IsExistingMatchingCard(c60151502.sprfilter1,tp,LOCATION_SZONE,0,1,nil,tp) 
	else
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
			and Duel.IsExistingMatchingCard(c60151502.sprfilter1,tp,LOCATION_ONFIELD,0,1,nil,tp)
	end
end
function c60151502.sprop2(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c60151502.sprfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(tp,c60151502.sprfilter2,tp,LOCATION_ONFIELD,0,1,1,g1:GetFirst())
		g1:Merge(g2)
		Duel.SendtoGrave(g1,REASON_COST)
		c:SetMaterial(g1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c60151502.sprfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(tp,c60151502.sprfilter2,tp,LOCATION_ONFIELD,0,1,1,g1:GetFirst())
		g1:Merge(g2)
		Duel.SendtoGrave(g1,REASON_COST)
		c:SetMaterial(g1)
	end
end
function c60151502.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c60151502.rmfilter(c)
    return c:IsSetCard(0x9b28)
end
function c60151502.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151502.rmfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c60151502.rmop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_GRAVE,0,1,1,nil,0x9b28)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
		local rc=g:GetFirst()
        if rc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            and rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then
            Duel.SpecialSummon(rc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
            Duel.ConfirmCards(1-tp,rc)
        elseif (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
            and rc:IsSSetable() then
            Duel.SSet(tp,rc)
            Duel.ConfirmCards(1-tp,rc)
        end
    end
end
function c60151502.efilter2(e,c)
    return c:IsSetCard(0x9b28) and not c:IsCode(60151502)
end
function c60151502.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c60151502.indop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		if g1:GetCount()==0 then return end
		local ga=g1:GetMaxGroup(Card.GetAttack)
		if ga:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60151502,0))
			ga=ga:Select(tp,1,1,nil)
		end
		local a=ga:GetFirst()
		local atk=a:GetAttack()
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        e1:SetValue(atk+100)
        tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
    end
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(c,RESET_TURN_SET)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        c:RegisterEffect(e2)
    end
end