--秘湮伪界 坠星
local m=33300350
local cm=_G["c"..m]
Duel.LoadScript("c81000000.lua")
function cm.initial_effect(c)
	--summon proc
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(cm.sumcon)
	e1:SetOperation(cm.sumop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
end
function cm.rfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function cm.sumcon(e,c)
	local tp=e:GetHandler():GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=Duel.SelectMatchingCard(tp,cm.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,2,nil)
	if sg:GetCount()>0 then
		Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
	end
end
