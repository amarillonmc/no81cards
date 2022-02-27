--魔力联合 山茶花
function c33200442.initial_effect(c)
	--spsm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200442,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33200442)
	e1:SetCondition(c33200442.spcon1)
	e1:SetTarget(c33200442.sptg)
	e1:SetOperation(c33200442.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200442,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,33200442)
	e2:SetCondition(c33200442.spcon2)
	e2:SetTarget(c33200442.sptg)
	e2:SetOperation(c33200442.spop)
	c:RegisterEffect(e2)
	--send to grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c33200442.tgtg)
	e3:SetOperation(c33200442.tgop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end

--spsm
function c33200442.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0 
end
function c33200442.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33200442.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end

function c33200442.cfilter(c,tp)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsSummonPlayer(1-tp)
end
function c33200442.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33200442.cfilter,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end

--e4
function c33200442.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,nil,tp,LOCATION_GRAVE)
end
function c33200442.tgfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGrave()
end
function c33200442.tdfilter(c)
	return c:IsSetCard(0x329) and c:IsAbleToDeck()
end
function c33200442.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetMatchingGroupCount(c33200442.tgfilter,1-tp,LOCATION_DECK+LOCATION_HAND,0,nil)>=2 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(1-tp,c33200442.tgfilter,1-tp,LOCATION_DECK+LOCATION_HAND,0,2,2,nil)
		if g:GetCount()~=0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
			e:SetLabel(100)
		end
	else
		e:SetLabel(0)
	end
	if Duel.IsExistingMatchingCard(c33200442.tdfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(33200442,0)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c33200442.tdfilter,tp,LOCATION_GRAVE,0,1,3,nil)
		if g:GetCount()~=0 then
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
	if e:GetLabel()~=100 then Duel.Draw(tp,1,REASON_EFFECT) end
end