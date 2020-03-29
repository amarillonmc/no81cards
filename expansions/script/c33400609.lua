--星宫六喰 星下思绪
local m=33400609
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,cm.xyzfilter,6,2)
	c:EnableReviveLimit() 
	--to deck
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_TODECK)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCountLimit(1,m)
	e0:SetCondition(cm.tdcon)
	e0:SetTarget(cm.tdtg)
	e0:SetOperation(cm.tdop)
	c:RegisterEffect(e0)
--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,4))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m+10000)
	e1:SetCondition(cm.rmcon)
	e1:SetCost(cm.rmcost)
	e1:SetTarget(cm.rmtg1)
	e1:SetOperation(cm.rmop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e2) 
  --
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,m+20000)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(cm.spcon2)
	c:RegisterEffect(e4)
end
function cm.xyzfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_SPELLCASTER)
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chkc then return true end
	if chk==0 then return  Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,1-tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   if not Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil)  then return false end
   local ss=3
   if c:GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_XYZ) then ss=6 end 
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,ss,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end

function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m+90000)==0
end
function cm.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=0
	if e:GetHandler():GetFlagEffect(33401301)>0 then ft=1 end
	if chk==0 then return  ((ft==1) or e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)) end   
	if ft==0 then 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end
   e:GetHandler():RegisterFlagEffect(m+90000,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0) 
end
function cm.refilter(c)
	return  c:IsSetCard(0x341)  and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()  
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x341) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_SPELLCASTER)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function cm.rmtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return  Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_DECK,0,1,nil) or 
	Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil) then 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	end
	if Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) then 
	 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
	end
end
function cm.rmop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=0
	local b2=0
	local op
	if Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_DECK,0,1,nil) then b1=1 end
	if Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) then b2=1 end 
	if b1==0 and b2==0 then return end
	if b1==1 and b2==1 then  
			op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	end
	if  b1==1 and b2==0 then op=0 end 
	if  b1==0 and b2==1 then op=1 end 
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE) 
		local g1=Duel.SelectMatchingCard(tp,cm.refilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc1=g1:GetFirst()
		Duel.Remove(tc1,POS_FACEUP,REASON_EFFECT)   
	end 
	if op==1 then  
		 local g2=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
		 Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
	end
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetFlagEffect(tp,33460651)==0  and e:GetHandler():GetFlagEffect(m)==0
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetFlagEffect(tp,33460651)>0 and e:GetHandler():GetFlagEffect(m)==0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)  
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	local tc1=g:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCountLimit(1)
		e1:SetValue(cm.valcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc1:RegisterEffect(e1)
	 if  Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) then 
		 if  Duel.SelectYesNo(tp,aux.Stringid(m,3)) then 
			Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local g2=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
			local tc2=g2:GetFirst()  
			  local e6=Effect.CreateEffect(e:GetHandler())
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e6:SetRange(LOCATION_MZONE)
			e6:SetCode(EFFECT_IMMUNE_EFFECT)
			e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e6:SetValue(cm.efilter)
			e6:SetOwnerPlayer(tp)
			tc2:RegisterEffect(e6)
		end
	end
end
function cm.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end