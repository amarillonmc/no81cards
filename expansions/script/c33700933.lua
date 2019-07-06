--炙热星光焚天爆
function c33700933.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(function(e,tp) return Duel.GetLP(tp)>10000 end)
	e1:SetTarget(c33700933.target)
	e1:SetOperation(c33700933.activate)
	e1:SetValue(33700933)
	c:RegisterEffect(e1)
	if not c33700933.global_check then
		c33700933.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_NEGATED)
		ge1:SetOperation(c33700933.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHAIN_DISABLED)
		Duel.RegisterEffect(ge2,0)
	end
end
function c33700933.checkop(e,tp,eg,ep,ev,re,r,rp)
	local dp,e2,p2=Duel.GetChainInfo(ev,CHAININFO_DISABLE_PLAYER,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	if e2:GetValue() and e2:GetValue()==33700933 and dp~=p2 and Duel.GetLP(dp)>1 then
		Duel.Hint(HINT_CARD,0,33700933)
		Duel.SetLP(dp,1)
	end
end
function c33700933.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=Duel.GetLP(tp)-1
	local b1=lp<9999 
	local b2=lp>=9999 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local b3=lp>=15000 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,LOCATION_HAND,1,nil)
	local b4=lp>=20000 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,nil)
	local b5=lp>=25000 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
	local b6=lp>=30000 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 or b3 or b4 or b5 or b6 end
	if b1 then
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,lp)
	end
	if b2 then 
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	end
	if b3 then 
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,LOCATION_HAND,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	end
	if b4 then 
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	end
	if b5 then 
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
	end
	if b6 then 
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,#g*1000)
	end
end
function c33700933.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=Duel.GetLP(tp)-1
	if lp<=0 then return end
	Duel.SetLP(tp,lp)
	local b1=lp<9999 
	local b2=lp>=9999 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local b3=lp>=15000 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,LOCATION_HAND,1,nil)
	local b4=lp>=20000 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,nil)
	local b5=lp>=25000 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
	local b6=lp>=30000 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,1,nil)
	if b1 then
		Duel.Recover(1-tp,lp,REASON_EFFECT)
	end
	if b2 then
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
	if b3 then
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,LOCATION_HAND,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
	if b4 then
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
	if b5 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	if b6 then
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
		local ct=Duel.Destroy(g,REASON_EFFECT)
		if ct>0 then
			Duel.Damage(1-tp,ct*1000,REASON_EFFECT)
		end
	end
end