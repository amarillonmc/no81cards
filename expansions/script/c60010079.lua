--枢机神女·澈
local cm,m,o=GetID()
function cm.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(78080961,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
if not cm.num then
	cm.num=0
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.sfil,tp,LOCATION_HAND,0,nil)
	return #g==0
end
function cm.thfilter(c)
	return c:IsSetCard(0x647) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,3,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	local hg=Duel.GetMatchingGroup(cm.sfil,tp,LOCATION_HAND,0,nil)
	if #hg~=0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,3,3,nil)
	if g:GetCount()>2 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g)
			local mg=Duel.GetOperatedGroup()
			local tc=mg:GetFirst()
			for i=1,#mg do
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(m,0))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				
				tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
				tc=mg:GetNext()
			end
			cm.num=#Duel.GetOperatedGroup()
			
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_ADJUST)
			e1:SetCondition(cm.rcon)
			e1:SetOperation(cm.rop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end

function cm.sfil(c)
	return c:GetFlagEffect(m)~=0
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.sfil,tp,LOCATION_HAND,0,nil)
	return cm.num~=#g
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.sfil,tp,LOCATION_HAND,0,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(cm.sfil,tp,LOCATION_HAND,0,nil)
	cm.num=#g
	Duel.Readjust()
	if cm.num==0 then e:Reset() end
end


function cm.ffil(c,tp)
	return c:IsCode(60010084) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function cm.ffil2(c)
	return c:IsCode(60010084) and c:IsFaceup()
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return #Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_HAND,0,nil)>=5
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and not Duel.IsExistingMatchingCard(cm.ffil2,tp,LOCATION_FZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.ffil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		local tc=Duel.SelectMatchingCard(tp,cm.ffil2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
		if tc then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end





