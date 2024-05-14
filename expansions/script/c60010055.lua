--愿母神三度为你阖眼
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x626,LOCATION_ONFIELD)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
end
if not cm.lblsz then
	cm.lblsz=true
	cm._tossdice=Duel.TossDice
	Duel.TossDice=function (tp,a,b)
		Duel.RaiseEvent(Duel.GetDecktopGroup(tp,1),EVENT_CUSTOM+m,nil,0,tp,tp,0)
		if Duel.GetFlagEffect(tp,m+10000000)~=0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) then
			local rg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil):Select(tp,1,2,nil)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
			Duel.ResetFlagEffect(tp,m+10000000)
		end
		if Duel.GetFlagEffect(tp,m)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,m) and Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,m):RandomSelect(tp,1):IsAbleToHand(tp) then
			Duel.RegisterFlagEffect(tp,m,0,0,1)
			local ag=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,m):Select(tp,1,1,nil)
			Duel.SendtoHand(ag,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,ag)
			local rt={}
			local c=a
			if b then
				c=c+b
			end
			for i=1,c do
				table.insert(rt,4)
			end
			return table.unpack(rt)
		else
			return cm._tossdice(tp,a,b)
		end   
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x626,3)
	end
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x626,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x626,1,REASON_COST)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		Duel.RegisterFlagEffect(p,m+10000000,RESET_PHASE+PHASE_END,0,1)
	end
end
