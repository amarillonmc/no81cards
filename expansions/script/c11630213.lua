--照型镜·创世的神像
local m=11630213
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)	
end 
cm.SetCard_xxj_Mirror=true 
--
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,nil)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND) 
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local sg=g:Select(tp,1,1,nil)
	if sg:GetCount()<1 then return end
	local tg=sg:GetFirst()
	local Code=tg:GetOriginalCode()
	local rc=Duel.CreateToken(tp,Code)
	Duel.SendtoHand(rc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,rc)
	Duel.ShuffleHand(1-tp)
end
