--我的等级是！十亿！
local m=190015
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7fa) and c:GetLevel()>0 and c:GetLevel()~=c:GetOriginalLevel()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(cm.confilter,tp,LOCATION_MZONE,0,1,nil) then return end
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.confilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.confilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,cm.confilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local ss
	if tc:GetLevel()>tc:GetOriginalLevel() then 
	   ss=tc:GetLevel()-tc:GetOriginalLevel()
	else
	   ss=tc:GetOriginalLevel()-tc:GetLevel()
	end
   local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,ss,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:GetLevel()~=tc:GetOriginalLevel() and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)  then
		local ss
		if tc:GetLevel()>tc:GetOriginalLevel() then 
		   ss=tc:GetLevel()-tc:GetOriginalLevel()
		else
		   ss=tc:GetOriginalLevel()-tc:GetLevel()
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,ss,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end 
end