--冬日滑雪·红帽
local m=111007
local cm=_G["c"..m]
function cm.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)	
end
function cm.cfilter2(c,tp)
	return (c:IsReason(REASON_EFFECT) or c:IsReason(REASON_BATTLE)) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP) and c:IsType(TYPE_MONSTER)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsContains(e:GetHandler()) then return false end
	return eg:IsExists(cm.cfilter2,1,nil,tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local hg=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c)
		if hg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=hg:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),c)
		end
	end
end