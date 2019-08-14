--幻想的第一乐章·梦幻
function c60150513.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c60150513.mfilter,10,2)
	c:EnableReviveLimit()
	--atk dowm
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c60150513.atkval)
	c:RegisterEffect(e1)
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65848811,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCost(c60150513.thcost)
	e3:SetCondition(c60150513.thcon)
	e3:SetTarget(c60150513.thtg)
	e3:SetOperation(c60150513.thop)
	c:RegisterEffect(e3)
end
function c60150513.mfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c60150513.atkval(e,c)
	return c:GetOverlayCount()*400
end
function c60150513.dircon(e)
	return e:GetHandler():GetOverlayCount()==0
end
function c60150513.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60150513.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c60150513.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,60150512,0,0x4011,-2,-2,10,RACE_FIEND,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.RegisterFlagEffect(tp,EFFECT_SPSUM_EFFECT_ACTIVATED,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c60150513.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,60150512,0,0x4011,-2,-2,10,RACE_FIEND,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,60150512)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(ev)
	e1:SetReset(RESET_EVENT+0xfe0000)
	token:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_DEFENSE)
	e2:SetValue(ev)
	e2:SetReset(RESET_EVENT+0xfe0000)
	token:RegisterEffect(e2)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end