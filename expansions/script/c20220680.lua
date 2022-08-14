--闪光No.107 银河眼时空龙-时空螺旋
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
    aux.AddXyzProcedure(c,nil,9,3,s.ovfilter,aux.Stringid(id,0),3,s.xyzop)
	c:EnableReviveLimit()
   
    --检索
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,1))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1)
    e1:SetCondition(s.con)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)	
	--无效
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,{id,1})
	e1:SetCost(s.negcost)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)
	--人渣效果
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_F+EFFECT_TYPE_FIELD)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.con1)
	e3:SetCost(s.cost)
	e3:SetOperation(s.op)
	c:RegisterEffect(e3)
end
s.xyz_number=107
function s.cfilter(c)
	return c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x107b) and c:IsType(TYPE_XYZ)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,s.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.filter(c)
    return  (c:IsCode(8038143) or (c:IsSetCard(0x95) and c:GetType()==TYPE_QUICKPLAY+TYPE_SPELL)) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
    Duel.SetChainLimit(s.chlimit)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function s.chlimit(e,ep,tp)
    return tp==ep
end
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
    Duel.SetChainLimit(s.chlimit)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(0,LOCATION_ONFIELD)
	e2:SetTarget(s.disable)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.disable(e,c)
	return c~=e:GetHandler() and (not c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT))
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a,d=d,a end
	return a==e:GetHandler() and d and e:GetHandler():GetFlagEffect(id)==0
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(id)==0 end
	e:GetHandler():RegisterFlagEffect(id,RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
    Duel.SetChainLimit(s.chlimit)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or a:IsFacedown() or not d:IsRelateToBattle() or d:IsFacedown() then return end
	if a:IsControler(1-tp) then a,d=d,a end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetOwnerPlayer(tp)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(d:GetAttack())
	a:RegisterEffect(e1)
end
