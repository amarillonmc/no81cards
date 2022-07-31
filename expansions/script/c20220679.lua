--No.95 ギャラクシーアイズ・ダークマター・ドラゴン
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,3,s.ovfilter,aux.Stringid(id,4))
	c:EnableReviveLimit()
   	--Enable pendulum summon
	aux.EnablePendulumAttribute(c,false)
    --disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(s.distg)
	c:RegisterEffect(e3)
   	--Special Summon
	local e22=Effect.CreateEffect(c)
	e22:SetDescription(aux.Stringid(id,3))
	e22:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e22:SetType(EFFECT_TYPE_IGNITION)
	e22:SetRange(LOCATION_PZONE)
    e22:SetCountLimit(1,id)
	e22:SetCost(s.spcost)
	e22:SetTarget(s.sptg)
	e22:SetOperation(s.spop)
	c:RegisterEffect(e22)
    --特殊召唤不能被无效
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e0)
	--xyzlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,id)
	e2:SetCost(s.rmcost)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
 	--banish
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
 	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetCountLimit(1,id)
	e4:SetTarget(s.bantg)
	e4:SetOperation(s.banop)
	c:RegisterEffect(e4)
 	--multi attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.val)
	c:RegisterEffect(e2)
   	--pendulum
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(id,2))
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e12:SetCode(EVENT_LEAVE_FIELD)
	e12:SetProperty(EFFECT_FLAG_DELAY)
	e12:SetCondition(s.pencon)
	e12:SetTarget(s.pentg)
	e12:SetOperation(s.penop)
	c:RegisterEffect(e12)
end
s.xyz_number=95
s.pendulum_level=9
function s.chlimit(e,ep,tp)
    return tp==ep
end
function s.ovfilter(c,tp,xyzc)
	return c:IsFaceup() and c:IsSetCard(0x107b,xyzc,SUMMON_TYPE_XYZ,tp) and c:IsType(TYPE_XYZ,xyzc,SUMMON_TYPE_XYZ,tp)
end
function s.cfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToGraveAsCost()
end
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>1 end
	local tg=Group.CreateGroup()
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
		tg:Merge(sg)
	end
	Duel.SendtoGrave(tg,REASON_COST)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>1
		and not Duel.IsPlayerAffectedByEffect(1-tp,30459350) end
    Duel.SetChainLimit(s.chlimit)
end
function s.rmfilter(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(1-tp,30459350) then return end
	local g=Duel.GetMatchingGroup(s.rmfilter,1-tp,LOCATION_HAND,0,nil)
	if #g>2 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:Select(1-tp,2,2,nil)
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	end
end
function s.banfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToGrave()
end
function s.banfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function s.bantg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.banfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
    Duel.SetChainLimit(s.chlimit)
end
function s.banop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.banfilter,tp,LOCATION_DECK,0,1,ct,nil)
	if #g>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT) then
			local sg=Duel.GetMatchingGroup(s.banfilter2,tp,0,LOCATION_DECK,nil)
			if #sg>=#g then
				Duel.ConfirmCards(tp,sg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local ban=sg:Select(tp,1,#g,nil)
				Duel.Remove(ban,POS_FACEDOWN,REASON_EFFECT)
			else
				local dg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
				Duel.ConfirmCards(tp,dg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local ban=sg:Select(tp,1,#g,nil)
				Duel.Remove(ban,POS_FACEDOWN,REASON_EFFECT)
			end
		end
	end
end
function s.val(e,c)
	return c:GetOverlayCount()
end
function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsPreviousPosition(POS_FACEUP)
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
	Duel.SetTargetCard(e:GetHandler())
    Duel.SetChainLimit(s.chlimit)
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function s.distg(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsLevel(0)
end
function s.spfilter1(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsReleasable()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local loc=LOCATION_ONFIELD
	if ft==0 then loc=LOCATION_MZONE end
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter1,tp,loc,0,1,e:GetHandler(),e,tp) end
	local g=Duel.SelectMatchingCard(tp,s.spfilter1,tp,loc,0,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end