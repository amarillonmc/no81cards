--心之钢 凯隐
local s,id,o=GetID()
s.Heart_steel=true
function s.initial_effect(c)
	s.set(c)
	s.hsp(c)
	s.sp(c,5)
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

function s.hsp(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	--e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.hspcon)
	e1:SetOperation(s.hspop)
	c:RegisterEffect(e1)
end
function s.spcostfilter1(c)
	return c:IsAbleToRemoveAsCost() and c.Heart_steel==true
end
function s.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetMZoneCount(tp)<=0 then return false end
	local g=Duel.GetMatchingGroup(s.spcostfilter1,tp,LOCATION_GRAVE,0,nil)
	return #g>0
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(s.spcostfilter1,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:Select(tp,1,1,nil)
	if #sg>0 then
		Duel.Remove(sg,POS_FACEUP,REASON_COST)
	end
end

function s.set(c)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,id)
	e5:SetTarget(s.settg)
	e5:SetOperation(s.setop)
	c:RegisterEffect(e5)
end
function s.setfilter(c)
	return c.Heart_steel==true and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.fselect(g,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	return g:GetClassCount(Card.GetCode)==#g and (ft>1 or g:IsExists(Card.IsType,1,nil,TYPE_FIELD))
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK,0,nil)
		return --Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and
			g:CheckSubGroup(s.fselect,2,2,tp) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	--if Duel.GetLocationCount(tp,LOCATION_SZONE)<=1 then return end
	local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=g:SelectSubGroup(tp,s.fselect,false,2,2,tp)
	if sg and #sg==2 then
		Duel.SSet(tp,sg)
	end
end
