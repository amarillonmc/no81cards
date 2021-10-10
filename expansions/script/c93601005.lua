--天威的眷女
local m=93601005
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	c:EnableReviveLimit()
	--special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+100)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target1)
	e2:SetOperation(cm.operation1)
	c:RegisterEffect(e2)
end
function cm.matfilter(c)
	return c:IsLinkSetCard(0x12c) and not c:IsLinkType(TYPE_LINK)
end
function cm.filter22(c,e,tp,sc)
	if c:IsType(TYPE_EFFECT) or not c:IsType(TYPE_LINK) then return false end
	local zone=c:GetLinkedZone(tp)&0xff
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==1 then
		local zonc=c:GetLinkedZone(1-tp)&0xff
		return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zonc)>0
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		local zonec=c:GetLinkedZone(1-tp)&0xff
		local zontp=0xff-zone
		return sc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zontp) or Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zonec)>0
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter22(chkc,e,tp,c) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(cm.filter22,tp,LOCATION_MZONE,0,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.filter22,tp,LOCATION_MZONE,0,1,1,nil,e,tp,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local a=false
	local b=false
	local rc=false
	local zone=tc:GetLinkedZone(tp)&0xff
	local zontp=0xff-zone
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==1 then
		local zonc=tc:GetLinkedZone(1-tp)&0xff
		a=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		zonec=tc:GetLinkedZone(1-tp)&0xff
		b=c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zontp) or Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zonec)>0
	end
	if not a and not b then return end
	if c:IsRelateToEffect(e) then
		if a then
			if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone) then
				rc=true
			end
		elseif b and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zonec)>0 then
			if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
				rc=true
			end 
		elseif b and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zonec)==0 then
			if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zontp) then
				rc=true
			end
		end
	end
	if rc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetOperation(cm.disop)
		tc:RegisterEffect(e1)
	end	

end
function cm.disop(e,tp)
	local tc=e:GetHandler()
	local zone=tc:GetLinkedZone(tp)
	local zone1=tc:GetLinkedZone(1-tp)
	zone=zone|1<<zone1+16
	if zone==0 then return end
	local dis1=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,~zone)
	return dis1
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.filter(c)
	return c:IsLinkSetCard(0x12c) and c:IsAbleToHand()
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end