--囚影残空
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60000032)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition1)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK+CATEGORY_RECOVER+CATEGORY_DAMAGE)
	e2:SetCondition(cm.condition2)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.activate2)
	c:RegisterEffect(e2)
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)==0
end
function cm.filter(c)
	return c:IsCode(60000032) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,100)
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Damage(tp,100,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)>0
end
function cm.filter2(c)
	return (c:IsCode(60000037) or aux.IsCodeListed(c,60000032)) and c:IsAbleToHand()
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local hg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil) 
		and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_DECK,0,nil)>=#hg end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	
	local hg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_DECK,0,nil)<#hg then return end
	local costlp=Duel.Damage(tp,math.floor(Duel.GetLP(tp)/2),REASON_EFFECT)
	if costlp~=0 then
		local dg=Duel.GetDecktopGroup(tp,#hg)
		local hc=hg:GetFirst()
		local dc=dg:GetFirst()
		local thg=Group.CreateGroup()
		local tdg=Group.CreateGroup()
		Duel.ConfirmDecktop(tp,#hg)
		while hc and dc do
			if (dc:IsCode(60000037) or aux.IsCodeListed(dc,60000032)) and dc:IsAbleToHand() and costlp>=1000 then
				costlp=costlp-1200
				thg:AddCard(dc)
				tdg:AddCard(hc)
				hc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			end
			hc=hg:GetNext()
			dc=dg:GetNext()
		end
		if #thg~=0 then 
			Duel.SendtoHand(thg,nil,REASON_EFFECT)
			Duel.SendtoDeck(tdg,nil,0,REASON_EFFECT)
			--if Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_ONFIELD,nil) then
				--local rg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
				--for tc in aux.Next(rg) do
					--tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
				--end
			--end
			local i=math.random(2,3)
			Duel.Hint(24,0,aux.Stringid(m,i))
			--local e4=Effect.CreateEffect(e:GetHandler())
			--e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			--e4:SetCode(EVENT_PHASE+PHASE_END)
			--e4:SetCountLimit(1)
			--e4:SetOperation(cm.reop)
			--Duel.RegisterEffect(e4,tp)
		end
	end
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	if Duel.GetMatchingGroupCount(cm.rcfil,tp,LOCATION_HAND,LOCATION_HAND+LOCATION_ONFIELD,nil)~=0 then
		local num=math.min(Duel.GetMatchingGroupCount(cm.rcfil,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil),Duel.GetMatchingGroupCount(cm.rcfil,tp,LOCATION_HAND,0,nil))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local dg=Duel.SelectMatchingCard(tp,cm.rcfil,tp,LOCATION_HAND,0,num,num,nil)
		if Duel.SendtoDeck(dg,nil,1,REASON_EFFECT)~=0 then
			local rnum=#Duel.GetOperatedGroup()
			Duel.Recover(tp,rnum*1000,REASON_EFFECT)
		end
	end
	e:Reset()
end
function cm.rcfil(c)
	return c:GetFlagEffect(m)~=0
end



--random
function getrand()
	local result=0
	local g=Duel.GetDecktopGroup(0,5)
	local tc=g:GetFirst()
	while tc do
		result=result+tc:GetCode()
		tc=g:GetNext()
	end
	math.randomseed(result)
end








