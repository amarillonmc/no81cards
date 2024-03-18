--天泪骑士-瓦莱莉雅
local m=40011479
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),4,2,nil,nil,99) 
	--  
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetCondition(cm.xxcon) 
	e1:SetOperation(cm.xxop) 
	c:RegisterEffect(e1) 
	--to ex sp th 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE_STEP_END)  
	e2:SetCondition(aux.dsercon) 
	e2:SetCost(cm.spthcost)
	e2:SetTarget(cm.spthtg)
	e2:SetOperation(cm.spthop)
	c:RegisterEffect(e2)
end
function cm.xxcon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) 
end 
function cm.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_CARD,0,m) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.limcon)
	e1:SetOperation(cm.limop)
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetOperation(cm.limop2)
	e3:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e3,tp)
end 
function cm.limfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup()
end
function cm.limcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.limfilter,1,nil,tp)
end
function cm.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(cm.chainlm)
	elseif Duel.GetCurrentChain()==1 then
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(cm.resetop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_BREAK_EFFECT)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(m)
	e:Reset()
end
function cm.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(m)~=0 then
		Duel.SetChainLimitTillChainEnd(cm.chainlm)
	end
	e:GetHandler():ResetFlagEffect(m)
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) 
end 
function cm.spthcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetOverlayGroup() 
	local sg=g:Filter(cm.spfil,nil,e,tp)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() and Duel.GetMZoneCount(tp,e:GetHandler())>0 and sg:GetCount()>0 end 
	g:KeepAlive()
	e:SetLabelObject(g)
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKTOP,REASON_COST) 
end 
function cm.spthtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
	local g=e:GetLabelObject()  
	local sg=g:Filter(cm.spfil,nil,e,tp):Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)  
	if sg:GetCount()<ft then ft=sg:GetCount() end 
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,ft,0,0)
end 
function cm.spfilter2(c,e,tp)
	return c:IsSetCard(0xcf1a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject() 
	local sg=g:Filter(cm.spfil,nil,e,tp):Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)  
	if sg:GetCount()<ft then ft=sg:GetCount() end 
	if ft==0 then return end 
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end 
	local ssg=sg:Select(tp,ft,ft,nil) 
	if Duel.SpecialSummon(ssg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then 
		Duel.BreakEffect()  
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetMatchingGroup(cm.spfilter2,tp,LOCATION_HAND,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end  
end 



