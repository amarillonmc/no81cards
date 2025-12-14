--破碎世界形神皆清
local s,id,o=GetID()
function s.initial_effect(c)
	--①：送墓对方怪兽 + 非地属性副作用
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	--②：结束阶段回收
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.reccon)
	e2:SetTarget(s.rectg)
	e2:SetOperation(s.recop)
	c:RegisterEffect(e2)
end

-- === 效果① ===
function s.cfilter(c)
	return c:IsSetCard(0x616) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	-- 记录被展示的卡，以便在效果处理时检查其属性
	e:SetLabelObject(g:GetFirst())
end

function s.tgfilter(c)
	return c:IsAttackPos()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local rc=e:GetLabelObject()
	
	-- 送墓对方怪兽
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
	
	-- 检查展示怪兽：若非地属性且还在手卡，则送去墓地
	if rc and not rc:IsAttribute(ATTRIBUTE_EARTH) and rc:IsLocation(LOCATION_HAND) then
		Duel.BreakEffect()
		Duel.SendtoGrave(rc,REASON_EFFECT)
	end
end

-- === 效果② ===
function s.fusfilter(c)
	return c:IsSetCard(0x616) and c:IsType(TYPE_FUSION) and c:IsFaceup()
end

function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.fusfilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.sendfilter(c)
	return c:IsSetCard(0x616) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup() and c:IsAbleToGrave()
end

function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.sendfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and (c:IsAbleToHand() or c:IsSSetable()) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end

function s.recop(e,tp,eg,ep,ev,re,r,rp)
	-- 选场上1张表侧魔陷送墓
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.sendfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		
		local b1=c:IsAbleToHand()
		local b2=c:IsSSetable()
		local op=0
		
		if b1 and b2 then
			op=Duel.SelectOption(tp,1190,1153) -- 加入手卡 / 盖放
		elseif b1 then
			op=0
		elseif b2 then
			op=1
		else
			return
		end
		
		if op==0 then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		else
			Duel.SSet(tp,c)
		end
	end
end