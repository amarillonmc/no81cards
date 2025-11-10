--装弹枪管强袭纵火龙
local s,id=GetID()
function s.initial_effect(c)
	--summon with 1 tribute
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(s.otcon)
	e0:SetOperation(s.otop)
	e0:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e1)
	--Destroy 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) end)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	--Tribute check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(s.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end
function s.otfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK)
end
function s.otcon(e,c,minc)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(s.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function s.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(s.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,1,nil,0x10f,0x102) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	if e:GetLabel()==1 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
	Duel.SetChainLimit(s.chainlm)
end
function s.chainlm(e,rp,tp)
	return tp==rp
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if e:GetLabel()==1 then
		Duel.Destroy(g,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:Select(tp,1,1,nil)
		if #dg>0 then
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
function s.tcfilter(c,e,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(1-tp) and c:IsReason(REASON_BATTLE|REASON_EFFECT)
		and c:IsCanBeEffectTarget(e) and not c:IsType(TYPE_TOKEN)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetAttack())
end
function s.spfilter(c,e,tp,atk)
	return c:IsSetCard(0x102) and c:IsAttackBelow(atk) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and s.tcfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:IsExists(s.tcfilter,1,nil,e,tp) end
	local g=eg:Filter(s.tcfilter,nil,e,tp)
	local _,atk=g:GetMaxGroup(Card.GetAttack)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,atk)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and aux.NecroValleyFilter()(tc) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end