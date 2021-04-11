--黑钢国际·重装干员-雷蛇·脉冲电弧
function c79029441.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,9,2,nil,nil,99)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAIABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c79029441.lvtg)
	e1:SetValue(c79029441.lvval)
	c:RegisterEffect(e1)
	--defense attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DEFENSE_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)	
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c79029441.atkval)
	c:RegisterEffect(e3)
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c79029441.spcon1)
	e4:SetTarget(c79029441.sptg)
	e4:SetCost(c79029441.spcost)
	e4:SetCountLimit(1,79029441)
	e4:SetOperation(c79029441.spop)
	c:RegisterEffect(e4)  
	local e5=e4:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetCondition(c79029441.spcon2)
	c:RegisterEffect(e5)	
	--set or to grave
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c79029441.spcon1)
	e6:SetCost(c79029441.sgcost)
	e6:SetTarget(c79029441.sgtg)
	e6:SetOperation(c79029441.sgop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetHintTiming(0,TIMING_END_PHASE)
	e7:SetCondition(c79029441.spcon2)
	c:RegisterEffect(e7)  
end
function c79029441.lvtg(e,c)
	return c:IsLevelAbove(7) and c:IsSetCard(0x1904)
end
function c79029441.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 9
	else return lv end
end
function c79029441.ctfil(c)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0x1904)
end
function c79029441.atkval(e,c)
	local tp=e:GetHandler():GetControler()
	return Duel.GetMatchingGroupCount(c79029441.ctfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)*1000
end
function c79029441.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,79029436)
end
function c79029441.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,79029436)
end
function c79029441.rfilter(c,tp)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0x1904) and c:IsAbleToGraveAsCost()
end
function c79029441.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c79029441.rfilter,c:GetControler(),LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_HAND,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c79029441.rfilter,tp,LOCATION_ONFIELD+LOCATION_REMOVED+LOCATION_HAND,0,3,3,nil)
	Duel.SendtoGrave(g,REASON_COST)
	Debug.Message("等待下一步指示。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029441,4))
end
function c79029441.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029441.spop(e,tp,eg,ep,ev,re,r,rp,c)
   local c=e:GetHandler()
   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c79029441.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
local c=e:GetHandler()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)  and c:GetFlagEffect(79029441)==0 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	c:RegisterFlagEffect(79029441,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,0,0)
end
function c79029441.tgfil(c)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0x1904) and c:IsAbleToGrave()
end
function c79029441.stfil(c)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0x1904) and c:IsSSetable()
end
function c79029441.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c79029441.tgfil,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c79029441.stfil,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
	op=Duel.SelectOption(tp,aux.Stringid(79029441,0),aux.Stringid(79029441,1))
	elseif b1 then
	op=Duel.SelectOption(tp,aux.Stringid(79029441,0))
	else
	op=Duel.SelectOption(tp,aux.Stringid(79029441,1))+1 
	end
	e:SetLabel(op)
	if op==0 then
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	end
end
function c79029441.sgop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
	Debug.Message("我已就位。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029441,2))
	g1=Duel.GetMatchingGroup(c79029441.tgfil,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	dg=g1:Select(tp,1,1,nil)
	Duel.SendtoGrave(dg,REASON_EFFECT)
	else
	Debug.Message("出击许可已经下达。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029441,3))
	g2=Duel.GetMatchingGroup(c79029441.stfil,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	tc=g2:Select(tp,1,1,nil):GetFirst()
	Duel.SSet(tp,tc)
	--
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end