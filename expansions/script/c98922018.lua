--究极宝玉神 虹暗桥龙
local s,id=GetID()
function s.initial_effect(c)
	--融合召唤素材: "宝玉兽"怪兽x7
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x1034),7,true)

	--特殊召唤限制（1回合只能有1次融合召唤或以下方法的特殊召唤）
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)

	--特召程序：解放自己场上1只暗属性·10星怪兽
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)

	--用于记录1回合1次特殊召唤的监听
	local e_reg=Effect.CreateEffect(c)
	e_reg:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e_reg:SetCode(EVENT_SPSUMMON_SUCCESS)
	e_reg:SetOperation(s.regop)
	c:RegisterEffect(e_reg)

	--①：攻击力上升 + 检索「桥梁」
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(s.atkcost)
	e3:SetTarget(s.atktg)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)

	--②：全场除外
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCost(s.remcost)
	e4:SetTarget(s.remtg)
	e4:SetOperation(s.remop)
	c:RegisterEffect(e4)
end

-- 特召限制逻辑
function s.splimit(e,se,sp,st,fc)
	if Duel.GetFlagEffect(sp,id)>0 then return false end
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end

-- 特召程序过滤
function s.spfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevel(10) and c:IsType(TYPE_MONSTER)
end

function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetFlagEffect(tp,id)>0 then return false end
	return Duel.CheckReleaseGroup(tp,s.spfilter,1,nil)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,s.spfilter,1,1,nil)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end

function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
	-- 规则特召成功时，给玩家注册Flag
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end

-- 融合召唤或其他方式特召成功时，也要注册Flag实现共用1次限制
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end

-- ① 效果相关函数
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0x1034) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,0x1034)
	local tc=g:GetFirst()
	
	-- 获取攻击力（考虑里侧表示的情况）
	local atk=tc:GetAttack()
	if tc:IsFacedown() then atk=tc:GetTextAttack() end
	if atk<0 then atk=0 end
	e:SetLabel(atk)

	-- 判断是否为暗属性
	local is_dark=tc:IsAttribute(ATTRIBUTE_DARK)
	if is_dark then
		e:SetLabelObject(e) -- 用自身作为暗属性标记
	else
		e:SetLabelObject(nil)
	end
	
	Duel.Release(g,REASON_COST)
end

function s.thfilter(c)
	return c:IsSetCard(0x187) and c:IsAbleToHand()
end

function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetLabelObject()==e then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=e:GetLabel()
	-- 攻击力上升
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
	-- 检索“桥梁”卡
	if e:GetLabelObject()==e and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) 
		and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

-- ② 效果相关函数
function s.remcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end

function s.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end

function s.remop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end