--百种兵器-摧岳破斧枪
function c75040009.initial_effect(c)
	aux.AddCodeList(c,75040001)
	aux.AddEquipSpellEffect(c,true,true,c75040009.efilter,nil)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75040009,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetRange(LOCATION_SZONE)
	--e1:SetCondition(c75040009.regcon)
	e1:SetOperation(c75040009.regop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c75040009.descon)
	e2:SetTarget(c75040009.destg)
	e2:SetOperation(c75040009.desop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75040009,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,75040009)
	e3:SetCost(c75040009.spcost)
	e3:SetTarget(c75040009.sptg)
	e3:SetOperation(c75040009.spop)
	c:RegisterEffect(e3)
end
function c75040009.efilter(c)
	return (c:IsRace(RACE_WYRM) or c:IsCode(75040001)) and c:IsFaceup()
end
function c75040009.regop(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsContains(e:GetHandler():GetEquipTarget()) then return end
	local tc=eg:GetFirst():GetBattleTarget()
	Duel.Hint(HINT_CARD,0,75040009)
	Duel.Recover(tp,tc:GetBaseAttack(),REASON_EFFECT)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetValue(-700)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c75040009.descon(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetBattleMonster(0)
	return a and a==e:GetHandler():GetEquipTarget() or d and d==e:GetHandler():GetEquipTarget()
end
function c75040009.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,0x6) end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	g:AddCard(e:GetHandler():GetEquipTarget())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c75040009.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	g:AddCard(e:GetHandler():GetEquipTarget())
	Duel.Destroy(g,REASON_EFFECT)
end
function c75040009.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c75040009.spfilter(c,e,tp,chk)
	return c:IsRace(RACE_WYRM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (chk==0 or aux.NecroValleyFilter()(c))-- and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c75040009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c75040009.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c75040009.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c75040009.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,1):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not c:IsRelateToChain() then return end
	Duel.Equip(tp,c,sc)
end
