--天基兵器发射井
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c33330048") end) then require("script/c33330048") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
--e1
function cm.opf1(c,e,tp)
	return c:IsSetCard(0x564) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsType(TYPE_MONSTER)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return end
	local g=Duel.GetMatchingGroup(cm.opf1,tp,LOCATION_HAND,0,nil,e,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,1,1,nil):GetFirst()
		if Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)<=0 then return end
		g:CompleteProcedure()
		g=Duel.GetMatchingGroup(cm.opf1,tp,LOCATION_REMOVED,0,nil,e,tp)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			g=g:Select(tp,1,1,nil):GetFirst()
			Duel.BreakEffect()
			Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
			g:CompleteProcedure()
		end
	end
end
--e2
function cm.tgf2(c)
	return c:IsSetCard(0x564) and c:IsAbleToRemove()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgf2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,cm.tgf2,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
		if tc:IsType(TYPE_MONSTER) then Rule_SpaceWeapon.TempRemove(e:GetHandler(),tc)
		else
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetRange(LOCATION_REMOVED)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
			e1:SetCondition(cm.op2_con)
			e1:SetOperation(cm.op2_op)
			tc:RegisterEffect(e1)
		end
	end
end
function cm.op2_con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.op2_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsSSetable() then Duel.SSet(tp,c) end
end