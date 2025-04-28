--六道五轮·俱利伽罗天象
function c22022630.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,5,c22022630.ovfilter,aux.Stringid(22022630,0),5,c22022630.xyzop)
	c:EnableReviveLimit()
	--battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--ex atk 1
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22022630,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c22022630.atcon)
	e3:SetCost(c22022630.atcost1)
	e3:SetTarget(c22022630.attg1)
	e3:SetOperation(c22022630.atop)
	c:RegisterEffect(e3)
	--ex atk 2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22022630,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c22022630.atcon)
	e3:SetCost(c22022630.atcost2)
	e3:SetTarget(c22022630.attg2)
	e3:SetOperation(c22022630.atop)
	c:RegisterEffect(e3)
	--ex atk 3
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22022630,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c22022630.atcon)
	e3:SetCost(c22022630.atcost3)
	e3:SetTarget(c22022630.attg3)
	e3:SetOperation(c22022630.atop)
	c:RegisterEffect(e3)
	--ex atk 4
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22022630,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c22022630.atcon)
	e3:SetCost(c22022630.atcost4)
	e3:SetTarget(c22022630.attg4)
	e3:SetOperation(c22022630.atop)
	c:RegisterEffect(e3)
	--Summon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(22022630,2))
	e7:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetOperation(c22022630.rpop)
	c:RegisterEffect(e7)
end
function c22022630.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ)
end
function c22022630.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end
function c22022630.cfilter(c)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c22022630.ovfilter(c)
	return c:IsFaceup() and c:IsCode(22021760)
end
function c22022630.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22022630.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c22022630.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c22022630.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	e:SetLabelObject(bc)
	return c==Duel.GetAttacker() and aux.dsercon(e)
		and bc and c:IsStatus(STATUS_OPPO_BATTLE) and bc:IsOnField() and bc:IsRelateToBattle()
end
function c22022630.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,1000,REASON_EFFECT)
	Duel.ChainAttack()
end
function c22022630.rpfilter(c,e,tp)
	return c:IsCode(22021760) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22022630.rpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoGrave(c,REASON_EFFECT) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c22022630.rpfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22022630,3)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
	end
end
function c22022630.atcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	e:GetHandler():RegisterFlagEffect(22022630,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	Duel.SelectOption(tp,aux.Stringid(22022630,4))
end
function c22022630.atcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	e:GetHandler():RegisterFlagEffect(22022631,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	Duel.SelectOption(tp,aux.Stringid(22022630,5))
end
function c22022630.atcost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	e:GetHandler():RegisterFlagEffect(22022632,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	Duel.SelectOption(tp,aux.Stringid(22022630,6))
end
function c22022630.atcost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.SelectOption(tp,aux.Stringid(22022630,7))
	Duel.Hint(HINT_CARD,0,22022630)
end
function c22022630.attg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c22022630.attg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(22022630)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c22022630.attg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(22022631)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c22022630.attg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(22022632)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end