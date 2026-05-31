--轮回六道 修罗之攻
function c79011449.initial_effect(c)
	aux.AddCodeList(c,79011442)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79011449,1))
	e1:SetCategory(CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)   
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)   
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(79011442) end,tp,LOCATION_MZONE,0,1,nil) end)
	e1:SetTarget(c79011449.target)
	e1:SetOperation(c79011449.activate)
	c:RegisterEffect(e1)
end  
c79011449.SetCard_Pain_PBLK_Skill=true  
function c79011449.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD) 
end
function c79011449.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then 
		Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
		Duel.CreateToken(tp,79011441) 
		if c79011441.excon(e,tp,eg,ep,ev,re,r,rp) and Duel.SelectYesNo(tp,aux.Stringid(79011441,1)) then 
			c79011441.exop(e,tp,eg,ep,ev,re,r,rp)
		end 
		Duel.CreateToken(tp,79011440) 
		if c79011440.excon(e,tp,eg,ep,ev,re,r,rp) and Duel.SelectYesNo(tp,aux.Stringid(79011440,1)) then 
			c79011440.exop(e,tp,eg,ep,ev,re,r,rp)
		end 
	end
end





