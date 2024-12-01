--霞之谷的守卫者
local s,id,o=GetID()
function c98920779.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98920779+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c98920779.spcon)
	e1:SetTarget(c98920779.sptg)
	e1:SetOperation(c98920779.spop)
	c:RegisterEffect(e1)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(s.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCondition(aux.dsercon)
	e3:SetCountLimit(1,98920779)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
function s.indtg(e,c)
	local tc=e:GetHandler()
	return c==tc or c==tc:GetBattleTarget()
end
function c98920779.spfilter(c,tp)
	return c:IsAbleToHandAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c98920779.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c98920779.spfilter,tp,LOCATION_ONFIELD,0,1,nil,tp)
end
function c98920779.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c98920779.spfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c98920779.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoHand(g,nil,REASON_SPSUMMON)
end
function c98920779.spxfilter(c,e,tp)
	return c:IsSetCard(0x37) and not c:IsCode(98920779) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	local c=e:GetHandler()
	if chk==0 then return bc and bc:IsRelateToBattle() and (aux.nzatk(bc) or aux.NegateMonsterFilter(bc)) and c:IsAbleToHand() and Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(c98920779.spxfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,bc,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local ag=Group.FromCards(c,bc):Filter(Card.IsRelateToBattle,nil)
	if #ag>0 and Duel.SendtoHand(ag,nil,REASON_EFFECT) and Duel.GetMZoneCount(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c98920779.spxfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end