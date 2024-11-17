--钱眼
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,23410001)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--special summon
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(m,1))
	e11:SetCategory(CATEGORY_TOHAND)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_GRAVE)
	e11:SetCountLimit(1,m)
	e11:SetCost(aux.bfgcost)
	e11:SetTarget(cm.tg)
	e11:SetOperation(cm.op)
	c:RegisterEffect(e11)
	local e22=e11:Clone()
	e22:SetDescription(aux.Stringid(m,2))
	e22:SetTarget(cm.pltg)
	e22:SetOperation(cm.plop)
	c:RegisterEffect(e22)
end
function cm.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e)):Select(tp,1,1,nil)
	if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 then
		local g=Duel.GetOperatedGroup()
		if g:GetFirst():GetOwner()==tp then Duel.Draw(tp,1,REASON_EFFECT) end
	end
end
function cm.filter1(c)
	return c:IsCode(23410001) and c:IsAbleToHand()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.plfil(c)
	return c:IsCode(23410002) and not c:IsForbidden()
end
function cm.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.plfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function cm.plop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.plfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end