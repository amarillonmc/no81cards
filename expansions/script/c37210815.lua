local s,id=GetID()
function s.initial_effect(c)
	-- 场地魔法发动
	-- 这个卡名的卡1回合只能发动1张。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	-- ②：这张卡的卡名只要在手卡·卡组·场上·墓地存在当作「海」使用。
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE)
	e2:SetValue(22702055)
	c:RegisterEffect(e2)

	-- ③：1回合1次，自己的主要阶段或对方把怪兽特殊召唤的场合才能发动。自己的1张手卡持续公开。
	-- (分为起动效果与诱发效果，通过卡片 Flag 共享 1回合1次 的限制)
	
	-- ③-1：自己的主要阶段
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(s.pubtg)
	e3:SetOperation(s.pubop)
	c:RegisterEffect(e3)

	-- ③-2：对方把怪兽特殊召唤的场合
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(s.pubcon)
	c:RegisterEffect(e4)
end

-- ==================== 效果① ====================
function s.thfilter(c)
	-- 目标：水属性·水族·守备力1300的怪兽
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_AQUA) and c:GetDefense()==1300 and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	-- ①：作为这张卡发动时的效果处理，可以从卡组把1只水属性·水族·守备力1300的怪兽加入手卡。
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

-- ==================== 效果③ ====================
function s.pubcon(e,tp,eg,ep,ev,re,r,rp)
	-- 判断是否有对方特召的怪兽
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end
function s.pubfilter(c)
	return not c:IsPublic()
end
function s.pubtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	-- 判断这张卡的 Flag，以确保一回合只能使用其中一个效果1次
	if chk==0 then return c:GetFlagEffect(id)==0
		and Duel.IsExistingMatchingCard(s.pubfilter,tp,LOCATION_HAND,0,1,nil) end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.pubop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.pubfilter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		if tc then
			-- 赋予持续公开效果
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end