--最终肃清
local m=14010027
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:GetLevel()>0 and c:IsFaceup() and c:IsSummonableCard()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_MZONE,LOCATION_MZONE,g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,LOCATION_MZONE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local sg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_MZONE,LOCATION_MZONE,tc)
		if sg:GetCount()>0 then
			local sel=0
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPTION)
			sel=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))+1
			if sel==1 then
				local sg1=Duel.GetMatchingGroup(function(c) return c:IsAttackBelow(tc:GetAttack()) and c:IsFaceup() end,tp,LOCATION_MZONE,LOCATION_MZONE,tc)
				if sg1:GetCount()>0 then
					Duel.SendtoGrave(sg1,REASON_EFFECT)
				end
			elseif sel==2 then
				local sg1=Duel.GetMatchingGroup(function(c) return c:IsLevelBelow(tc:GetLevel()) and c:IsFaceup() end,tp,LOCATION_MZONE,LOCATION_MZONE,tc)
				if sg1:GetCount()>0 then
					Duel.SendtoGrave(sg1,REASON_EFFECT)
				end
			end
		end
	end
end