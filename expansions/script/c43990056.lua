--N公司 执锤者 浮士德
local m=43990056
local cm=_G["c"..m]
function cm.initial_effect(c)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43990056,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c43990056.ttcon)
	e1:SetOperation(c43990056.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE+SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c43990056.condition)
	e2:SetTarget(c43990056.target)
	e2:SetOperation(c43990056.operation)
	c:RegisterEffect(e2)
	--tribute check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c43990056.valcheck)
	c:RegisterEffect(e3)
	e2:SetLabelObject(e3)
	e3:SetLabelObject(e2)
	
end
function c43990056.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c43990056.filter(c,e,tp)
	return c:IsSetCard(0x3510) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c43990056.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c43990056.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c43990056.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(c43990056.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,math.min(ct,ft))
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c43990056.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:FilterCount(Card.IsRace,nil,RACE_MACHINE)
--  e:SetLabel(ct)
	e:GetLabelObject():SetLabel(ct)
end
function c43990056.ctfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsFaceup()
end
function c43990056.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c43990056.ctfilter,tp,0,LOCATION_MZONE,nil)
	return minc<=2 and Duel.CheckTribute(c,2,99,mg,1-tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c43990056.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c43990056.ctfilter,tp,0,LOCATION_MZONE,nil)
	local g=Duel.SelectTribute(tp,c,2,99,mg,1-tp)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
