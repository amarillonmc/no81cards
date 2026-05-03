--魔导礼记 合莫
local s,id=GetID()
local SET_MAGIDOREI=0xcd70

function s.initial_effect(c)
	--①：融合召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.fustg)
	e1:SetOperation(s.fusop)
	c:RegisterEffect(e1)
	--②：赋予融合素材代用效果并回到手卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.adcon)
	e2:SetTarget(s.adtg)
	e2:SetOperation(s.adop)
	c:RegisterEffect(e2)
end

function s.matfilter(c,e)
	return c:IsSetCard(SET_MAGIDOREI) and c:IsType(TYPE_MONSTER)
		and c:IsAbleToHand() and not c:IsImmuneToEffect(e)
end

function s.fusfilter(c,e,tp,m,chkf)
	return c:IsType(TYPE_FUSION)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(m,nil,chkf)
end

function s.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetFusionMaterial(tp,LOCATION_MZONE+LOCATION_GRAVE)
		mg=mg:Filter(aux.NecroValleyFilter(s.matfilter),nil,e)
		return Duel.IsExistingMatchingCard(s.fusfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,chkf)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE+LOCATION_GRAVE)
end

function s.fusop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg=Duel.GetFusionMaterial(tp,LOCATION_MZONE+LOCATION_GRAVE)
	mg=mg:Filter(aux.NecroValleyFilter(s.matfilter),nil,e)
	local sg=Duel.GetMatchingGroup(s.fusfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg,chkf)
	if #sg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=sg:Select(tp,1,1,nil):GetFirst()
	if not tc then return end
	local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
	if not mat or #mat==0 then return end
	tc:SetMaterial(mat)
	if Duel.SendtoHand(mat,nil,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)==#mat then
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

function s.adcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rp==tp and re:IsActiveType(TYPE_MONSTER)
		and re:GetActivateLocation()==LOCATION_MZONE
		and rc:IsControler(tp) and rc:IsLocation(LOCATION_MZONE)
		and rc:IsFaceup() and rc:IsSetCard(SET_MAGIDOREI)
end

function s.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if chk==0 then
		return c:IsAbleToHand()
			and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
			and rc:IsControler(tp) and rc:IsLocation(LOCATION_MZONE)
			and rc:IsFaceup() and rc:IsSetCard(SET_MAGIDOREI)
	end
	Duel.SetTargetCard(rc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,LOCATION_GRAVE)
end

function s.subcon(e)
	return e:GetHandler():IsLocation(LOCATION_MZONE)
end

function s.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e)
		and tc:IsFaceup() and tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE)
		and not tc:IsImmuneToEffect(e)) then return end
	if aux.NecroValleyNegateCheck(c) then return end
	--得到融合素材代用效果
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e1:SetCondition(s.subcon)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1,true)
	tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	--这张卡回到手卡
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end
