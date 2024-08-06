local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local f1=Card.IsType
		Card.IsType=function(sc,typ)
			if sc:GetOriginalCode()==id and sc:IsLocation(LOCATION_DECK) and typ&TYPE_NORMAL~=0 then return true else return f1(sc,typ) end
		end
		local f2=Card.GetType
		Card.GetType=function(sc)
			local typ=f2(sc)
			if sc:GetOriginalCode()==id and sc:IsLocation(LOCATION_DECK) then
				typ=typ&(~TYPE_EFFECT)
				typ=typ|TYPE_NORMAL
			end
			return typ
		end
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(aux.AND(Card.IsFaceup,Card.IsCode),nil,id)
	local typ,race=e:GetHandler():GetSpecialSummonInfo(SUMMON_INFO_TYPE,SUMMON_INFO_RACE)
	return #eg==2 and #g==2 and eg:IsContains(e:GetHandler()) and typ&TYPE_MONSTER~=0 and race&RACE_BEASTWARRIOR~=0
end
function s.spfilter(c,e,tp)
	return c:IsRace(RACE_BEASTWARRIOR) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and (c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
