function c4875050.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),10,2,c4875050.ovfilter,aux.Stringid(4875050,0))
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	c:SetUniqueOnField(1,0,4875050,LOCATION_ONFIELD)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetValue(c4875050.indct)
	c:RegisterEffect(e1)
	--overlay
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4875050,2))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c4875050.ovlcon)
	e2:SetCountLimit(1,4875050)
	e2:SetTarget(c4875050.ovltg)
	e2:SetOperation(c4875050.ovlop)
	c:RegisterEffect(e2)
	--to pendulum
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4875050,3))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c4875050.pencon)
	e3:SetTarget(c4875050.pentg)
	e3:SetOperation(c4875050.penop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,4875051)
	e4:SetCondition(c4875050.spcon)
	e4:SetTarget(c4875050.sptg)
	e4:SetOperation(c4875050.spop)
	c:RegisterEffect(e4)
end 
function c4875050.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c4875050.spfilter(c,e,tp)
	return c:IsSetCard(0x10af) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and not c:IsCode(4875050)
end
function c4875050.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
if chk==0 then return Duel.IsExistingMatchingCard(c4875050.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c4875050.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c4875050.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c4875050.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		return 1
	else return 0 end
end
function c4875050.splimit(e,c)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
function c4875050.limcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c4875050.limtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

function c4875050.limop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c4875050.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c4875050.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_MONSTER) and re:GetHandler():IsLevelAbove(5)
end
function c4875050.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10af)
end
function c4875050.ovlcon(e,tp,eg,ep,ev,re,r,rp)
if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
		local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)  
	local ex1,tg1,tc1=Duel.GetOperationInfo(ev,CATEGORY_TOEXTRA)
	local ex2,tg2,tc2=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)  
	local ex3,tg3,tc3=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	local ex4,tg4,tc4=Duel.GetOperationInfo(ev,CATEGORY_TODECK)  
	local ex5,tg5,tc5=Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE)  
	local ex6,tg6,tc6=Duel.GetOperationInfo(ev,CATEGORY_CONTROL)
	local ex7,tg7,tc7=Duel.GetOperationInfo(ev,CATEGORY_RELEASE)
	return ((ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0)
	or (ex1 and tg1~=nil and tc1+tg1:FilterCount(Card.IsOnField,nil)-tg1:GetCount()>0)
	or (ex2 and tg2~=nil and tc2+tg2:FilterCount(Card.IsOnField,nil)-tg2:GetCount()>0)
	or (ex3 and tg3~=nil and tc3+tg3:FilterCount(Card.IsOnField,nil)-tg3:GetCount()>0)
	or (ex4 and tg4~=nil and tc4+tg4:FilterCount(Card.IsOnField,nil)-tg4:GetCount()>0)
	or (ex5 and tg5~=nil and tc5+tg5:FilterCount(Card.IsOnField,nil)-tg5:GetCount()>0)
	or (ex6 and tg6~=nil and tc6+tg6:FilterCount(Card.IsOnField,nil)-tg6:GetCount()>0)
	or (ex7 and tg7~=nil and tc7+tg7:FilterCount(Card.IsOnField,nil)-tg7:GetCount()>0))
end
function c4875050.ovltgfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0xae) and c:IsAbleToRemoveAsCost()
end
function c4875050.ovltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if chk==0 then return c:GetFlagEffect(4875050)==0
		and (c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
			or Duel.IsExistingMatchingCard(c4875050.ovltgfilter,tp,LOCATION_GRAVE,0,1,nil))
		and rc:IsRelateToEffect(re)  end
	c:RegisterFlagEffect(4875050,RESET_CHAIN,0,1)
end
function c4875050.ovlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local opt1=c:IsRelateToEffect(e) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
	local opt2=Duel.IsExistingMatchingCard(c4875050.ovltgfilter,tp,LOCATION_GRAVE,0,1,nil)
	local result=0
	if not opt1 and not opt2 then return end
	if opt1 and not opt2 then result=0 end
	if opt2 and not opt1 then result=1 end
	if opt1 and opt2 then result=Duel.SelectOption(tp,aux.Stringid(4875050,5),aux.Stringid(4875050,6)) end
	if result==0 then
		result=c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c4875050.ovltgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.HintSelection(g)
		result=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	if result>0 and c:IsRelateToEffect(e) and Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) and not rc:IsImmuneToEffect(e) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c4875050.pencon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c4875050.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c4875050.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
