--No.32 海咬龙 鲨龙兽·浮上白煞
local s,id,o=GetID()
function c98920778.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,4,s.ovfilter,aux.Stringid(id,0),4,s.xyzop)
	c:EnableReviveLimit()
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(1)
	e2:SetCondition(c98920778.actcon)
	c:RegisterEffect(e2)
	--chain attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920778,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(c98920778.atcon)
	e1:SetCost(c98920778.atcost)
	e1:SetTarget(c98920778.attg)
	e1:SetOperation(c98920778.atop)
	c:RegisterEffect(e1)
end
aux.xyz_number[id]=32
function s.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsRank(4) and c:IsSetCard(0x11b8)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,s.cfilter,1,1,REASON_SPSUMMON+REASON_DISCARD)
end
function c98920778.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c98920778.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c==Duel.GetAttacker() and c:IsRelateToBattle() and c:IsStatus(STATUS_OPPO_BATTLE)
		and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c98920778.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98920778.spfilter(c,e,tp)
	if not (c:IsRank(4) and c:IsSetCard(0x11b8) and c:IsType(TYPE_XYZ)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then return false end
	if c:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	else
		return Duel.GetMZoneCount(tp)>0
	end
end
function c98920778.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920778.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.GetAttackTarget():CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,Duel.GetAttackTarget(),1,0,0)
end
function c98920778.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=Duel.GetAttackTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920778.spfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
		if not bc:IsRelateToEffect(e) or not bc:IsCanOverlay() then return end
		if bc:IsLocation(LOCATION_GRAVE) then
			Duel.BreakEffect()
			if not tc:IsImmuneToEffect(e) then
				Duel.Overlay(tc,Group.FromCards(bc))
			end
		end
	end
end