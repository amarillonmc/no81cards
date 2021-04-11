--@^#%%&@*#^%*@^!%%????
function c60159933.initial_effect(c)
	--fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcMixRep(c,true,true,c60159933.ffilter,0,99,c60159933.ffilter1,c60159933.ffilter2)
    --spsummon condition
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(aux.fuslimit)
    c:RegisterEffect(e0)
    --atk
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetOperation(c60159933.e1op)
    c:RegisterEffect(e1)
    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetCondition(c60159933.e2con)
    e2:SetValue(c60159933.e2des)
    c:RegisterEffect(e2)
    --immune effect
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetCondition(c60159933.e2con)
    e3:SetValue(c60159933.immunefilter)
    c:RegisterEffect(e3)
    --disable search
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_TO_HAND)
    e4:SetRange(LOCATION_MZONE)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetTargetRange(0,1)
    e4:SetTarget(aux.TargetBoolFunction(Card.IsLocation,0xff))
    e4:SetCondition(c60159933.e4con)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_CANNOT_DRAW)
    e5:SetRange(LOCATION_MZONE)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetTargetRange(0,1)
    e5:SetCondition(c60159933.e4con)
    c:RegisterEffect(e5)
    --remove
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
    e6:SetCode(EFFECT_TO_GRAVE_REDIRECT)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(0xfe,0xff)
    e6:SetValue(LOCATION_DECKBOT)
    e6:SetCondition(c60159933.e5con)
    e6:SetTarget(c60159933.e5tg)
    c:RegisterEffect(e6)
    --to deck
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(60159933,0))
    e7:SetCategory(CATEGORY_TODECK)
    e7:SetType(EFFECT_TYPE_QUICK_O)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCountLimit(1)
    e7:SetCode(EVENT_FREE_CHAIN)
    e7:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e7:SetCondition(c60159933.e6con)
    e7:SetCost(c60159933.e6cost)
    e7:SetTarget(c60159933.e6tg)
    e7:SetOperation(c60159933.e6op)
    c:RegisterEffect(e7)
    --Stella!!!
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e8:SetCode(EVENT_SPSUMMON_SUCCESS)
    e8:SetOperation(c60159933.e7op)
    c:RegisterEffect(e8)
end
function c60159933.ffilter(c,fc)
    return c:IsRace(RACE_SPELLCASTER) or (c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ))
end
function c60159933.ffilter1(c,fc)
    return c:IsRace(RACE_SPELLCASTER)
end
function c60159933.ffilter2(c,fc)
    return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ)
end
function c60159933.e1op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=c:GetMaterial()
    local lg1=g:FilterCount(c60159933.ffilter1,nil)
    local lg2=g:FilterCount(c60159933.ffilter2,nil)
	if lg1==lg2 and lg1+lg2>=2 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(c:GetMaterialCount()*1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
function c60159933.e2con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=c:GetMaterial()
    local lg1=g:FilterCount(c60159933.ffilter1,nil)
    local lg2=g:FilterCount(c60159933.ffilter2,nil)
    return lg1==lg2 and lg1+lg2>=4
end
function c60159933.e2des(e,c)
    return not (c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ))
end
function c60159933.immunefilter(e,te)
    return te:GetOwner()~=e:GetOwner() and not te:GetHandler():IsRace(RACE_SPELLCASTER)
end
function c60159933.e4con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=c:GetMaterial()
    local lg1=g:FilterCount(c60159933.ffilter1,nil)
    local lg2=g:FilterCount(c60159933.ffilter2,nil)
    return Duel.GetCurrentPhase()~=PHASE_DRAW and lg1==lg2 and lg1+lg2>=6
end
function c60159933.e5con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=c:GetMaterial()
    local lg1=g:FilterCount(c60159933.ffilter1,nil)
    local lg2=g:FilterCount(c60159933.ffilter2,nil)
    return lg1==lg2 and lg1+lg2>=6
end
function c60159933.e5tg(e,c)
    return c:GetOwner()~=e:GetHandlerPlayer()
end
function c60159933.e6con(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=c:GetMaterial()
    local lg1=g:FilterCount(c60159933.ffilter1,nil)
    local lg2=g:FilterCount(c60159933.ffilter2,nil)
    return lg1==lg2 and lg1+lg2>=8
end
function c60159933.e6cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	local ks=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,ks,nil)
    Duel.HintSelection(g)
    Duel.SendtoDeck(g,nil,2,REASON_COST)
	local gs=g:GetCount()
	e:SetLabel(gs)
end
function c60159933.e6tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
    local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c60159933.e6op(e,tp,eg,ep,ev,re,r,rp)
	local sl=e:GetLabel()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,1,sl,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    end
end
function c60159933.e7op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=c:GetMaterial()
    local lg1=g:FilterCount(c60159933.ffilter1,nil)
    local lg2=g:FilterCount(c60159933.ffilter2,nil)
    if lg1==lg2 and lg1+lg2>=10 then
		Duel.Hint(HINT_CARD,0,60159933)
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60159933,1))
        local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_ONFIELD,nil)
		local ct=Duel.Destroy(sg,REASON_EFFECT)
		if ct>0 then
			Duel.Damage(1-tp,ct*1000,REASON_EFFECT,true)
			Duel.Damage(tp,ct*1000,REASON_EFFECT,true)
			Duel.RDComplete()
		end
    end
end