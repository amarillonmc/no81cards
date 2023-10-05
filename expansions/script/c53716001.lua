if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local m=53716001
local cm=_G["c"..m]
cm.name="断片折光 幻想匿国"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	local e1,e1_1,e2,e3=SNNM.ActivatedAsSpellorTrap(c,0x20004,LOCATION_EXTRA)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.op)
	SNNM.ActivatedAsSpellorTrapCheck(c)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
end
function cm.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_MONSTER)
end
function cm.fselect(g,res)
	return (res and #g~=2 and (g:IsExists(Card.IsSetCard,1,nil,0x553b) or #g==3)) or (not res and #g==3)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cost=Duel.GetMatchingGroup(function(c)return c:GetType()&0x20004==0x20004 and c:IsReleasable()end,tp,LOCATION_ONFIELD,0,e:GetHandler())
	local res=Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_END
	if chk==0 then return cost:CheckSubGroup(cm.fselect,1,3,res) and not e:GetHandler():IsForbidden() and e:GetHandler():CheckUniqueOnField(tp) and Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=cost:SelectSubGroup(tp,cm.fselect,false,1,3,res)
	local cg=g:Filter(Card.IsFacedown,nil)
	if #cg>0 then Duel.ConfirmCards(1-tp,cg) end
	Duel.Release(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(cm.disable)
	e5:SetCode(EFFECT_DISABLE)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	e6:SetTarget(cm.attack)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,3))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_SZONE)
	e7:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e7:SetCondition(cm.spcon)
	e7:SetTarget(cm.sptg)
	e7:SetOperation(cm.spop)
	c:RegisterEffect(e7)
end
function cm.disable(e,c)
	local ct1=aux.GetColumn(e:GetHandler())
	local ct2=aux.GetColumn(c)
	if not ct1 or not ct2 then return false end
	return (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT) and math.abs(ct1-ct2)==0 and c:GetSequence()<5
end
function cm.attack(e,c)
	local ct1=aux.GetColumn(e:GetHandler())
	local ct2=aux.GetColumn(c)
	if not ct1 or not ct2 then return false end
	return math.abs(ct1-ct2)==0 and c:GetSequence()<5
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function cm.filter(c,tp)
	return c:IsFaceup() and c:GetType()&0x20004==0x20004 and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,TYPES_NORMAL_TRAP_MONSTER,2500,2500,4,RACE_PSYCHO,ATTRIBUTE_WIND)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and cm.filter(chkc,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.IsPlayerCanSpecialSummonCount(tp,1) and Duel.IsExistingTarget(cm.filter,tp,LOCATION_REMOVED,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_REMOVED,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or Duel.GetMZoneCount(tp)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,tc:GetCode(),nil,TYPES_NORMAL_TRAP_MONSTER,2500,2500,4,RACE_PSYCHO,ATTRIBUTE_WIND) then return end
	tc:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP)
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(RACE_PSYCHO)
	e1:SetReset(RESET_EVENT+0x47c0000)
	tc:RegisterEffect(e1,true)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e3:SetValue(ATTRIBUTE_WIND)
	tc:RegisterEffect(e3,true)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_SET_BASE_ATTACK)
	e4:SetValue(2500)
	tc:RegisterEffect(e4,true)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_SET_BASE_DEFENSE)
	e5:SetValue(2500)
	tc:RegisterEffect(e5,true)
	local e6=e1:Clone()
	e6:SetCode(EFFECT_CHANGE_LEVEL)
	e6:SetValue(4)
	tc:RegisterEffect(e6,true)
	Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
end
