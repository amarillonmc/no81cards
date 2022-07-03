--缇雅·雅莉珂希德 交错
local m=60002052
local cm=_G["c"..m]
cm.name="缇雅·雅莉珂希德 交错"
function cm.initial_effect(c)
	--Remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.lztg)
	e1:SetOperation(cm.lzop)
	c:RegisterEffect(e1)  
end
function cm.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.lzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if e:GetHandler():IsRelateToEffect(e) and g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tg=g:FilterSelect(tp,Card.IsAbleToRemove,1,2,nil)
		if tg:GetCount()>0 then
			Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
		end
	end
end