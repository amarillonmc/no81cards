local m=53716008
local cm=_G["c"..m]
cm.name="断片折光 幻想壳滩"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_MSET)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(cm.con)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SSET)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetCondition(cm.con2)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(cm.con3)
	c:RegisterEffect(e4)
	SNNM.FanippetTrap(c,{e1,e2,e3,e4})
end
function cm.con(e,tp,eg,ep,ev,re,r,rp,chk)
	return rp~=tp
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and eg:IsExists(Card.IsFacedown,1,nil)
end
function cm.cfilter(c,tp)
	return c:IsFacedown() and c:IsSummonPlayer(tp)
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,1-tp)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,700) end
	Duel.PayLPCost(tp,700)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (c:IsLocation(LOCATION_HAND) or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0x353b,TYPES_NORMAL_TRAP_MONSTER,900,2100,4,RACE_ROCK,ATTRIBUTE_WATER))) and Duel.GetFlagEffect(tp,m)==0 and not c:IsLocation(LOCATION_ONFIELD) end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
	if c:IsPreviousLocation(LOCATION_GRAVE) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
		e:SetOperation(cm.op)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(53702500,5))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	else
		e:SetCategory(0)
		e:SetOperation(nil)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not Duel.IsPlayerCanSpecialSummonMonster(tp,m,0x353b,TYPES_NORMAL_TRAP_MONSTER,900,2100,4,RACE_ROCK,ATTRIBUTE_WATER) then return end
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
