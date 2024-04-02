--燃煤装机 萨弗里
local s,id=GetID()
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
		  --suicide
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,id)
	e0:SetTarget(s.destg)
	e0:SetOperation(s.desop)
	c:RegisterEffect(e0)
 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id+10000)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
 --to hand or spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DECKDES)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,id+20000)
	e5:SetCondition(s.tscon)
	e5:SetTarget(s.tstg)
	e5:SetOperation(s.tsop)
	c:RegisterEffect(e5)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

function s.filter(c,e,tp)
	return c:IsSetCard(0x541a) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsFaceup() or c:IsLocation(LOCATION_DECK))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HintSelection,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
	end  
 local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 
function s.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsNonAttribute(ATTRIBUTE_FIRE)
end

function s.tscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.tsfilter(c,tp)
	return c:IsSetCard(0x541a) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToRemove() and 
	Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,c:GetCode())
end
function s.thfilter(c,code)
	return c:IsSetCard(0x541a) and not c:IsCode(code) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function s.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tsfilter,tp,LOCATION_EXTRA,0,1,e:GetHandler(),tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.tsop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(s.tsfilter,tp,LOCATION_EXTRA,0,1,e:GetHandler(),tp) then return end
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.tsfilter,tp,LOCATION_EXTRA,0,1,1,e:GetHandler(),tp)
	local tc=g:GetFirst()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,tc:GetCode())
		if g:GetCount()<=0 then return end
		local tc=g:GetFirst()
		if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end





