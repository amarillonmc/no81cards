--血晶化现象的解析员
local s,id,o=GetID()
function c33201057.initial_effect(c) 
	c:EnableCounterPermit(0x32b)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,c33201057.lcheck)
	c:EnableReviveLimit()   
	--to grave 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_COUNTER) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1,33201057) 
	e1:SetTarget(c33201057.tgtg) 
	e1:SetOperation(c33201057.tgop) 
	c:RegisterEffect(e1)  
	--change 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
	e2:SetCode(EVENT_CUSTOM+id)  
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1) 
	e2:SetTarget(c33201057.cgtg) 
	e2:SetOperation(c33201057.cgop) 
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.checkcon) 
	e3:SetOperation(s.checkop)
	c:RegisterEffect(e3)

end 
s.VHisc_Vampire=true 


function s.checkcon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():GetCounter(0x32b)>=4 and not e:GetHandler():IsRace(RACE_ZOMBIE) and e:GetHandler():GetFlagEffect(id)==0
end 
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+id,e,REASON_EFFECT,tp,tp,ev)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
end

function c33201057.mfilter(c) 
	return c:IsRace(RACE_ZOMBIE) and c.VHisc_Vampire  
end
function c33201057.tgfil(c)
	return c.VHisc_Vampire and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c33201057.lcheck(g)
	return g:IsExists(c33201057.mfilter,1,nil)
end
function c33201057.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33201057.tgfil,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsCanAddCounter(0x32b,2) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK) 
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,e:GetHandler(),0,0x32b)
end 
function c33201057.tgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c33201057.tgfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
			c:AddCounter(0x32b,2) 
		end 
	end 
end 
function c33201057.cgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
end 
function c33201057.cgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_ZOMBIE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end 
end 
