--将死亡唱成一首歌
function c33710904.initial_effect(c)
   --to remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c33710904.tgtg)
	e1:SetOperation(c33710904.tgop)
	c:RegisterEffect(e1) 
end
function c33710904.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_MZONE,0)
	if chk==0 then return Duel.IsPlayerCanRemove(1-tp)
		and g:IsExists(Card.IsAbleToRemove,1,nil,1-tp,POS_FACEUP,REASON_RULE) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_MZONE)
end
function c33710904.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanRemove(1-tp) then return end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local ct=g:GetCount()
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:FilterSelect(1-tp,Card.IsAbleToRemove,1,ct,nil,1-tp,POS_FACEUP,REASON_RULE)
		if Duel.Remove(sg,POS_FACEUP,REASON_RULE)~=0 then
		local og=Duel.GetOperatedGroup()
		local sum=(og:GetSum(Card.GetTextAttack)+og:GetSum(Card.GetTextDefense))*3
		if sum==0 then sum=8000 end
		Duel.SetLP(1-tp,sum)
			for tc in aux.Next(og) do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetTargetRange(0,1)
				e1:SetValue(c33710904.aclimit)
				e1:SetLabel(tc:GetOriginalCode())
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function c33710904.aclimit(e,re,tp)
	local c=re:GetHandler()
	local code=e:GetLabel()
	return c:IsCode(code)
end