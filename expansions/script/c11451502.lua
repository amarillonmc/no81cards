--终端逆时者
--21.04.10
local m=11451502
local cm=_G["c"..m]
function cm.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_ATTACK)
	e1:SetCost(cm.redcost)
	e1:SetOperation(cm.redop)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		cm.reg=false
		cm[0]=0
		cm[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.callback(c,rp)
	local p=c:GetControler()
	if Duel.GetCurrentChain()~=0 and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE) then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	eg:ForEach(cm.callback,rp)
end
function cm.redcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.redop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,2)
	if cm.reg then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCondition(cm.recon)
	e1:SetOperation(cm.reop)
	e1:SetOwnerPlayer(0)
	Duel.RegisterEffect(e1,0)
	local e2=e1:Clone()
	e2:SetOwnerPlayer(1)
	Duel.RegisterEffect(e2,1)
	cm.reg=true
end
function cm.filter(c,e,tp)
	return c:GetFlagEffect(m)~=0 and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) or c:IsAbleToHand()) and c:IsType(TYPE_MONSTER)
end
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetOwnerPlayer()
	return Duel.GetFlagEffect(0,m)+Duel.GetFlagEffect(1,m)>0 and Duel.GetCurrentChain()==1 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.filter),p,LOCATION_GRAVE,0,1,nil,e,p)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetOwnerPlayer()
	if (cm[p]<cm[1-p] and Duel.SelectYesNo(p,aux.Stringid(m,2))) or (cm[p]==cm[1-p] and Duel.SelectYesNo(p,aux.Stringid(m,4))) then
		local g=Duel.SelectMatchingCard(p,aux.NecroValleyFilter(cm.filter),p,LOCATION_GRAVE,0,1,1,nil,e,p)
		local tc=g:GetFirst()
		if Duel.GetLocationCount(p,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,p,false,false) and not tc:IsHasEffect(EFFECT_NECRO_VALLEY) and (not tc:IsAbleToHand() or Duel.SelectOption(p,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,p,p,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,tc)
		end
		cm[p]=cm[p]+1
	end
end