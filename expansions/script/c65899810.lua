--步步为营
-- 效果：
-- 这个卡名的卡在决斗中只能发动１张，②的效果在决斗中只能使用1次。
-- ①：这个回合，对方不能用魔法·陷阱卡的效果把怪兽特殊召唤（这个效果的发动无效的场合或者原本的效果没有适用的场合，对方必须让自身场上·墓地·除外的魔法·陷阱卡以及原本种类是魔法·陷阱卡的怪兽全部回到卡组）。
-- ②：把这个回合没有送去墓地的这张卡从墓地除外才能发动。从卡组把1只光属性·水族怪兽加入手卡。这个回合，自己不能把这个效果加入手卡的没有「步步为营」的卡名记述的怪兽以及那些同名怪兽特殊召唤。
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,id)
	-- ① 发动效果：这个回合，对方不能用魔法·陷阱卡的效果把怪兽特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	-- ②：把这个回合没有送去墓地的这张卡从墓地除外才能发动。从卡组把1只光属性·水族怪兽加入手卡
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id+1+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(aux.exccon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
-- 惩罚效果：对方场上·墓地·除外的魔法·陷阱卡以及原本种类是魔法·陷阱卡的怪兽全部回到卡组
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetOperation(s.penalty)
	Duel.RegisterEffect(e1,tp)
end
function s.penalty(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,id)==0 then
		local g1=Duel.GetMatchingGroup(nil,1-tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		local g=g1:Filter(s.penfilter,nil)
		if g:GetCount()>0 then
			Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
		end
	end
	Duel.ResetFlagEffect(tp,id)
	e:Reset()
end
function s.penfilter(c)
	if c:IsType(TYPE_SPELL+TYPE_TRAP) then return true end
	if c:IsType(TYPE_MONSTER) and bit.band(c:GetOriginalType(),TYPE_SPELL+TYPE_TRAP)~=0 then return true end
	return false
end
-- ①的发动处理
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	local c=e:GetHandler()
	-- 这个回合，对方不能用魔法·陷阱卡的效果把怪兽特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
-- 限制特殊召唤：当特殊召唤来源于魔法·陷阱卡效果时禁止
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se and se:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
-- ②的检索目标：光属性·水族怪兽
function s.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_AQUA) and c:IsAbleToHand()
end
-- ②的Target
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
-- ②的Operation
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		-- 这个回合，自己不能把这个效果加入手卡的没有「步步为营」的卡名记述的怪兽以及那些同名怪兽特殊召唤
		if tc and not aux.IsCodeListed(tc,id) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
			e1:SetTargetRange(1,0)
			e1:SetTarget(s.splimit2)
			e1:SetLabel(tc:GetOriginalCode())
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
-- 特殊召唤限制：不能特殊召唤该怪兽及其同名卡
function s.splimit2(e,c,sump,sumtype,sumpos,targetp,se)
	local code=e:GetLabel()
	return c:IsOriginalCodeRule(code) or c:IsCode(code)
end
