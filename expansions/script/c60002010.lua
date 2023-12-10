--时光酒桌 花月
local m=60002010
local cm=_G["c"..m]
function cm.initial_effect(c)
	--hand effect 1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(cm.cvtg1)
	e2:SetOperation(cm.cvop1)
	c:RegisterEffect(e2)
	--hand effect 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(cm.cvtg2)
	e2:SetOperation(cm.cvop2)
	c:RegisterEffect(e2)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.cvtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cm.cvfilter1(c)
	return c:IsCode(60002024) and c:IsAbleToHand()
end
function cm.cvop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	local t=Duel.GetFlagEffect(tp,60002009)
	if Duel.GetTurnCount()+t>=2 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.ConfirmDecktop(tp,2)
		local g=Duel.GetDecktopGroup(tp,2)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			if sg:GetFirst():IsAbleToHand() then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
			else
				Duel.SendtoGrave(sg,REASON_RULE)
			end
			Duel.ShuffleDeck(tp)
		end
	end
end
function cm.cvtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,0,nil)
	if chk==0 then return g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function cm.cvop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_SZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.filter(c,e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function cm.ofilter(c)
	return c:IsFaceup() and c:IsCode(60002024)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetFlagEffect(tp,60002009)
	if Duel.GetTurnCount()+t>=2 then
		if Duel.GetCurrentPhase()==PHASE_MAIN1 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x629))
			e1:SetValue(cm.filter)
			e1:SetReset(RESET_PHASE+PHASE_MAIN1)
			Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_MAIN1,0,1)
		elseif Duel.GetCurrentPhase()==PHASE_MAIN2 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x629))
			e1:SetValue(cm.filter)
			e1:SetReset(RESET_PHASE+PHASE_MAIN2)
			Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_MAIN2,0,1)
		else   
		end
		Duel.RegisterEffect(e1,tp)
	end
	Duel.RegisterFlagEffect(tp,60002009,RESET_PHASE+PHASE_END,0,1000)
	if Duel.IsExistingMatchingCard(cm.ofilter,tp,LOCATION_FZONE,0,1,c) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
