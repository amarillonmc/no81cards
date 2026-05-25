--催化形兽 稀土杉
local s,id,o=GetID()
local SET_METAFORM=0x9D71
local CARD_HYDROGEN_EAGLE=21401290
local CARD_CARBON_CRAB=21401292
local CARD_OXYGEN_BULL=21401294

local METAFORM_LISTED={
	[CARD_HYDROGEN_EAGLE]={atk=1400,def=700},
	[CARD_CARBON_CRAB]={atk=700,def=1400},
	[CARD_OXYGEN_BULL]={atk=0,def=2100}
}

function s.initial_effect(c)
	--不能通常召唤
	c:EnableReviveLimit()

	--特殊召唤手续：从卡组把1张有「化形兽」怪兽卡名记述的魔法·陷阱卡送去墓地
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	--② 只要这张卡在怪兽区域存在，自己不是炎属性怪兽不能特殊召唤
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.splimit)
	c:RegisterEffect(e2)

	--③ 攻击破坏对方怪兽时，可以继续攻击
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.atkcon)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)

	--④ 结束阶段，墓地回手
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,id)
	e4:SetCost(s.thcost)
	e4:SetTarget(s.thtg)
	e4:SetOperation(s.thop)
	c:RegisterEffect(e4)
end

--==============================
-- 特殊召唤手续
--==============================
function s.get_listed_codes(c)
	local t={}
	for code,_ in pairs(METAFORM_LISTED) do
		if aux.IsCodeListed(c,code) then
			table.insert(t,code)
		end
	end
	return t
end

function s.costfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
		and c:IsAbleToGraveAsCost()
		and #s.get_listed_codes(c)>0
end

function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK,0,1,nil)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local tp=c:GetControler()

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end

	local codes=s.get_listed_codes(tc)
	if #codes==0 then return end

	local code=codes[1]
	if #codes>1 then
		code=Duel.AnnounceCard(tp,table.unpack(codes))
	end

	local info=METAFORM_LISTED[code]
	if not info then return end

	if Duel.SendtoGrave(g,REASON_COST)==0 then return end

	--① 这个方法特殊召唤的这张卡适用状态
	--在特殊召唤前注册，所以去掉 RESET_TOFIELD，避免到场时重置
	s.register_sp_effects(c,code,info.atk*2,info.def*2)
end

function s.register_sp_effects(c,code,atk,def)
	--卡名当作送去墓地的卡记述的那个卡名使用
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(code)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	c:RegisterEffect(e1)

	--攻击力变成记述攻击力的2倍
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetValue(atk)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	c:RegisterEffect(e2)

	--守备力变成记述守备力的2倍
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e3:SetValue(def)
	c:RegisterEffect(e3)
end

--==============================
-- ② 特殊召唤限制
--==============================
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_FIRE)
end

--==============================
-- ③ 攻击破坏对方怪兽时，可以继续攻击
--==============================
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle()
		and Duel.GetAttacker()==c
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToBattle() or c:IsFacedown() then return end

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end

--==============================
-- ④ 结束阶段：解放自己场上1只怪兽，墓地回手
--==============================
function s.thcostfilter(c)
	return c:IsReleasable()
end

function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.thcostfilter,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.thcostfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHand()
			and aux.NecroValleyFilter()(c)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,LOCATION_GRAVE)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e)
		and aux.NecroValleyFilter()(c) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
