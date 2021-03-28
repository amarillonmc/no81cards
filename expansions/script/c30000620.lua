--苍花的魔女
function c30000620.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30000620,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,30000620)
	e1:SetCost(c30000620.lvcost)
	e1:SetTarget(c30000620.lvtg1)
	e1:SetOperation(c30000620.lvop1)
	c:RegisterEffect(e1)
	--special summon cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_SPSUMMON_COST)
	e2:SetCost(c30000620.spcost)
	e2:SetOperation(c30000620.spop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(30000620,ACTIVITY_SUMMON,c30000620.limcoun)
	Duel.AddCustomActivityCounter(30000620,ACTIVITY_SPSUMMON,c30000620.limcoun) 
end
function c30000620.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c30000620.filter(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c30000620.lvtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c30000620.filter(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c30000620.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c30000620.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
end
function c30000620.lvop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetCode(EFFECT_XYZ_LEVEL)
		e2:SetLabelObject(tc)
		e2:SetValue(c30000620.xyzlv)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c30000620.xyzlv(e,c,rc)
	local tc=e:GetLabelObject()
	if c:IsAttribute(tc:GetAttribute()) and c:IsFaceup() then
		return tc:GetLevel()
	else
		return c:GetLevel()
	end
end
function c30000620.spcost(e,c,tp)
	return Duel.GetCustomActivityCount(30000620,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(30000620,tp,ACTIVITY_SPSUMMON)==0
end
function c30000620.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c30000620.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c30000620.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c30000620.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
function c30000620.limcoun(c)
	return c:IsType(TYPE_XYZ) or not c:IsLocation(LOCATION_EXTRA)
end