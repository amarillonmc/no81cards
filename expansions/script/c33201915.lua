local s,id=GetID()

function s.initial_effect(c)
	-- ①：1回合1次，送去手卡·场上1张卡，从墓地特殊召唤（规则特召，不入连锁）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH) -- “这个卡名的①的方法的特殊召唤1回合只能有1次”
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	-- ②：作为超量素材附加的效果：免疫对方发动的、不取对象的效果
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)

	-- ③：因战斗·效果以外送去墓地的场合，检索本家
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,id+1) -- 作为③的效果1回合只能使用1次
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end

-- ==================== ①效果：墓地规则特召 ====================
function s.spcfilter(c,tp,ft)
	if not c:IsAbleToGraveAsCost() then return false end
	-- 如果怪兽区还有空位，丢手卡或场上的卡都可以
	if ft>0 then return true end
	-- 如果怪兽区满了，必须强行送墓自己场上主要怪兽区的怪兽来腾位置
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 and c:IsControler(tp)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return Duel.IsExistingMatchingCard(s.spcfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c,tp,ft)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.spcfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c,tp,ft)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.SendtoGrave(g,REASON_COST)
	g:DeleteGroup()
end

-- ==================== ②效果：超量素材的非取对象抗性 ====================
function s.efilter(e,te)
	-- 注意：这里的 e:GetHandler() 指的是装备了这张素材的“超量怪兽”
	
	-- 1. 过滤掉自己的效果，并且只针对“发动的效果”（排除永续效果）
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	
	-- 2. 如果对方发动的这个效果【没有取对象】的属性，直接返回 true，免疫它！
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	
	-- 3. 如果对方发动的这个效果【取了对象】，我们需要侦测对象里有没有这只超量怪兽
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	-- 如果对方取对象的目标列表（tg）里，没有这只超量怪兽，说明是选了别人，依然免疫其余波（返回true）
	-- 只有当对方真的选了这只超量怪兽作为对象时，才返回 false（也就是被影响，可以被无限泡影等锁定）
	return not tg or not tg:IsContains(e:GetHandler())
end

-- ==================== ③效果：送去墓地检索 ====================
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 必须是因战斗·效果以外送去墓地
	return not c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_EFFECT)
end
function s.thfilter(c)
	return c:IsSetCard(0x5328) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
