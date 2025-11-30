--角兔同笼

--光角幻兔卡号
local key=25795273
local s,id,o=GetID()

function s.initial_effect(c)
    aux.AddCodeList(c,25795273)
    --
    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	c:RegisterEffect(e0)	
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)	
		--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1)
	e2:SetTarget(s.hgsptg)
	e2:SetOperation(s.hgspop)
	c:RegisterEffect(e2)	
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(s.valtg)
	e3:SetValue(s.val)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(s.eftg)
	e5:SetLabelObject(e3)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetLabelObject(e4)
	c:RegisterEffect(e6)
	if not s.global_check then
		s.global_check=true
		--material check
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_SINGLE)
		ge2:SetCode(EFFECT_MATERIAL_CHECK)
		ge2:SetValue(s.valcheck)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		ge1:SetTargetRange(0xff,0xff)
		ge1:SetLabelObject(ge2)
		Duel.RegisterEffect(ge1,0)
	end
end

function s.valcheck(e,c)
	local mg=c:GetMaterial()
	if mg:IsExists(Card.IsCode,1,nil,25795273) and c:GetFlagEffect(id)==0 then
		c:RegisterFlagEffect(id,RESET_EVENT+0x4fe0000,0,1)
	end
end

function s.hgspfilter(c,e,tp)
    return (c:IsCode(25795273) or aux.IsCodeListed(c,25795273)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.hgsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.hgspfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND+LOCATION_GRAVE)
end
function s.hgspop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local spg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.hgspfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if not (spg:GetCount()>0) then return end
    Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
end

function s.valtg(e,c)
    return c:IsFaceup() and e:GetOwner()~=c
end
function s.val(e,c)
    if c:GetLevel()>0 then
	    return c:GetLevel()*-300
	elseif c:GetRank()>0 then
	    return c:GetRank()*-300
	elseif c:GetLink()>0 then
	    return c:GetLink()*-300
	else
	    return 0
	end
end

function s.cfilter(c)
	
end
function s.eftg(e,c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_SYNCHRO)
		and c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:GetFlagEffect(id)~=0
end
