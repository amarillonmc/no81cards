--[[
本lua的作者为藜奴儿，如果测试出bug请联系QQ：1502939196

未经允许不支持任何人的任何形式的修改，源数。如有需要请联系作者，而不是私自找人代为修改。
本人对于本lua的任何bug修改、源数和适配后来卡片均为免费，并且追诉期无限。

但是如果使用者私自修改了lua，不论是bug修复还是源数效果，本人对此lua都不会再提供任何形式的支持。
一旦发现任何其他人对本lua进行了任何形式的修改，本人首先自愿放弃此lua除必要署名权以外的所有权利，
同时再也会不承担对此lua的任何维护与后续适配，包括但不限于任何形式的bug修复、效果源数。

如果您想要修改此lua，可以先联系本人，本人会在第一时间进行回复。
并且我承诺，若本人在2天内没有回复您，上述注意事项可作废，您可以直接修改此lua，而后续debug与适配仍然由我来进行。

如果您对本lua有任何疑问，请联系本人，本人会在第一时间进行回复。
如果您对本lua有任何建议，请联系本人，本人会在第一时间进行处理。
]]

--言灵 不要死
--aux.Stringid(id,0)="选择一只怪兽"

local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,36700304)
	
	--Quick-Play Spell Card
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	if not s.global_flag then
		s.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetRange(0xff)
		ge1:SetCondition(s.quickcon_effect)
		ge1:SetOperation(s.quickop)
		c:RegisterEffect(ge1)
	end

end
function s.chkfilter(c)
	return aux.IsCodeListed(c,17243025) and c:IsType(TYPE_SPELL)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local gg = Duel.GetMatchingGroup(s.chkfilter,tp,0x3,0,nil)
	if not gg then return true end
	if #gg>16 and Duel.GetFlagEffect(tp,17243025)<=0 then
		Duel.RegisterFlagEffect(tp,17243025,0,0,0)
	end
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end

function s.lmffilter(c)
	return c:IsFaceup() and c:IsCode(36700304)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
	if Duel.IsExistingMatchingCard(s.lmffilter,tp,LOCATION_MZONE,0,1,nil) then
		--自己不会因为基本分变成0而决斗失败
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
		e3:SetTargetRange(1,0)
		e3:SetValue(1)
		e3:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e3,tp)
	end
end

-- 效果伤害条件
function s.quickcon_effect(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and (r&REASON_EFFECT+REASON_BATTLE)~=0 and Duel.GetFlagEffect(tp,id)<=0
end

-- 快速发动操作
function s.quickop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--act qp in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(0xff)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,id))
	e2:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e2)
	Duel.RegisterFlagEffect(tp,id,0,0,1)

end

-- 手牌中的路明非·七宗罪过滤器
function s.quickfilter(c)
	return c:IsCode(36700352) and c:IsLocation(LOCATION_HAND) 
end

-- 快速特殊召唤目标
function s.quicktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

-- 快速特殊召唤操作
function s.quickop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 then
		Duel.SpecialSummon(c,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
	end
end
