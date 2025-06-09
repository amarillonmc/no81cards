--誉望万化
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id*2)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)   
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,id)
	e4:SetCost(s.thcost)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4) 
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,1-tp)
end
function s.chkfilter(c)
	return c:IsCode(5012615) and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=Duel.IsExistingMatchingCard(s.chkfilter,tp,LOCATION_ONFIELD,0,1,nil)
	local check2=Duel.IsExistingMatchingCard(s.chkfilter2,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,2)
	if chk==0 then return check or check2 end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function s.filter(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function s.chkfilter2(c)
	return c:IsSetCard(0x23c) and c:IsDiscardable(REASON_EFFECT)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.IsExistingMatchingCard(s.chkfilter,tp,LOCATION_ONFIELD,0,1,nil)
	local check2=Duel.IsExistingMatchingCard(s.chkfilter2,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,2)
	local sg=eg:Filter(s.filter,nil,e,1-tp)
	if check then
		Duel.SendtoDeck(sg,tp,nil,REASON_EFFECT)
	end
	Duel.BreakEffect()
	if check2 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		if Duel.DiscardHand(tp,s.chkfilter2,1,1,REASON_EFFECT+REASON_DISCARD,nil)~=0 then
			Duel.Draw(tp,2,REASON_EFFECT)
		end 
	end
end
function s.cfilter1(c)
	return c:IsSetCard(0x23c) and c:IsAbleToRemoveAsCost()
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter1,tp,LOCATION_GRAVE,0,1,1,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
end
function s.refilter1(c,tc)
	return c:IsType(tc:GetType()) and c:IsAbleToRemove()
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
	Duel.SortDecktop(tp,1-tp,1)
	local tc=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	if Duel.IsExistingMatchingCard(s.refilter1,tp,LOCATION_DECK,0,1,nil,tc) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rc=Duel.SelectMatchingCard(tp,s.refilter1,tp,LOCATION_DECK,0,1,1,nil,tc):GetFirst()
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
	end
end