--炽金战兽 瑞妮
local m=82209161
local cm=c82209161
function cm.initial_effect(c)
	--common spsummon effect  
	local e0=Effect.CreateEffect(c)  
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)  
	e0:SetCode(EVENT_TO_GRAVE)  
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)  
	e0:SetCondition(cm.cmcon)  
	e0:SetTarget(cm.cmtg)  
	e0:SetOperation(cm.cmop)  
	c:RegisterEffect(e0) 
	--search  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,3))  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.thtg)  
	e1:SetOperation(cm.thop)  
	c:RegisterEffect(e1)  
	--handes  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,4))  
	e2:SetCategory(CATEGORY_HANDES)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCode(EVENT_TO_HAND)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,m+10000)  
	e2:SetCondition(cm.hdcon)  
	e2:SetCost(cm.hdcost)
	e2:SetTarget(cm.hdtg)  
	e2:SetOperation(cm.hdop)  
	c:RegisterEffect(e2)  
end

--common
function cm.cmcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	return c:IsPreviousLocation(LOCATION_MZONE) 
			and bit.band(c:GetPreviousRaceOnField(),RACE_MACHINE)~=0 
			and c:IsPreviousPosition(POS_FACEUP) 
			and rp==1-tp and c:GetPreviousControler()==tp
end  
function cm.cmtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function cm.cmop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then  
		if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then 
			--change race
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(m,0))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			e1:SetValue(RACE_BEAST)
			c:RegisterEffect(e1)
			--change base attack
			local atk=c:GetBaseAttack()
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(m,1))
			e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_BASE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			e2:SetValue(atk*2)
			c:RegisterEffect(e2)
			--redirect
			local e3=Effect.CreateEffect(c)  
			e3:SetDescription(aux.Stringid(m,2))
			e3:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetType(EFFECT_TYPE_SINGLE)  
			e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
			e3:SetReset(RESET_EVENT+RESETS_REDIRECT)  
			e3:SetValue(LOCATION_DECKBOT)  
			c:RegisterEffect(e3)  
			Duel.SpecialSummonComplete()
		end 
	end  
end  

--search
function cm.filter(c)  
	return c:IsSetCard(0x5294) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end 
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  

--handes
function cm.hdfilter(c,tp)  
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end  
function cm.hdcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(cm.hdfilter,1,nil,1-tp)  
end  
function cm.hdcfilter(c,tp)
	return c:IsRace(RACE_MACHINE+RACE_BEAST) and (c:IsControler(tp) or c:IsFaceup())
end
function cm.hdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetReleaseGroup(tp):Filter(cm.hdcfilter,nil,tp)
	if chk==0 then return g:CheckSubGroup(aux.gfcheck,2,2,Card.IsRace,RACE_MACHINE,RACE_BEAST) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsRace,RACE_MACHINE,RACE_BEAST)
	aux.UseExtraReleaseCount(sg,tp)
	Duel.Release(sg,REASON_COST)
end
function cm.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end 
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription()) 
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)  
end  
function cm.hdop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)  
	if g:GetCount()>0 then  
		local sg=g:RandomSelect(tp,1)  
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD) 
	end  
end  