--罗德岛·术士干员-刻俄柏
function c79029136.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	aux.AddXyzProcedure(c,nil,5,3,nil,nil,99)
	c:EnableReviveLimit() 
	--attribute change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11760174,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE)
	e1:SetCost(c79029136.atcost)
	e1:SetTarget(c79029136.attg)
	e1:SetOperation(c79029136.atop)
	c:RegisterEffect(e1)  
	--extra atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6330307,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c79029136.atcost)
	e2:SetOperation(c79029136.atkop)
	c:RegisterEffect(e2)
	--disable field 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c79029136.atcost)
	e3:SetOperation(c79029136.disop)
	c:RegisterEffect(e3) 
	--Overlay
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12744567,0))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCondition(c79029136.damcon)
	e4:SetTarget(c79029136.damtg)
	e4:SetOperation(c79029136.damop)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--cannot target
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetValue(aux.tgoval)
	c:RegisterEffect(e6)
end
function c79029136.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029136.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local rc=Duel.AnnounceRace(tp,1,RACE_ALL)
	e:SetLabel(rc)
end
function c79029136.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(e:GetLabel())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(0,1)
	e2:SetLabel(e:GetLabel())
	e2:SetValue(c79029136.aclimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetLabel(e:GetLabel())
	e3:SetTarget(c79029136.atktarget)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c79029136.aclimit(e,re,tp)
	local c=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and c:IsRace(e:GetLabel())
end
function c79029136.atktarget(e,c)
	return c:IsRace(e:GetLabel())
end
function c79029136.atkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	--trible atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(2)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e4)
end
function c79029136.disop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	--disable field
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DISABLE_FIELD)
	e4:SetProperty(EFFECT_FLAG_REPEAT)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	e4:SetOperation(c79029136.disop1)
	c:RegisterEffect(e4)
end
function c79029136.disop1(e,tp)
	local c=e:GetHandler()
	local zone=bit.band(c:GetLinkedZone(tp),0xffffff00)
	return zone
end
function c79029136.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsType(TYPE_MONSTER)
end
function c79029136.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return bc:IsAbleToRemove() end
	Duel.SetTargetCard(bc)
end
function c79029136.damop(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetFirstTarget()
	if bc:IsRelateToEffect(e) then
	Duel.Overlay(e:GetHandler(),bc)
end
end


























