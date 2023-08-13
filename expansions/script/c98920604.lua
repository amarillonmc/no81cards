--闪光No.39 希望皇 霍普异热同心
function c98920604.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,ATTRIBUTE_DARK),4,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920604,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c98920604.xyzcon)
	e1:SetTarget(c98920604.xyztg)
	e1:SetOperation(c98920604.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920604,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(c98920604.ovtg)
	e2:SetOperation(c98920604.ovop)
	c:RegisterEffect(e2)
	--multi attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(c98920604.eaval)
	c:RegisterEffect(e3)
	--disable attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920604,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetCost(c98920604.atkcost)
	e4:SetOperation(c98920604.atkop)
	c:RegisterEffect(e4)
end
aux.xyz_number[98920604]=39
function c98920604.xyzcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c98920604.xyzfilter1,c:GetControler(),LOCATION_MZONE,0,1,nil,e)
end
function c98920604.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	local g=Duel.GetMatchingGroup(c98920604.xyzfilter1,tp,LOCATION_MZONE,0,nil,e)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local xg=g:Select(tp,1,1,nil)
		xg:KeepAlive()
		e:SetLabelObject(xg)
	return true
	else return false end
end
function c98920604.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local mg=e:GetLabelObject()
	local mg2=mg:GetFirst():GetOverlayGroup()
	local eqg=mg:GetFirst():GetEquipGroup()
	mg2:Merge(eqg)
	if mg2:GetCount()~=0 then
	   Duel.Overlay(c,mg2)
	end  
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)  
	mg:DeleteGroup()
end
function c98920604.xyzfilter1(c,e)
	return c:IsSetCard(0x107f) and c:GetEquipCount()>0 and c:IsRank(4)
end
function c98920604.eaval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c98920604.atkfilter,nil)
	return g:GetCount()
end
function c98920604.atkfilter(c)
	return c:IsSetCard(0x107e)
end
function c98920604.eqfilter(c,tp)
	return c:IsSetCard(0x107e) and c.zw_equip_monster and not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_SZONE)
end
function c98920604.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and g:IsExists(c98920604.eqfilter,1,nil,tp) end
end
function c98920604.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local tc=g:FilterSelect(tp,c98920604.eqfilter,1,1,nil,tp):GetFirst()
		if not tc then return end
		tc.zw_equip_monster(tc,tp,c)
	end
end
function c98920604.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98920604.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end