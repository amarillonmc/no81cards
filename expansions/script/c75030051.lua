--拂晓巫女 传承米卡娅
function c75030051.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PYRO),4,2,nil,nil,99)
	c:EnableReviveLimit()
	--material
	aux.EnableChangeCode(c,75030024,LOCATION_ONFIELD+LOCATION_GRAVE)
	--炸炸炸
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75030051,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,75030051)
	e1:SetCost(c75030051.cost1)
	e1:SetTarget(c75030051.tg1)
	e1:SetOperation(c75030051.op1)
	c:RegisterEffect(e1)
	--遗言苏生
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75030051,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,75030052)
	e2:SetTarget(c75030051.tg2)
	e2:SetOperation(c75030051.op2)
	c:RegisterEffect(e2)
end
-- 1
function c75030051.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetOverlayCount()>0 end
	local max=c:GetOverlayCount()
	local ct=c:RemoveOverlayCard(tp,1,max,REASON_COST)
	e:SetLabel(ct)
end
function c75030051.filter1(c)
	return c:IsSetCard(0x6751) and c:IsDestructable() and c:IsType(TYPE_MONSTER)
end
function c75030051.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(c75030051.filter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil)
	end
	local ct=e:GetLabel()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD)
end
function c75030051.op1(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.GetMatchingGroup(c75030051.filter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,nil)
	if g:GetCount()>0 then
		local sg=g:Select(tp,1,ct,nil)
		if sg:GetCount()>0 then
			local dc=Duel.Destroy(sg,REASON_EFFECT)
			if dc>0 then
				Duel.Recover(tp,dc*700,REASON_EFFECT)
			end
		end
	end
end
-- 2
function c75030051.filter2(c,e,tp)
	return c:IsSetCard(0x6751) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c75030051.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c75030051.filter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c75030051.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75030051.filter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end