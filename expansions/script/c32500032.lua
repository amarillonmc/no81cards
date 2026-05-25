--反叛 C世界
--卡号：32500019
--反叛字段代码：0xa001
--场地魔法

local s,id=GetID()
local SET_REBELLION=0xa001

function s.initial_effect(c)
	--①：作为这张卡发动时的效果处理，从卡组检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg1)
	e1:SetOperation(s.thop1)
	c:RegisterEffect(e1)

	--②：自己的结束阶段，除外状态的对应怪兽加入手卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(s.thcon2)
	e2:SetTarget(s.thtg2)
	e2:SetOperation(s.thop2)
	c:RegisterEffect(e2)

	--③：自己场上的对应怪兽攻击力上升自己场上的怪兽数量×100
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(s.atktg3)
	e3:SetValue(s.val3)
	c:RegisterEffect(e3)

	--③：自己场上的对应怪兽守备力上升自己场上的怪兽数量×100
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
end

--光・暗属性的战士族・魔法师族怪兽
function s.monfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
		and (c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER))
end

--①：检索用过滤
function s.thfilter1(c)
	return s.monfilter(c) and c:IsAbleToHand()
end

function s.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop1(e,tp,eg,ep,ev,re,r,rp)
	--从卡组将1只光・暗属性的战士族・魔法师族怪兽加入手卡
	if Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end

	--这个效果发动后，直到回合结束时自己不是光・暗属性的战士族・魔法师族怪兽不能特殊召唤
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

--②：自己的结束阶段
function s.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end

--②：除外状态的自己的光・暗属性的战士族・魔法师族怪兽
function s.thfilter2(c)
	return c:IsFaceup()
		and s.monfilter(c)
		and c:IsAbleToHand()
end

function s.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp)
			and chkc:IsLocation(LOCATION_REMOVED)
			and s.thfilter2(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(s.thfilter2,tp,LOCATION_REMOVED,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter2,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_REMOVED)
end

function s.thop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

--③：自己场上的光・暗属性的战士族・魔法师族怪兽
function s.atktg3(e,c)
	return s.monfilter(c)
end

--③：上升自己场上的怪兽数量×100
function s.val3(e,c)
	return Duel.GetMatchingGroupCount(Card.IsMonster,c:GetControler(),LOCATION_MZONE,0,nil)*100
end

--自肃：不是光・暗属性的战士族・魔法师族怪兽不能特殊召唤
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
		and (c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER)))
end