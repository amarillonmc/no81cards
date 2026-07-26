--纸影剧团 魅影邪鹿
local s,id=GetID()
local SET_PAPER_SHADOW=0x6328

function s.initial_effect(c)
	--①：变成陷阱怪兽特殊召唤并检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+10000)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	--满足条件时可以从手卡发动
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)

	--②：除外自身，使「纸影剧」卡不会被效果破坏
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id)
	e3:SetCost(s.indcost)
	e3:SetTarget(s.indtg)
	e3:SetOperation(s.indop)
	c:RegisterEffect(e3)
end

s.listed_series={SET_PAPER_SHADOW}

--自己场上没有「纸影剧」卡以外的怪兽
function s.handfilter(c)
	return c:IsFacedown() or not c:IsSetCard(SET_PAPER_SHADOW)
end

function s.handcon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(s.handfilter,tp,LOCATION_MZONE,0,1,nil)
end

--卡组中可以加入手卡的「纸影剧」卡
function s.thfilter(c)
	return c:IsSetCard(SET_PAPER_SHADOW) and not c:IsCode(id) and c:IsAbleToHand()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER+TYPE_EFFECT,1500,1500,4,RACE_BEAST,ATTRIBUTE_EARTH)
			and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	end

	local cg=c:GetColumnGroup()
	e:SetLabel(cg:IsExists(Card.IsControler,1,nil,1-tp) and 1 or 0)

	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)

	if e:GetLabel()==1 then
		Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,tp,LOCATION_MZONE)
	end
end

function s.setfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER+TYPE_EFFECT,1500,1500,4,RACE_BEAST,ATTRIBUTE_EARTH) then return end

	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 or Duel.SendtoHand(g,nil,REASON_EFFECT)==0 then return end
	Duel.ConfirmCards(1-tp,g)

	if e:GetLabel()~=1 then return end
	if not Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_MZONE,0,1,nil) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(id,3)) then return end

	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=sg:GetFirst()
	if tc then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end

--②：除外墓地的这张卡
function s.indcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end

function s.indfilter(c,e)
	return c:IsFaceup() and c:IsSetCard(SET_PAPER_SHADOW) and c:IsCanBeEffectTarget(e)
end

function s.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and s.indfilter(chkc,e)
	end
	if chk==0 then return Duel.IsExistingTarget(s.indfilter,tp,LOCATION_ONFIELD,0,1,nil,e) end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.indfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e)
end

function s.indop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end

	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,4))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
end