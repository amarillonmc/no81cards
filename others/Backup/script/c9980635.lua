--月骑·朱月
function c9980635.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6bcd))
	e2:SetValue(200)
	c:RegisterEffect(e2)	
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	c:RegisterEffect(e3)
	--special summon (hand)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9980635,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,9980635)
	e4:SetTarget(c9980635.sptg1)
	e4:SetOperation(c9980635.spop1)
	c:RegisterEffect(e4)
	--special summon (GY)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9980635,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,9980635)
	e5:SetCondition(c9980635.spcon)
	e5:SetTarget(c9980635.sptg2)
	e5:SetOperation(c9980635.spop2)
	c:RegisterEffect(e5)
end
function c9980635.spfilter(c,e,tp)
	return c:IsSetCard(0x6bcd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c9980635.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9980635.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c9980635.spop1(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c9980635.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if ft<1 or g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
	if ft>1 and g:GetCount()>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.SelectYesNo(tp,aux.Stringid(9980635,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=g:Select(tp,1,1,nil)
		sg:AddCard(sg2:GetFirst())
	end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
function c9980635.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
end
function c9980635.spfilter2(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x6bcd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c9980635.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9980635.spfilter2,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c9980635.spop2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local g=Duel.GetMatchingGroup(c9980635.spfilter2,tp,LOCATION_REMOVED,0,nil,e,tp)
	if ft<1 or ct<1 or g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
	if not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		ft=ft-1
		ct=ct-1
		while ft>0 and ct>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9980635,2)) do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg2=g:Select(tp,1,1,nil)
			sg:AddCard(sg2:GetFirst())
			g:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
			ft=ft-1
			ct=ct-1
		end
	end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
