--幽域诞地 暗黑法师
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--local e10=e1:Clone()
	--e10:SetRange(LOCATION_GRAVE)
	--c:RegisterEffect(e10)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,id+o*10000)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCondition(s.damcon)
	e4:SetOperation(s.damop)
	c:RegisterEffect(e4)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsActiveType(TYPE_CONTINUOUS) and re:IsActiveType(TYPE_TRAP) and re:GetHandler():IsSetCard(0x569)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.setfilter(c)
	return c:IsSetCard(0xa569) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end
function s.atktg(e,c)
	local tc=e:GetHandler()
	return c==tc:GetBattleTarget()
end
function s.atkval(e,c)
	return 0
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	return tc and tc:IsControler(1-tp) and tc:IsFaceup()
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetHandler():GetBattleTarget()
	if tc and tc:IsRelateToBattle() then
		local atk=c:GetAttack()
		local dam1=0
		if atk>tc:GetAttack() then
			dam1=atk-tc:GetAttack()
		else
			dam1=tc:GetAttack()-atk
		end
		local def=c:GetDefense()
		local dam2=0
		if not tc:IsType(TYPE_LINK) then
			if def>tc:GetAttack() then
				dam2=def-tc:GetDefense()
			else
				dam2=tc:GetDefense()-def
			end
		end
		Duel.Damage(1-tp,dam1+dam2,REASON_EFFECT)
	end
end