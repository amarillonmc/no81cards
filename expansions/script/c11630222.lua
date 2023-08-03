--地型镜·探矿镜
local m=11630222
local cm=_G["c"..m]
function c11630222.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)	 
end
cm.SetCard_xxj_Mirror=true
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if chk==0 then return ct>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct end
	e:SetLabel(c:GetSequence())
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(cm.chainlm(c))
	end
end
function cm.chainlm(c)
	return function(e,ep,tp)
		return tp==ep or not e:GetHandler():GetColumnGroup():IsContains(c)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if ct==0 then return end
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil)
	Duel.DisableShuffleCheck()
	if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 then ct=ct-1 end
	Duel.ShuffleHand(tp)
	if ct>0 then Duel.SortDecktop(tp,tp,ct) end
end