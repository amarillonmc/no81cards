--淘气猫
local s, id = GetID()

function s.initial_effect(c)
	-- 效果①：对方用抽卡以外的方式从卡组把卡加入手卡时特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	-- 效果②：相邻区域3星以下怪兽特殊召唤时送入墓地
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.descon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end

-- 效果①：发动条件
function s.cfilter(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
-- 效果①：目标设定
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,eg,eg:GetCount(),1-tp,LOCATION_HAND)
	e:SetLabelObject(eg)
end

-- 效果①：操作处理
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local added_cards=e:GetLabelObject()
	
	if c:IsRelateToEffect(e) then
		-- 特殊召唤到对方场上
		if Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)>0 then
			-- 把加入手卡的卡丢弃
			if added_cards and added_cards:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SendtoGrave(added_cards,REASON_EFFECT+REASON_DISCARD)
			end
		end
	end
end

function s.filter(c,seq)
	return c:IsLevelBelow(3) and c:IsLocation(LOCATION_MZONE)
		and c:GetSequence()<5 and math.abs(seq-c:GetSequence())==1
end

-- 效果②：发动条件
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	-- 只处理主怪兽区（0-4）
	if seq>=5 then return false end
	return eg:IsExists(s.filter,1,nil,seq)
end

-- 效果②：目标设定
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(s.filter,nil,e:GetHandler():GetSequence())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end

-- 效果②：操作处理
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.filter,nil,e:GetHandler():GetSequence())
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end