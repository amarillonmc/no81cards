local cm,m,o=GetID()
function cm.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE) 
	   e2:SetCountLimit(1,m+1)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(cm.lvop)
	c:RegisterEffect(e2)
end
function cm.lvop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE) 
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.indtg)
	e1:SetValue(aux.indoval)
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp)
end 
function cm.indtg(e,c)
	return c:IsSetCard(0xae51)
end
function cm.thfilter(c,e,tp,lv)
	return  not c:IsLevel(lv)
		and c:IsSetCard(0xae51)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.cfilter(c,e,tp)
	return c:IsAbleToHand() and c:IsFaceup() and c:IsSetCard(0xae51) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,c:GetLevel())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
  
		return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_ONFIELD)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		local rc=e:SetLabelObject(g:GetFirst())
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,rc)
	if sg:GetCount()>0 then
		local ig=sg:GetFirst()
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		local fid=e:GetHandler():GetFieldID()
		if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) then
		   local e2=Effect.CreateEffect(e:GetHandler())
		   e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(cm.immval)
		e2:SetLabel(fid)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		ig:RegisterEffect(e2,true)
		end

	end
end
end
function cm.immval(e,te)
	local tc=te:GetOwner()
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActivated()
		
end