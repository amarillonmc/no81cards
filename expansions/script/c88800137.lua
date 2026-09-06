--心之钢 永恩
local s,id,o=GetID()
s.Heart_steel=true
function s.initial_effect(c)
	s.th(c)
	s.sp(c,3)
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


function s.th(c)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,id+114)
	e5:SetTarget(s.thtg)
	e5:SetOperation(s.thop)
	c:RegisterEffect(e5)
end
function s.lvfilter(c)
	return c:IsFaceup() and c.Heart_steel==true and not c:IsLevel(3)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,1,0,0)
	if Duel.IsExistingMatchingCard(s.lvfilter,tp,LOCATION_MZONE,0,1,nil) then
		e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetAttack)
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end
end