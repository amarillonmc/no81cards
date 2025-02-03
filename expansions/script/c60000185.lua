--破
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60000179)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_RECOVER+CATEGORY_TOGRAVE+CATEGORY_COUNTER+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.handcon(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,2,nil,m)
end
function cm.filter(c)
	return c:IsType(TYPE_SPELL)
end
function cm.gfil(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local num=400*#Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,nil)
	if Duel.Recover(tp,num,REASON_EFFECT) then
		local rg=Duel.GetMatchingGroup(cm.gfil,tp,0,LOCATION_MZONE,nil,num)
		if #rg~=0 then Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) end
		local mg=Duel.GetMatchingGroup(cm.pfil,tp,LOCATION_MZONE,0,nil)
		local num=#mg*4
		for c in aux.Next(mg) do
			num=num-c:GetCounter(0x62b)
		end
		local tgg=Duel.GetMatchingGroup(cm.tgfil,tp,LOCATION_HAND,0,nil)
		local maxnum=math.min(num,#tgg)
		if maxnum==0 or not Duel.SelectYesNo(tp,aux.Stringid(m,1)) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local tg=tgg:Select(tp,1,maxnum,nil)
		if Duel.SendtoGrave(tg,REASON_EFFECT)~=0 then
			local fnum=#Duel.GetOperatedGroup()
			for i=1,fnum do
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
				local pg=Duel.GetMatchingGroup(cm.pfil,tp,LOCATION_MZONE,0,nil):Select(tp,1,1,nil)
				pg:GetFirst():AddCounter(0x62b,1)
			end
			Duel.Draw(tp,fnum,REASON_EFFECT)
		end
	end
end
function cm.tgfil(c)
	return aux.IsCodeListed(c,60000179) and c:IsAbleToGrave()
end
function cm.pfil(c)
	return c:IsCode(60000179) and c:IsFaceup() and not c:IsDisabled() and c:GetCounter(0x62b)<4
end

