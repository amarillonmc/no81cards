--星宫六喰 美丽
local m=33400607
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,cm.xyzfilter,4,2)
	c:EnableReviveLimit() 
  --Remove 
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1,m)
	e0:SetCost(cm.spcost)
	e0:SetTarget(cm.sptg)
	e0:SetOperation(cm.spop)
	c:RegisterEffect(e0)
--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.atkcon)
	e1:SetTarget(cm.atktg)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.atkcon2)
	c:RegisterEffect(e2) 
end
function cm.xyzfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)  and c:IsRace(RACE_SPELLCASTER)
end

function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=0
	if e:GetHandler():GetFlagEffect(33401301)>0 then ft=1 end
	if chk==0 then return  ((ft==1) or e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)) end   
	if ft==0 then 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end
end
function cm.refilter(c)
	return c:IsSetCard(0x341) and c:IsAttribute(ATTRIBUTE_DARK) 
		and c:IsAbleToRemove()
end
function cm.spfilter(c,e,tp)
	return  c:IsLevel(4) and  c:IsSetCard(0x341) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_SPELLCASTER)
	   and  c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) 
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.refilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		if  Duel.SelectYesNo(tp,aux.Stringid(m,1)) then 
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		  local tr=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp) 
		  Duel.SpecialSummon(tr,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end  
end

function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetFlagEffect(tp,33460651)==0
end
function cm.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetFlagEffect(tp,33460651)>0
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return  Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE,nil,1,tp,LOCATION_MZONE)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	local tc1=g:GetFirst()
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(600)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(600)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e2)
	if  Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) then 
		 if  Duel.SelectYesNo(tp,aux.Stringid(m,2)) then 
		 Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT)
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local g2=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
			local tc2=g2:GetFirst()
			local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(1200)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc2:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				e2:SetValue(1200)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc2:RegisterEffect(e2)
		end
	end
end