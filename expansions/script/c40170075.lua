--混沌骑士 盖亚
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id,66889139)
	c:EnableReviveLimit()
	--未知原因 直接在cdb添加字段无效 是否是因为同名卡原因？
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_ADD_SETCODE)
	e0:SetValue(0xcf)
	e0:SetLabel(id)
	e0:SetCondition(s.condition)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.rittg)
	e1:SetOperation(s.ritop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.condition(e)
	local c=e:GetHandler()
	local label=e:GetLabel()
	if label>0 and c:GetOriginalCodeRule()==label then
		return c:IsCode(c:GetOriginalCodeRule())
	else
		return true
	end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function s.mfilter(c,e)
	return c:IsFaceup() and c:GetLevel()>0 and not c:IsImmuneToEffect(e) and c:IsReleasable()
end
function s.rcfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0xbd)
end
function s.rcheck(c)
	return  function(tp,g,c)
				return g:IsExists(s.rcfilter,1,nil,tp) and not g:IsExists(Card.IsControler,2,nil,1-tp)
			end
end
function s.rittg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		mg1:Remove(Card.IsLocation,nil,LOCATION_HAND)
		local mg2=Duel.GetMatchingGroup(s.mfilter,tp,0,LOCATION_MZONE,nil,e)
		mg1:Merge(mg2)
		aux.RCheckAdditional=s.rcheck(c)
		aux.GCheckAdditional=aux.RitualCheckAdditional(c,c:GetLevel(),"Greater")
		local res=mg1:CheckSubGroup(aux.RitualCheck,1,63,tp,c,c:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		aux.RCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end

function s.ritop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local mg1=Duel.GetRitualMaterial(tp)
	mg1:Remove(Card.IsLocation,nil,LOCATION_HAND)
	local mg2=Duel.GetMatchingGroup(s.mfilter,tp,0,LOCATION_MZONE,nil,e)
	mg1:Merge(mg2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	aux.RCheckAdditional=s.rcheck(c)
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,c:GetLevel(),"Greater")
	local mat=mg1:SelectSubGroup(tp,aux.RitualCheck,true,1,63,tp,c,c:GetLevel(),"Greater")
	aux.GCheckAdditional=nil
	aux.RCheckAdditional=nil
	if mat and mat:GetCount()>0 then
		c:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		c:CompleteProcedure()
	end
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end

function s.filter(c,e,tp)
	return c:IsType(TYPE_FUSION) and aux.IsCodeOrListed(c,66889139) and c:CheckFusionMaterial()
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	tc:SetMaterial(nil)
	if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
		tc:CompleteProcedure()
	end
end