-- 特诺奇的住民
local s,id=GetID()

function s.initial_effect(c)
	-- ①：二速展示手卡本家，自身公开变星级，之后可超量召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetCountLimit(1,id+10000)
	e2:SetCondition(s.condition1)
	e2:SetTarget(s.xyztg)
	e2:SetOperation(s.xyzop)
	c:RegisterEffect(e2)
end

-- ==================== ①效果：条件与Cost ====================
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	-- 必须在主要阶段
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function s.cfilter(c,ec)
	-- 寻找手卡中可以展示的「特诺奇」怪兽（除自身外，且有星级，不能是已经公开的卡）
	return c:IsSetCard(0x5328) and c:IsType(TYPE_MONSTER) and c:GetLevel()>0 and not c:IsPublic() and c~=ec
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,c,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,c,c)
	Duel.ConfirmCards(1-tp,g)
	-- 将展示怪兽的星级记录在 Label 中，方便结算时提取
	e:SetLabel(g:GetFirst():GetLevel())
	Duel.ShuffleHand(tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsLocation(LOCATION_HAND) end
end

-- ==================== ①效果：结算逻辑 ====================
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabel()
	-- 确保这张卡还在手卡
	if not c:IsRelateToEffect(e) or c:GetLocation()~=LOCATION_HAND then return end

	-- 计算效果持续到“对方回合结束时”的重置次数
	local rst=RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END
	local ct= (Duel.GetTurnPlayer()==tp) and 2 or 1

	-- 1. 自身变成公开状态
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(rst,ct)
	c:RegisterEffect(e1)
	local fid=c:GetFieldID()
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,EFFECT_FLAG_CLIENT_HINT,1,fid,66)

	-- 2. 星级变成被展示怪兽的星级
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_LEVEL)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
	e2:SetValue(lv)
	e2:SetReset(rst,ct)
	c:RegisterEffect(e2)


end

-- ==================== 2 效果 ====================
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	-- 必须在主要阶段
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and e:GetHandler():IsPublic()
end
function s.xyzfilter(c,g)
	return c:IsSetCard(0x5328) and c:IsXyzSummonable(g,#g,#g)
end
function s.xyzcfilter(c,e)
	return c==e:GetHandler()
end
function s.xyzfselect(g,e,tp)
	return g and g:IsExists(s.xyzcfilter,1,nil,e) and Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function s.xyzmatfilter(c)
	return c:IsType(TYPE_MONSTER) 
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.xyzmatfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	if chk==0 then return g and g:CheckSubGroup(s.xyzfselect,2,#g,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end 
	local g=Duel.GetMatchingGroup(s.xyzmatfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=g:SelectSubGroup(tp,s.xyzfselect,false,1,#g,e,tp)
	if #sg<1 then return end 
	local scg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,sg)
	if scg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rg=scg:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,rg:GetFirst(),sg)
	end
end