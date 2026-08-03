--众妖眷恋的七角山
local s,id,o=GetID()
function s.initial_effect(c)
	--全局监听：记录同名卡的破坏批次
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	--①：对方回合发动本家速攻
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(s.actg)
	c:RegisterEffect(e1)

	--②：破坏手卡，特召自身并检索
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)

	--③：被破坏场合，挂载离场监控
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end

-- === 全局破坏监听 ===
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsCode(id) then
		Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1)
	end
end

-- === 效果①：手卡速攻 ===
function s.actg(e,c)
	return c:IsSetCard(0x3615) and c:IsType(TYPE_QUICKPLAY)
end

-- === 效果②：特召与检索 ===
function s.rmfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.rmfilter,1,nil)
end

function s.thfilter(c)
	return c:IsSetCard(0x3615) and not c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local thg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #thg>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(thg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,thg)
			local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_HAND,0,1,1,nil)
	    if #g>0 then 
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end
end

-- === 效果③：破坏追踪监控 ===
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)==0
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,nil)
			or Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,nil)
	end
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
	g1:Merge(g2)
	if #g1==0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tg=g1:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	if not tc then return end
	Duel.HintSelection(tg)
	-- 如果是手卡，先让其公开
	if tc:IsLocation(LOCATION_HAND) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2)) -- "持续公开"
	end
	
	-- 获取当时选中时的区域
	local orig_loc=tc:GetLocation()
	
	-- 挂载：离开区域时这张卡直接在场上发动 (不入连锁)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) -- 变更为连续效果，立刻适用不入连锁
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetLabelObject(tc)
	e2:SetLabel(orig_loc)
	e2:SetCondition(s.actcon)
	e2:SetOperation(s.actop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end

function s.actfilter(c,tc,orig_loc)
	-- 同一实体对象，且原属区域符合，现属区域不符合
	return c==tc and c:GetPreviousLocation()==orig_loc and c:GetLocation()~=orig_loc
end

function s.actcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local orig_loc=e:GetLabel()
	return eg:IsExists(s.actfilter,1,nil,tc,orig_loc)
end

function s.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,id)
	-- 强制放到场地魔法区，参数三传入 true 会完美被系统视作为魔法卡的【发动】并亮起
	if Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true) then
		-- 成功发动后解除这个复活触发器的监听，防止报错
		e:Reset()
	end
end