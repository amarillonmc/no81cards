--魔力联合 木棉
function c33200452.initial_effect(c)
	--spsummon proc
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetCountLimit(1,33200452+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(c33200452.spcon0)
	e0:SetOperation(c33200452.spop0)
	c:RegisterEffect(e0)
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c33200452.tgtg)
	e1:SetOperation(c33200452.tgop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsm from deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200452,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,33200453)
	e3:SetCost(c33200452.spcost)
	e3:SetTarget(c33200452.sptg)
	e3:SetOperation(c33200452.spop)
	c:RegisterEffect(e3)
end

--e0
function c33200452.spfilter0(c)
	return c:IsSetCard(0x329) and c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0
end
function c33200452.spcon0(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0 and Duel.IsExistingMatchingCard(c33200452.spfilter0,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,nil)  
end
function c33200452.spop0(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c33200452.spfilter0,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,2,nil)
	Duel.Release(g,REASON_COST)
end

--e1e2
function c33200452.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK+LOCATION_HAND)
end
function c33200452.tgfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGrave()
end
function c33200452.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetMatchingGroupCount(c33200452.tgfilter,1-tp,LOCATION_DECK+LOCATION_HAND,0,nil)>=2 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(1-tp,c33200452.tgfilter,1-tp,LOCATION_DECK+LOCATION_HAND,0,2,2,nil)
		if g:GetCount()~=0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end

--e3
function c33200452.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c33200452.spfilter(c,e,tp)
	return c:IsSetCard(0x3329) and c:IsLevelBelow(7) and not c:IsCode(33200452) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33200452.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c33200452.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c33200452.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33200452.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end