--异卵双生
function c82567847.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,82567847)
	e1:SetCost(c82567847.cost)
	e1:SetTarget(c82567847.target)
	e1:SetOperation(c82567847.activate)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c82567847.actcon)
	c:RegisterEffect(e2)
end 
function c82567847.cfilter(c)
	local lv=c:GetOriginalLevel()
	return lv>0 and c:IsSetCard(0x825) and c:IsDiscardable()
end
function c82567847.confilter(c)
	return c:IsType(TYPE_FUSION) or (c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)) or c:IsType(TYPE_SYNCHRO)
	  or c:IsType(TYPE_XYZ) 
end
function c82567847.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(c82567847.cfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c82567847.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetOriginalLevel())
	Duel.SendtoGrave(g,REASON_COST)
end
function c82567847.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,82567847,0x825,0x11,100,100,1,RACE_BEASTWARRIOR,ATTRIBUTE_DARK)end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c82567847.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local lv=e:GetLabel()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,82567847,0x825,0x11,100,100,1,RACE_BEASTWARRIOR,ATTRIBUTE_DARK) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)~=0 then
		local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(lv)
	c:RegisterEffect(e1)
	end
end
end
function c82567847.actcon(e)
	return not Duel.IsExistingMatchingCard(c82567847.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
