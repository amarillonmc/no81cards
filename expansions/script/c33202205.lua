--纸影剧团 致幻彩蝶
local s,id=GetID()
local TOKEN_ILLUSORY_BUTTERFLY=33202206
function s.initial_effect(c)
	--相同纵列有对方卡存在时，盖放回合也能发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetCondition(s.setcon)
	c:RegisterEffect(e0)
	--①：变成陷阱怪兽并使对方场上1张卡的效果无效
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--②：除外自身并特殊召唤衍生物
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.tkcost)
	e2:SetTarget(s.tktg)
	e2:SetOperation(s.tkop)
	c:RegisterEffect(e2)
end
function s.columnfilter(c,p)
	return c:IsControler(p)
end
function s.hasopponentcolumn(c)
	local tp=c:GetControler()
	return c:GetColumnGroup():IsExists(s.columnfilter,1,nil,1-tp)
end
function s.colfilter(c,tc)
	return c~=tc
end

function s.setcon(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return c:GetColumnGroup():IsExists(s.colfilter,1,nil,tc)
end
function s.disfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER|TYPE_EFFECT|TYPE_TRAP,1600,1000,4,RACE_INSECT,ATTRIBUTE_WIND) and Duel.IsExistingMatchingCard(s.disfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	e:SetLabel(s.hasopponentcolumn(c) and 1 or 0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_ONFIELD)
end
function s.decksetfilter(c)
	return c:IsSetCard(0x6328) and not c:IsCode(id) and c:IsSSetable()
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER|TYPE_EFFECT|TYPE_TRAP,1600,1000,4,RACE_INSECT,ATTRIBUTE_WIND) then return end
	c:AddMonsterAttribute(TYPE_EFFECT|TYPE_TRAP,ATTRIBUTE_WIND,RACE_INSECT,4,1600,1000)
	if Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)==0 then return end
	Duel.SpecialSummonComplete()
	if not Duel.IsExistingMatchingCard(s.disfilter,tp,0,LOCATION_ONFIELD,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
	local g=Duel.SelectMatchingCard(tp,s.disfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	tc:RegisterEffect(e2)
	if e:GetLabel()~=1 or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not Duel.IsExistingMatchingCard(s.decksetfilter,tp,LOCATION_DECK,0,1,nil) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=Duel.SelectMatchingCard(tp,s.decksetfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #sg>0 then
		Duel.SSet(tp,sg)
	end
end
function s.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return TOKEN_ILLUSORY_BUTTERFLY~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_ILLUSORY_BUTTERFLY,0,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,4,RACE_INSECT,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	if TOKEN_ILLUSORY_BUTTERFLY==0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,TOKEN_ILLUSORY_BUTTERFLY,0,TYPES_TOKEN_MONSTER+TYPE_TUNER,0,0,4,RACE_INSECT,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,TOKEN_ILLUSORY_BUTTERFLY)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end