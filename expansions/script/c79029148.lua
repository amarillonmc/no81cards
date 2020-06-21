--罗德岛·辅助干员-深海色
function c79029148.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,4)
	c:EnableReviveLimit() 
	--token   
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c79029148.con1)
	e1:SetCost(c79029148.dscost)
	e1:SetOperation(c79029148.dsop)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1) 
	--extra atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c79029148.atktg)
	e2:SetValue(c79029148.val)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c79029148.con)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e4)  
end
function c79029148.con1(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetLocationCount(tp,LOCATION_MZONE)>=0
end
function c79029148.dscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=1 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029148.dsop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,79029149,0,0x4011,0,0,2,RACE_CYBERSE,ATTRIBUTE_WATER) then return end
	 local token=Duel.CreateToken(tp,79029149)
	 Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c79029148.con(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_MZONE,0,1,79029149)
end
function c79029148.atktg(e,c)
	return c:IsType(TYPE_TOKEN)
end
function c79029148.val(e,c)
	 return e:GetHandler():GetOverlayCount()-1
end







