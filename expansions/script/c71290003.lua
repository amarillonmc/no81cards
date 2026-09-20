--银狼LV.999
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,71290002)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(cm.dop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)

	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e0:SetCondition(cm.ahacon)
	e0:SetTarget(cm.ahatg)
	e0:SetOperation(cm.ahaop)
	c:RegisterEffect(e0)
end
function cm.filter(c)
	return aux.IsCodeListed(c,71290002) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if Duel.Damage(1-tp,100,REASON_EFFECT) and g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		if c:IsLocation(LOCATION_HAND) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,c) then
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,c)+c
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.TossDice(tp,1)
	if d==1 or d==2 or d==3 then
		Duel.RegisterFlagEffect(tp,81290002,0,0,1)
	elseif d==4 or d==5 or d==6 then
		Duel.RegisterFlagEffect(tp,101290002,0,0,1)
	elseif d==99 then
		if Duel.GetFlagEffect(tp,m)~=0 then return end

		local olp=Duel.GetLP(tp)
		Duel.SetLP(tp,999999)

		local ct=Duel.GetTurnCount()
		Duel.Hint(HINT_CARD,0,m)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(olp)
		e1:SetCondition(cm.epcon)
		e1:SetOperation(cm.epop)
		e1:SetValue(ct)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)

		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,2)
	end
end
function cm.epcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetValue()
	return Duel.GetTurnCount()~=ct
end
function cm.epop(e,tp,eg,ep,ev,re,r,rp)
	local olp=e:GetLabel()
	Duel.SetLP(tp,olp)
end
function cm.ahacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),71290002)~=0
end
function cm.ahatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) 
		and (e:GetHandler():IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false))) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function cm.ahaop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local tf=false
		if c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
			tf=true
		elseif c:IsAbleToHand() then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,c)
			tf=true
		end
		if tf==false then return end
		local chain=Duel.GetCurrentChain()
		local num=0
		if chain<3 then num=1
		else
			while chain>=3 do
				num=num+1
				chain=chain-3
			end
		end
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		local maxnum=math.min(num,#g)
		Duel.Hint(HINT_MESSAGE,1-tp,HINTMSG_REMOVE)
		local sg=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,LOCATION_ONFIELD,0,maxnum,maxnum,nil)
		Duel.Remove(sg,nil,REASON_RULE+REASON_EFFECT)
	end
end


