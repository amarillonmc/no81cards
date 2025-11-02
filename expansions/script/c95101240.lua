--失控磁盘 双子星
function c95101240.initial_effect(c)
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95101240,0))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c95101240.postg)
	e1:SetOperation(c95101240.posop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--attack effect:spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95101240,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c95101240.atkcon)
	e3:SetTarget(c95101240.sptg)
	e3:SetOperation(c95101240.spop)
	e3:SetLabel(LOCATION_HAND)
	c:RegisterEffect(e3)
	--defense effect:spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(95101240,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c95101240.defcon)
	e4:SetTarget(c95101240.sptg)
	e4:SetOperation(c95101240.spop)
	e4:SetLabel(LOCATION_GRAVE)
	c:RegisterEffect(e4)
end
function c95101240.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c95101240.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local res=Duel.TossCoin(tp,1)
	if res==1 then Duel.ChangePosition(c,POS_FACEUP_ATTACK)
	else Duel.ChangePosition(c,POS_FACEUP_DEFENSE) end
end
function c95101240.atkcon(e)
	return e:GetHandler():IsAttackPos()
end
function c95101240.defcon(e)
	return e:GetHandler():IsDefensePos()
end
function c95101240.spfilter(c,e,tp,chk)
	return c:IsSetCard(0x6bb0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (chk==0 or aux.NecroValleyFilter()(c))
end
function c95101240.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=e:GetLabel()
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c95101240.spfilter,tp,loc,0,1,nil,e,tp,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function c95101240.spop(e,tp,eg,ep,ev,re,r,rp)
	local loc=e:GetLabel()
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c95101240.spfilter,tp,loc,0,1,1,nil,e,tp,1):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
