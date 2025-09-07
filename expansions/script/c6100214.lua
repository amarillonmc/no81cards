--炽融调度小组-莺
local s,id=GetID()
function s.initial_effect(c)
	-- XYZ怪兽
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,6,2,nil,nil,99)
	aux.AddCodeList(c,6100196)
	-- 效果①: 超量召唤时添加超量素材
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_OVERLAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.ovcon)
	e1:SetTarget(s.ovtg)
	e1:SetOperation(s.ovop)
	c:RegisterEffect(e1)
	
	-- 效果②: 有特定素材时超量召唤
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

-- 效果①: 超量召唤成功条件
function s.ovcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

-- 效果①: 选择炽融卡作为超量素材
function s.ovfilter(c)
	return c:IsSetCard(0x612) and not c:IsType(TYPE_TOKEN)
end

function s.xyzfilter(c)
	return c:IsSetCard(0x612) and c:IsType(TYPE_XYZ)
end

function s.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(s.ovfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_OVERLAY,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local xyzg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if #xyzg==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.IsExistingMatchingCard(s.ovfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.ovfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		tc=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.Overlay(tc,g)
	end
end

-- 效果②: 有炽融快反小组-理作为素材且主要阶段条件
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,6100196)
end

-- 效果②: 选择炽融怪兽进行超量召唤
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x612) and c:IsType(TYPE_XYZ) and not c:IsRank(6)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.tgfilter(c)
	return c:IsSetCard(0x612) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsSetCard(0x612) and chkc~=e:GetHandler() end
	if chk==0 then 
		return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
			and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.HintSelection(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsControler(1-tp) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local xyzg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
		if #xyzg>0 then
		local xyzc=xyzg:GetFirst()
		local mg=tc:GetOverlayGroup()
			if mg:GetCount()~=0 then
			Duel.Overlay(xyzc,mg)
		end
		xyzc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(xyzc,Group.FromCards(tc))
		Duel.SpecialSummon(xyzc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		xyzc:CompleteProcedure()
			end
	end
end
