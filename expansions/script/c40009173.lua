--狂风剑刃·超限
function c40009173.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c40009173.mfilter,7,2,c40009173.ovfilter,aux.Stringid(40009173,0),2,c40009173.xyzop)
	c:EnableReviveLimit()  
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(40009154)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009173,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,40009173+EFFECT_COUNT_CODE_DUEL)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e2:SetCondition(c40009173.atkcon)
	e2:SetTarget(c40009173.atkktg)
	e2:SetOperation(c40009173.atkop)
	c:RegisterEffect(e2)
	--to grave
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(40009173,1))
	e8:SetCategory(CATEGORY_TOGRAVE)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetRange(LOCATION_MZONE)
	e8:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e8:SetCountLimit(1)
	e8:SetCost(c40009173.spcost)
	e8:SetTarget(c40009173.tgtg)
	e8:SetOperation(c40009173.tgop)
	c:RegisterEffect(e8)   
end
function c40009173.mfilter(c)
	return c:IsRace(RACE_WARRIOR) 
end
function c40009173.ovfilter(c)
	return c:IsFaceup() and c:IsCode(40009154)
end
function c40009173.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,40009173)==0 end
	Duel.RegisterFlagEffect(tp,40009173,RESET_PHASE+PHASE_END,0,1)
end
function c40009173.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c40009173.atkktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetChainLimit(c40009173.chlimit)
end
--function c40009173.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
   -- local c=e:GetHandler()
   -- if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
   -- local flag=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
   -- e:SetLabel(flag)
   -- Duel.Hint(HINT_ZONE,tp,flag)
--end
function c40009173.chlimit(e,ep,tp)
	return tp==ep
end
function c40009173.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c40009173.atktg1)
	e1:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	Duel.RegisterEffect(e1,tp)
	--Duel.SetChainLimit(c40009173.chlimit)
end
function c40009173.atktg1(e,c)
	return c:GetSequence()>=5
end
function c40009173.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c40009173.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE+LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_MZONE+LOCATION_HAND)
end
function c40009173.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_MZONE+LOCATION_HAND,0,nil,TYPE_MONSTER)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE)
	end
end