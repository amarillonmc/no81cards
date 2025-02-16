--Protoss·使徒
function c65870060.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65870060,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,65870060)
	e1:SetCondition(c65870060.tkcon)
	e1:SetTarget(c65870060.tktg)
	e1:SetOperation(c65870060.tkop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65870060,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,65870060)
	e2:SetCost(c65870060.discost)
	e2:SetTarget(c65870060.destg1)
	e2:SetOperation(c65870060.desop1)
	c:RegisterEffect(e2)
end

function c65870060.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return not aux.tkfcon(e,tp)
end
function c65870060.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,65870061,0x3a37,TYPES_TOKEN_MONSTER,0,0,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c65870060.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,65870061,0x3a37,TYPES_TOKEN_MONSTER,0,0,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,65870061)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end

function c65870060.rfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function c65870060.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c65870060.rfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c65870060.rfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c65870060.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65870060.desop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and e:GetLabelObject():IsType(TYPE_TOKEN) and Duel.SelectYesNo(tp,aux.Stringid(65870060,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end