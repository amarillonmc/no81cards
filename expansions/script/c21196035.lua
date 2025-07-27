--皇庭学院的图书馆
local m=21196035
local cm=_G["c"..m]
function cm.initial_effect(c)
	if not imperial_court then
		imperial_court=true
		Duel.LoadScript("c21196001.lua")
		in_count.card = c
		local ce1=Effect.CreateEffect(c)
		ce1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ce1:SetCode(EVENT_PHASE+PHASE_END)
		ce1:SetCountLimit(1)
		ce1:SetOperation(function(e)
			for tp = 0,1 do
				if not Duel.IsPlayerAffectedByEffect(tp,21196000) then
					in_count.reset(tp)
				end
			end
		end)
		Duel.RegisterEffect(ce1,0)
	end
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(cm.cost0)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.con2)
	e2:SetCost(cm.cost2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
cm.settype_amp=true
function cm.cost0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return in_count[tp] >= 1 end
	in_count.add(tp,-1)
end
function cm.q(c,e,tp)
	return c:IsSetCard(0x5919) and c:IsLevelBelow(8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,4)>0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.q,tp,0x12,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x12)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.q),tp,0x12,0,1,1,nil,e,tp)
	if #g>0 then 
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.w(c,e,tp)
	return c:IsSetCard(0x5919) and c:IsLocation(0x10) and c:IsType(1) and c:IsAbleToHand() and c:GetControler()==tp and c:IsCanBeEffectTarget(e)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.w,1,nil,e,tp)
end
function cm.e(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	if in_count[tp] >= 1 and Duel.IsExistingMatchingCard(cm.e,tp,4,4,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
	e:SetLabel(1)
	in_count.add(tp,-1)
	end
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(cm.w,nil,e,tp)
	if chk==0 then return #g>0 end
	Duel.Hint(3,tp,HINTMSG_ATOHAND)
	local tg=g:Select(tp,1,1,nil)
	Duel.SetTargetCard(tg)
	if e:GetLabel()==1 then
	e:SetCategory(e:GetCategory()+CATEGORY_POSITION)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,1,tp,0x10)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(2) and e:GetLabel()==1 and Duel.IsExistingMatchingCard(cm.e,tp,0,4,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
	Duel.BreakEffect()
	Duel.Hint(3,tp,HINTMSG_POSITION)
	local g=Duel.SelectMatchingCard(tp,cm.e,tp,4,4,1,1,nil)
		if #g>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)	
		end	
	end
end