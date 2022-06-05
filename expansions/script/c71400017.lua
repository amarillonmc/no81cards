--幻异梦境-门扉房间
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400017.initial_effect(c)
	--Activate
	--See AddYumeFieldGlobal
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400017,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c71400017.tg1)
	e1:SetOperation(c71400017.op1)
	c:RegisterEffect(e1)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400017,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c71400017.tg2)
	e2:SetOperation(c71400017.op2)
	c:RegisterEffect(e2)
	--self to deck & activate field
	yume.AddYumeFieldGlobal(c,71400017,1)
end
function c71400017.filter1(c)
	return c:IsSetCard(0xa714) and c:IsType(TYPE_FIELD) and not c:IsCode(71400017) and c:IsAbleToHand()
end
function c71400017.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400017.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function c71400017.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c71400017.filter1,tp,LOCATION_DECK,0,nil)
		if g:GetCount()<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g:Select(tp,1,1,nil)
		--[[
		g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
		if g:GetCount()>0 and Duel.SelectYesNo(tp,210) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg2=g:Select(tp,1,1,nil)
			sg1:Merge(sg2)
		end
		--]]
	Duel.SendtoHand(sg1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg1)
end
function c71400017.filter2(c)
	return c:IsCode(71400020) and c:IsAbleToHand()
end
function c71400017.filter2r(c,tp)
	return c:IsSetCard(0xe714) and c:IsAbleToRemove(tp)
end
function c71400017.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400017.filter2,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and Duel.GetMatchingGroupCount(c71400017.filter2r,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,tp)>4 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,5,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c71400017.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c71400017.filter2r,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	if g:GetClassCount(Card.GetCode)<5 then return end
	local rg=Group.CreateGroup()
	for i=1,5 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		rg:AddCard(sc)
		g:Remove(Card.IsCode,nil,sc:GetCode())
	end
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c71400017.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g2:GetCount()>0 then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end