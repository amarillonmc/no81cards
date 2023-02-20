--龙辉巧-上辅λ
local m=11612606
local cm=_G["c"..m]
function c11612606.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=aux.AddDrytronSpSummonEffect(c,cm.extraop)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,m)
end
function cm.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x154)
end
function cm.extraop(e,tp)
	if Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,2) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.disfilter),tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		Duel.SendtoDeck(tg,nil,1,REASON_EFFECT)
		Duel.Draw(tp,2,REASON_EFFECT)
	end  
end
function cm.disfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end