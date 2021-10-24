--伪装鱼 深渊巨口
function c35399317.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_REPTILE),aux.FilterBoolFunction(Card.IsAttackAbove,2000),true)
	--cannot target
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e0:SetValue(aux.tgoval)
	c:RegisterEffect(e0)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35399317,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c35399317.eqtg)
	e3:SetOperation(c35399317.eqop)
	c:RegisterEffect(e3)  
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(0,EFFECT_FLAG2_MILLENNIUM_RESTRICT)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c35399317.distg)
	c:RegisterEffect(e4)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c35399317.discon)
	e6:SetOperation(c35399317.disop)
	c:RegisterEffect(e6)
	--atk limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c35399317.atktg)
	c:RegisterEffect(e5)
end
--fusion summon
function c35399317.matfilter(c,fc)
	return c:IsFusionType(TYPE_MONSTER) and c:IsAttackAbove(2000)
end
--equip
function c35399317.can_equip_monster(c)
	return true
end
function c35399317.eqfilter(c,tp)
	return c:IsType(TYPE_MONSTER) or c:IsAbleToChangeControler()
end
function c35399317.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c35399317.eqfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c35399317.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsFaceup() and c:IsRelateToEffect(e)) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c35399317.eqfilter),tp,0,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsType(TYPE_EFFECT) and tc:IsControler(1-tp) then
	end
	if not Duel.Equip(tp,tc,c,false) then return end
	--Add Equip limit
	tc:RegisterFlagEffect(35399317,RESET_EVENT+RESETS_STANDARD,0,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c35399317.eqlimit)
	tc:RegisterEffect(e1)
end
function c35399317.eqlimit(e,c)
	return e:GetOwner()==c
end
--disable
function c35399317.disfilter(c)
	return c:IsFaceup() and c:GetFlagEffect(35399317)~=0
end
function c35399317.distg(e,c)
	local g=e:GetHandler():GetEquipGroup():Filter(c35399317.disfilter,nil)
	return g:IsExists(Card.IsCode,1,nil,c:GetCode()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function c35399317.discon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup():Filter(c35399317.disfilter,nil)
	local code,type=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE,CHAININFO_TYPE)
	return type==TYPE_MONSTER and g:IsExists(Card.IsCode,1,nil,code)
end
function c35399317.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
 --atk limit
function c35399317.atktg(e,c)
	local g=e:GetHandler():GetEquipGroup():Filter(c35399317.disfilter,nil)
	return g:IsExists(Card.IsCode,1,nil,c:GetCode())
end