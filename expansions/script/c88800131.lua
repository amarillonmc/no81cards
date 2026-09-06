--心之钢 厄斐琉斯
local s,id,o=GetID()
s.Heart_steel=true
function s.initial_effect(c)
	s.iv(c)
	s.th(c)
	s.sp(c,2)
end
function s.sp(c,lv)
	local lv=lv
	--handes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(2)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	--e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.spcon)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg(lv))
	e3:SetOperation(s.spop(lv))
	c:RegisterEffect(e3)
end
function s.spcfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(s.spcfilter,1,nil,1-tp)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.spfilter(c,e,tp,mc,lv)
	if c:IsLevel(lv) or not (c.Heart_steel==true and c:IsType(TYPE_MONSTER)) then return false end
	local ft=Duel.GetMZoneCount(tp,mc,tp)
	return c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function s.sptg(lv)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
			if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,e:GetHandler(),lv) end
	end
end
function s.spop(lv)
	return function(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,c,lv)
			local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
			local tc=g:GetFirst()
			if tc then
				if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
					Duel.SendtoHand(tc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc)
				else
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				end
			end
	end
end

function s.iv(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1124)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.indtg)
	e1:SetValue(aux.indoval)
	c:RegisterEffect(e1)
end
function s.indtg(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c.Heart_steel==true
end
function s.th(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1190)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id+114)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function s.thfilter(c)
	return c.Heart_steel==true and c:IsAbleToHand() and c:IsFaceupEx() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end