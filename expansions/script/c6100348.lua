--朦雨的箱庭-临界的雨境
local s,id,o=GetID()
function s.initial_effect(c)
	--场地魔法通用注册
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	--①：魔陷发动时检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	--②：特召水属性变星 (1回合2次，不取对象)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_LVCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(2)
	e2:SetTarget(s.lvtg)
	e2:SetOperation(s.lvop)
	c:RegisterEffect(e2)

	--③：破坏遗言 (结束阶段堆墓)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,id+1)
	e3:SetOperation(s.regop)
	c:RegisterEffect(e3)
end

-- === 效果① ===
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	-- 其他魔法·陷阱卡的效果发动的场合
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler()~=e:GetHandler()
end

function s.thfilter(c)
	-- 4星以外的「朦雨」怪兽
	return c:IsSetCard(0x613) and c:IsType(TYPE_MONSTER) and not c:IsLevel(4) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

-- === 效果② ===
function s.lvfilter(c,e,tp)
	-- 水属性且在场上表侧表示
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsLevelAbove(1)
end

function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.lvfilter,1,nil,e,tp) end
end

function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	
	-- 过滤出当前还在场上的合法目标
	local g=eg:Filter(s.lvfilter,nil,e,tp)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		-- 选那之内的1只 (不取对象)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc then
			Duel.HintSelection(sg) -- 提示选择了哪张卡
			local lv=Duel.AnnounceLevel(tp,1,9,tc:GetLevel())
			
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end

-- === 效果③ ===
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	-- 注册结束阶段效果
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,3))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(s.tgcon)
	e1:SetOperation(s.tgop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function s.tgcheck(c,tp)
	-- 「朦雨」魔法·陷阱卡 且 墓地无同名卡
	return c:IsSetCard(0x613) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end

function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.tgcheck,tp,LOCATION_DECK,0,1,nil,tp)
end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgcheck,tp,LOCATION_DECK,0,1,1,nil,tp)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end