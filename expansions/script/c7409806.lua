--污手党执行者
function c7409806.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c7409806.spcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,7409806)
	e2:SetCost(c7409806.aucost)
	e2:SetOperation(c7409806.auop)
	c:RegisterEffect(e2)
end
c7409806.Grimy_Goons=true
function c7409806.Grimy_Goons_filter(c)
	return c.Grimy_Goons
end
function c7409806.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsPublic()
end
function c7409806.filter(c,e,tp)
	return c.Grimy_Goons and c:IsAbleToHandAsCost() and not c:IsAttribute(ATTRIBUTE_DARK)
end
function c7409806.aucost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,9126352)==0 and Duel.IsExistingMatchingCard(c7409806.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c7409806.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c7409806.auop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7409806,3))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(2500)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	tc:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	tc:RegisterEffect(e3)
end
