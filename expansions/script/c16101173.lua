--神之广告
local m=16101173
local cm=_G["c"..m]
function c16101173.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.discon)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)	  
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)   
	return true 
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.setfilter(c)
	return c:IsSSetable() and c:IsSetCard(0x5a1)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
	local op=1
	local flag=0
	if b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
	else
		op=Duel.SelectOption(tp,aux.Stringid(m,3))+1
	end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
		local sg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			local code=sg:GetFirst():GetOriginalCode()
			Duel.Hint(HINT_CARD,1-tp,code)
			Duel.Hint(HINT_CARD,1-tp,code)
			Duel.Hint(HINT_CARD,1-tp,code)
			Duel.Hint(HINT_CARD,1-tp,code)
			Duel.Hint(HINT_CARD,1-tp,code)
			Duel.Hint(HINT_CARD,1-tp,code)
			Duel.Hint(HINT_CARD,1-tp,code)
			Duel.Hint(HINT_CARD,1-tp,code)
			Duel.Hint(HINT_CARD,1-tp,code)
			Duel.Hint(HINT_CARD,1-tp,code)
			Duel.Hint(HINT_CARD,tp,code)
			Duel.Hint(HINT_CARD,tp,code)
			Duel.Hint(HINT_CARD,tp,code)
			Duel.Hint(HINT_CARD,tp,code)
			Duel.Hint(HINT_CARD,tp,code)
			Duel.Hint(HINT_CARD,tp,code)
			Duel.Hint(HINT_CARD,tp,code)
			Duel.Hint(HINT_CARD,tp,code)
			Duel.Hint(HINT_CARD,tp,code)
			Duel.Hint(HINT_CARD,tp,code)
			flag=1
		end
	else
		Duel.Hint(HINT_CARD,1-tp,m+1) 
		Duel.Hint(HINT_CARD,1-tp,m+1) 
		Duel.Hint(HINT_CARD,1-tp,m+1) 
		Duel.Hint(HINT_CARD,1-tp,m+1) 
		Duel.Hint(HINT_CARD,1-tp,m+1) 
		Duel.Hint(HINT_CARD,1-tp,m+1) 
		Duel.Hint(HINT_CARD,1-tp,m+1) 
		Duel.Hint(HINT_CARD,1-tp,m+1) 
		Duel.Hint(HINT_CARD,1-tp,m+1) 
		Duel.Hint(HINT_CARD,1-tp,m+1) 
		Duel.Hint(HINT_CARD,tp,m+1) 
		Duel.Hint(HINT_CARD,tp,m+1) 
		Duel.Hint(HINT_CARD,tp,m+1) 
		Duel.Hint(HINT_CARD,tp,m+1) 
		Duel.Hint(HINT_CARD,tp,m+1) 
		Duel.Hint(HINT_CARD,tp,m+1) 
		Duel.Hint(HINT_CARD,tp,m+1) 
		Duel.Hint(HINT_CARD,tp,m+1) 
		Duel.Hint(HINT_CARD,tp,m+1) 
		Duel.Hint(HINT_CARD,tp,m+1) 
		flag=1
	end
	if flag==1 and Duel.IsChainNegatable(ev) and Duel.SelectYesNo(1-tp,aux.Stringid(m,1)) then
		Duel.NegateActivation(ev)
	end
end