--整合运动·宿主士兵
function c79020028.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,1,2,nil,nil,99)
	c:EnableReviveLimit()  
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c79020028.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--control
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,79020028)
	e3:SetTarget(c79020028.contg)
	e3:SetOperation(c79020028.conop)
	c:RegisterEffect(e3)
	--grave sp
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,790200289999999)
	e4:SetCost(c79020028.gscost)
	e4:SetOperation(c79020028.gsop)
	c:RegisterEffect(e4)
end
function c79020028.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c79020028.contg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil,e,tp) and e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,tp,0)
end
function c79020028.conop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.GetControl(tc,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(0x3904)
	tc:RegisterEffect(e1)
	tc:RegisterFlagEffect(79020033,0,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(79020033,4))
end
function c79020028.gscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79020028.gsop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c79020028.linkcon)
	e2:SetOperation(c79020028.linkop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	e2:SetReset(RESET_PHASE+PHASE_END)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetTargetRange(LOCATION_GRAVE,0)
	e3:SetTarget(c79020028.mattg)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetLabelObject(e2)
	Duel.RegisterEffect(e3,tp)
end
function c79020028.lmfilter(c,lc,tp,og,lmat)
	return c:IsFaceup() and c:IsSetCard(0x3904) 
end
function c79020028.linkcon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c79020028.lmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c79020028.linkop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local mg=Duel.SelectMatchingCard(tp,c79020028.lmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	c:SetMaterial(mg)
		local lg=mg:GetFirst():GetOverlayGroup()
		if lg:GetCount()~=0 then
			Duel.Overlay(c,lg)
		end
	Duel.Overlay(c,mg)

end
function c79020028.mattg(e,c)
	return c:IsSetCard(0x3904) and c:IsType(TYPE_XYZ)
end


