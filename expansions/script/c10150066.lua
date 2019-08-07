--大怪兽大破坏
function c10150066.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10150066+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c10150066.target)
	e1:SetOperation(c10150066.activate)
	c:RegisterEffect(e1)
end
function c10150066.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xd3)
end
function c10150066.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	local ct=Duel.GetMatchingGroupCount(c10150066.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return ct>0 and Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c10150066.cfilter(c)
	return c:IsCanAddCounter(0x37,1) and c:IsFaceup()
end
function c10150066.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct<=0 then return end
	local cg=Duel.GetMatchingGroup(c10150066.cfilter,tp,LOCATION_ONFIELD,0,nil)
	if cg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10150066,0)) then
	   for tc in aux.Next(cg) do
		   tc:AddCounter(0x37,1)
	   end
	end   
end

