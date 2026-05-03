--死冥之地 伊里伽尔
local s,id,o=GetID()
function s.initial_effect(c)
	--发动
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--增加效果   
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
    e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	--盖放	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
    e3:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_SSET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.setcon)
	e3:SetTarget(s.settg)
	e3:SetOperation(s.setop)
	c:RegisterEffect(e3)
end
function s.thfilter(c)
	return c:IsSetCard(0x364b) and c:IsAbleToHand()
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function s.cfilter(c)
	return c:IsSetCard(0x364b) and c:IsFaceup()
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFlagEffect(tp,id)==0 
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rp~=tp and bit.band(Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION),LOCATION_ONFIELD)~=0 then
        if re:IsActiveType(TYPE_MONSTER) then
        	local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVED)
			e1:SetRange(LOCATION_MZONE)
    		e1:SetCondition(s.tgcon)
			e1:SetOperation(s.tgop)
            e1:SetLabelObject(re)
            e1:SetReset(RESET_CHAIN)
			rc:RegisterEffect(e1) 
        elseif re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then 
            local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVED)
			e2:SetRange(LOCATION_SZONE)
    		e2:SetCondition(s.tgcon)
			e2:SetOperation(s.tgop)
            e2:SetLabelObject(re)
            e2:SetReset(RESET_CHAIN)
			rc:RegisterEffect(e2) 
        end                		                   
	end	
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re==e:GetLabelObject() and not c:IsLocation(LOCATION_HAND+LOCATION_REMOVED+LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(1-tp,aux.Stringid(id,4)) then
    	Duel.Hint(HINT_CARD,0,id)
    	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
    	Duel.RegisterFlagEffect(1-tp,id,RESET_PHASE+PHASE_END,0,1)
	end        
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
    if re and re:GetHandler():IsSetCard(0x364b) then
    	e:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE+CATEGORY_GRAVE_ACTION)
    end
end
function s.bhfilter(c)
	return c:IsSetCard(0x364b) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 and re and re:GetHandler():IsSetCard(0x364b)
    	and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.bhfilter),tp,LOCATION_GRAVE,0,1,nil) 
        and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
    	Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.bhfilter),tp,LOCATION_GRAVE,0,1,1,nil)
    	if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end        
end