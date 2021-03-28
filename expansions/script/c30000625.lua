--起源神的魔女
function c30000625.initial_effect(c)
   --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2)
	c:EnableReviveLimit()
	--cannot link material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e0:SetValue(c30000625.lmlimit)
	c:RegisterEffect(e0)
	--level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30000625,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,30000625)
	e1:SetCost(c30000625.lvcost)
	e1:SetTarget(c30000625.lvtg1)
	e1:SetOperation(c30000625.lvop1)
	c:RegisterEffect(e1)
end
function c30000625.lmlimit(e)
	local c=e:GetHandler()
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c30000625.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c30000625.filter(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c30000625.lvtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c30000625.filter(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c30000625.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c30000625.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
end
function c30000625.filter1(c,att)
	return c:IsAttribute(att) and c:IsFaceup()
end
function c30000625.lvop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c30000625.filter1,tp,LOCATION_MZONE,0,nil,tc:GetAttribute())
	if g:GetCount()<1 then return end
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		for ac in aux.Next(g) do
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_XYZ_LEVEL)
			e2:SetLabelObject(tc)
			e2:SetValue(c30000625.xyzlv)
			e2:SetReset(RESET_PHASE+PHASE_END)
			ac:RegisterEffect(e2)
		end
	end
end
function c30000625.xyzlv(e,c,rc)
	local tc=e:GetLabelObject()
	return tc:GetLevel()
end